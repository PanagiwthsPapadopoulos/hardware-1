// `include "regfile.v"
// `include "alu.v"

module datapath #(
    parameter INITIAL_PC = 32'h00400000  // Αρχική διεύθυνση του PC
)(
    input wire clk,                      // Ρολόι
    input wire rst,                      // Σύγχρονο reset
    input wire [31:0] instr,             // Εντολές από τη μνήμη εντολών
    input wire PCSrc,                    // Επιλογή της πηγής για το PC
    input wire ALUSrc,                   // Επιλογή της πηγής για τον δεύτερο τελεστή της ALU
    input wire RegWrite,                 // Ενεργοποίηση εγγραφής στους καταχωρητές
    input wire MemToReg,                 // Επιλογή του δεδομένου εγγραφής στους καταχωρητές
    input wire [3:0] ALUCtrl,            // Σήμα ελέγχου της ALU
    input wire loadPC,                   // Ενεργοποίηση ενημέρωσης του PC
    input wire [31:0] dReadData,         // Δεδομένα από τη μνήμη δεδομένων
    output wire [31:0] PC,               // Program Counter
    output wire Zero,                    // Έξοδος μηδενισμού ALU
    output wire [31:0] dAddress,         // Διεύθυνση για τη μνήμη δεδομένων
    output wire [31:0] dWriteData,       // Δεδομένα προς εγγραφή στη μνήμη δεδομένων
    output wire [31:0] WriteBackData     // Δεδομένα για εγγραφή στους καταχωρητές
);

     // Operation Types
    localparam RTYPE = 7'b0110011,
               ITYPE = 7'b0010011,
               STYPE = 7'b0100011,
               BTYPE = 7'b1100011,
               LOAD = 7'b0000011;

    // 1. Καταχωρητής Program Counter (PC)
    reg [31:0] currentPC;
    always @(posedge clk or posedge rst) begin
            // $display("ALUSrc: %d and immediate value: %d", ALUSrc, imm);

        if (rst)
            currentPC <= INITIAL_PC; // Reset στην αρχική διεύθυνση
        else if (loadPC) begin
            currentPC <= PCSrc ? (currentPC + {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0}) : (currentPC + 4);
            // $display("Updating PC. Instr: %d", instr);
        end
    end
    assign PC = currentPC;

    // 2. Register File
    wire [4:0] readReg1 = instr[19:15];  // Rs1
    wire [4:0] readReg2 = (instr[7:0] == ITYPE) ? 5'bxxxxx : instr[24:20];  // Rs2
    wire [4:0] writeReg = instr[11:7];   // Rd
    wire [31:0] readData1, readData2;
    
    regfile register_file (
        .clk(clk),
        .readReg1(readReg1),
        .readReg2(readReg2),
        .writeReg(writeReg),
        .writeData(WriteBackData),
        .write(RegWrite),
        .readData1(readData1),
        .readData2(readData2)
    );

    // 3. Immediate Generation
    wire [31:0] imm_I_L = {{20{instr[31]}}, instr[31:20]}; // Immediate για τύπο I
    wire [31:0] imm_S = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // Immediate για τύπο S
    wire [31:0] imm_B = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0}; // Immediate για τύπο B
    wire [31:0] imm = (STYPE == instr[6:0]) ? imm_S : (BTYPE == instr[6:0]) ? imm_B : imm_I_L;
    // case (instr[6:0])
    
    //     ITYPE, LOAD: begin
    //         imm = imm_I_L;
    //     end
    //     STYPE: begin
    //         imm = imm_S;
    //     end
    //     BTYPE: begin
    //         imm = imm_B;
    //     end

    // endcase


    // 4. ALU
    wire [31:0] alu_op1 = readData1; // Πρώτος τελεστής ALU
    wire [31:0] alu_op2 = ALUSrc ? imm : readData2; // Επιλογή δεύτερου τελεστή ALU
    wire [31:0] alu_result;
    reg [31:0] EX_MEM, MEM_WB;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            MEM_WB <= 32'b0;  // Reset
            EX_MEM <= 32'b0;  // Reset
        end else begin
            MEM_WB <= EX_MEM;
            EX_MEM <= alu_result;  // Latch ALU result for R-type or I-type
        end
    end


    alu alu_unit (
        .op1(alu_op1),
        .op2(alu_op2),
        .alu_op(ALUCtrl),
        .result(alu_result),
        .zero(Zero)
    );

    // 5. Μνήμη Δεδομένων
    assign dAddress = EX_MEM;   // Διεύθυνση δεδομένων στη μνήμη
    assign dWriteData = readData2; // Δεδομένα προς εγγραφή στη μνήμη

    // 6. Write Back
    assign WriteBackData = MemToReg ? dReadData : MEM_WB;

endmodule