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
    localparam FETCH   = 3'b000,            // 0
               DECODE  = 3'b001,            // 1
               EXECUTE = 3'b010,            // 2
               MEMORY  = 3'b011,            // 3
               WRITE_BACK = 3'b100,         // 4
               NONE = 3'b111;               // 7

    // Operation Types
    localparam RTYPE = 7'b0110011,
               ITYPE = 7'b0010011,
               STYPE = 7'b0100011,
               BTYPE = 7'b1100011,
               LOAD = 7'b0000011;


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
            state <= DECODE;  // Start in the FETCH state after reset
        end else begin
            case (state)
                FETCH: begin
                    state <= DECODE;  // Move to DECODE after fetching the instruction
                end
                DECODE: begin
                    state <= EXECUTE;  // Decode the instruction and prepare for execution
                end
                EXECUTE: begin
                    state <= MEMORY;
                end
                MEMORY: begin
                    state <= WRITE_BACK;  // Move to WRITE_BACK after memory access
                end
                WRITE_BACK: begin
                    state <= FETCH;  // After writing back, go back to FETCH
                end
                NONE: begin
                    state <= FETCH;
                end
                default: state <= FETCH;  // Default to FETCH state
            endcase
        end
    end

    // FSM: Combinational logic for control signals
    always @(*) begin
        // Default control signal values
        RegWrite = 0;
        MemToReg = 0;
        MemRead = 0;
        MemWrite = 0;
        ALUCtrl = 4'b0000;
        
        case (state)
            FETCH: begin
                loadPC = 0;  // Increment PC to fetch the next instruction 
            end
            DECODE: begin
                PCSrc = 0;
                // No additional controls in this state; decode happens implicitly in the datapath
            end
            EXECUTE: begin
                // ALU operations depend on the instruction type
                case (instr[6:0])
                    RTYPE: begin  // R-type (ADD, SUB, etc.)
                        // $display("RType operation detected with instr %b", {instr[30], instr[14:12]});
                        case ({instr[30], instr[14:12]})
                        
                        4'b0111: begin
                            ALUCtrl = 4'b0000;
                        end
                        4'b0110: begin
                            ALUCtrl = 4'b0001;
                        end
                        4'b0000: begin
                            ALUCtrl = 4'b0010;
                        end
                        4'b1000: begin
                            ALUCtrl = 4'b0110;
                        end
                        4'b0010: begin
                            ALUCtrl = 4'b0100;
                        end
                        4'b0101: begin
                            ALUCtrl = 4'b1000;
                        end
                        4'b0001: begin
                            ALUCtrl = 4'b1001;
                        end
                        4'b1101: begin
                            ALUCtrl = 4'b1010;
                        end
                        4'b0100: begin
                            ALUCtrl = 4'b0101;
                        end
                        endcase
                        // $display("ALUCtrl set to %d", ALUCtrl);
                    end
                    ITYPE: begin  // I-type (ADDI, ANDI, etc.)
                        ALUSrc = 1;  // Use immediate as the second operand
                        case (instr[14:12])
                        3'b111: begin
                            ALUCtrl = 4'b0000;
                        end
                        3'b110: begin
                            ALUCtrl = 4'b0001;
                        end
                        3'b000: begin
                            ALUCtrl = 4'b0010;
                        end
                        3'b010: begin
                            ALUCtrl = 4'b0100;
                        end
                        3'b101: begin
                            ALUCtrl = instr[30] ? 4'b1010 : 4'b1000;
                            // ALUCtrl = instr[30] ? 4'b0010 :4'b1001;
                        end
                        3'b001: begin
                            ALUCtrl = 4'b1001;
                        end
                        3'b100: begin
                            ALUCtrl = 4'b0101;
                        end

                        default: begin
                            ALUCtrl = 4'b1111;
                        end

                        endcase
                        // ALUCtrl = 4'b0010;
                        // $display("ALUCtrl set to %d", ALUCtrl);
                        
                    end
                    BTYPE: begin  // Branch (BEQ, etc.)
                        ALUCtrl = 4'b0110;  // SUB for comparison
                        PCSrc = (Zero) ? 1 : 0;  // Branch if condition is met
                    end
                    LOAD, STYPE: begin 
                        ALUCtrl = 4'b0010;
                        ALUSrc = 1;
                    end
                    
                endcase
                
            end
            MEMORY: begin
                case (instr[6:0])
                    LOAD: begin  // Load (LW)
                        MemRead = 1;  // Enable memory read
                    end
                    STYPE: begin  // Store (SW)
                        MemWrite = 1;  // Enable memory write
                    end
                endcase
            end
            WRITE_BACK: begin
                loadPC = 1;
                ALUSrc = 0;
                case (instr[6:0])
                    LOAD: begin  // Load (LW)
                        RegWrite = 1;  // Write memory data to the register file
                        MemToReg = 1;  // Select memory as the data source
                    end
                    RTYPE, ITYPE: begin  // R-type and I-type instructions
                        RegWrite = 1;  // Write ALU result to the register file
                        MemToReg = 0;  // Select ALU result as the data source
                    end
                endcase
            end
        endcase
        // $display("Exiting state.   State: %d, instr: %d", state, instr);
    end

endmodule