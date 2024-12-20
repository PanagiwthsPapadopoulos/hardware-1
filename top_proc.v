// `include "datapath.v"

module top_proc #(
    parameter INITIAL_PC = 32'h00400000  // Initial PC value
)(
    input wire clk,                      // Clock signal
    input wire rst,                      // Synchronous reset signal
    input wire [31:0] instr,             // Instruction fetched from instruction memory
    input wire [31:0] dReadData,         // Data read from data memory
    output [31:0] PC,                // Program Counter
    output wire [31:0] dAddress,         // Address sent to data memory
    output wire [31:0] dWriteData,       // Data to write to memory
    output reg MemRead,                  // Memory read enable
    output reg MemWrite,                 // Memory write enable
    output wire [31:0] WriteBackData     // Data written back to register file
);

    // Control Signals
    reg PCSrc, ALUSrc, RegWrite, MemToReg, loadPC;
    reg [3:0] ALUCtrl;

    // Wires for datapath
    wire Zero;
    wire [31:0] alu_result;

    // Internal state register for FSM
    reg [2:0] state;  // FSM state encoding

    // FSM states
    localparam FETCH   = 3'b000,
               DECODE  = 3'b001,
               EXECUTE = 3'b010,
               MEMORY  = 3'b011,
               WRITE_BACK = 3'b100;

    // Datapath instantiation
    datapath #(
        .INITIAL_PC(INITIAL_PC)
    ) dp (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .PCSrc(PCSrc),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .MemToReg(MemToReg),
        .ALUCtrl(ALUCtrl),
        .loadPC(loadPC),
        .dReadData(dReadData),
        .PC(PC),
        .Zero(Zero),
        .dAddress(dAddress),
        .dWriteData(dWriteData),
        .WriteBackData(WriteBackData)
    );

    // FSM: Sequential logic to manage states
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= FETCH;  // Start in the FETCH state after reset
        end else begin
            case (state)
                FETCH: begin
                    state <= DECODE;  // Move to DECODE after fetching the instruction
                end
                DECODE: begin
                    state <= EXECUTE;  // Decode the instruction and prepare for execution
                end
                EXECUTE: begin
                    // Move to MEMORY for load/store or WRITE_BACK for arithmetic/logical instructions
                    if (instr[6:0] == 7'b0000011 || instr[6:0] == 7'b0100011)  // Load or Store
                        state <= MEMORY;
                    else
                        state <= WRITE_BACK;
                end
                MEMORY: begin
                    state <= WRITE_BACK;  // Move to WRITE_BACK after memory access
                end
                WRITE_BACK: begin
                    state <= FETCH;  // After writing back, go back to FETCH
                end
                default: state <= FETCH;  // Default to FETCH state
            endcase
        end
    end

    // FSM: Combinational logic for control signals
    always @(*) begin
        // Default control signal values
        PCSrc = 0;
        ALUSrc = 0;
        RegWrite = 0;
        MemToReg = 0;
        MemRead = 0;
        MemWrite = 0;
        loadPC = 0;
        ALUCtrl = 4'b0000;

        case (state)
            FETCH: begin
                loadPC = 1;  // Increment PC to fetch the next instruction
            end
            DECODE: begin
                // No additional controls in this state; decode happens implicitly in the datapath
            end
            EXECUTE: begin
                // ALU operations depend on the instruction type
                case (instr[6:0])
                    7'b0110011: begin  // R-type (ADD, SUB, etc.)
                        ALUCtrl = {instr[30], instr[14:12]};  // Generate ALU control based on funct7 and funct3
                    end
                    7'b0010011: begin  // I-type (ADDI, ANDI, etc.)
                        ALUSrc = 1;  // Use immediate as the second operand
                        ALUCtrl = {1'b0, instr[14:12]};  // funct3 determines the operation
                    end
                    7'b1100011: begin  // Branch (BEQ, etc.)
                        ALUCtrl = 4'b0110;  // SUB for comparison
                        PCSrc = (Zero) ? 1 : 0;  // Branch if condition is met
                    end
                endcase
            end
            MEMORY: begin
                case (instr[6:0])
                    7'b0000011: begin  // Load (LW)
                        MemRead = 1;  // Enable memory read
                    end
                    7'b0100011: begin  // Store (SW)
                        MemWrite = 1;  // Enable memory write
                    end
                endcase
            end
            WRITE_BACK: begin
                case (instr[6:0])
                    7'b0000011: begin  // Load (LW)
                        RegWrite = 1;  // Write memory data to the register file
                        MemToReg = 1;  // Select memory as the data source
                    end
                    7'b0110011, 7'b0010011: begin  // R-type and I-type instructions
                        RegWrite = 1;  // Write ALU result to the register file
                        MemToReg = 0;  // Select ALU result as the data source
                    end
                endcase
            end
        endcase
    end

endmodule