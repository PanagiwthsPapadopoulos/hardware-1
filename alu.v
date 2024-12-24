module alu(
    input [31:0] op1,        // First operand
    input [31:0] op2,        // Second operand
    input [3:0] alu_op,      // ALU operation selector
    output reg zero,         // Zero flag
    output reg [31:0] result // Result of ALU operation
);

    // Constants for ALU operations
    parameter [3:0] ALUOP_AND     = 4'b0000;
    parameter [3:0] ALUOP_OR      = 4'b0001;
    parameter [3:0] ALUOP_ADD     = 4'b0010;
    parameter [3:0] ALUOP_SUB     = 4'b0110;
    parameter [3:0] ALUOP_LESS    = 4'b0100;
    parameter [3:0] ALUOP_RSHIFT  = 4'b1000;
    parameter [3:0] ALUOP_LSHIFT  = 4'b1001;
    parameter [3:0] ALUOP_NRSHIFT = 4'b1010;
    parameter [3:0] ALUOP_XOR     = 4'b0101;

    // ALU combinational logic
    always @(*) begin
        case (alu_op)
            ALUOP_AND: result = op1 & op2;                                  // AND operation
            ALUOP_OR: result = op1 | op2;                                   // OR operation
            ALUOP_ADD: result = op1 + op2;                                  // Addition
            ALUOP_SUB: result = op1 - op2;                                  // Subtraction
            ALUOP_LESS: result = ($signed(op1) < $signed(op2)) ? 1 : 0;     // Set less than (signed)             // Set less than (unsigned)
            ALUOP_RSHIFT: result = op1 >> op2[4:0];                              // Logical right shift
            ALUOP_LSHIFT: result = op1 << op2[4:0];                              // Logical left shift
            ALUOP_NRSHIFT: result = $unsigned($signed(op1) >>> op2[4:0]);        // Arithmetic right shift        
            ALUOP_XOR: result = op1 ^ op2;                                  // XOR operation
            default: result = 32'b0;                                        // Default case
        endcase

        // Set zero flag if result is zero
        if (result == 32'b0)
            zero = 1'b1;
        else
            zero = 1'b0;

        // $display("ALU Inputs: op1 = %d, op2 = %d, alu_op = %b", op1, op2, alu_op);

    end

endmodule