`include "calc.v"
`timescale 1ns / 1ps

module calc_tb;

    // Testbench signals
    reg clk;
    reg btnc, btnl, btnr, btnu, btnd;
    reg [15:0] sw; // Switch input for data
    wire [15:0] result; // Output result from calculator

    // Instantiate the calculator module
    calc uut (
        .clk(clk),
        .btnc(btnc),
        .btnl(btnl),
        .btnr(btnr),
        .btnu(btnu),
        .btnd(btnd),
        .sw(sw),
        .led(result)
    );

    // Clock generation
    initial begin
        $dumpfile("calc.vcd"); 
        $dumpvars;
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize inputs
        btnc = 0; btnl = 0; btnr = 0; btnu = 0; btnd = 0; sw = 16'h0;

        // Reset the calculator
        btnu = 1; #10; btnu = 0; #10;

        // Test addition (ADD)
        sw = 16'h354a; btnl = 0; btnc = 1; btnr = 0; #10; btnd = 1; #10; btnd = 0;

        // Test subtraction (SUB)
        sw = 16'h1234; btnl = 0; btnc = 1; btnr = 1; #10; btnd = 1; #10; btnd = 0;

        // Test OR operation
        sw = 16'h1001; btnl = 0; btnc = 0; btnr = 1; #10; btnd = 1; #10; btnd = 0;

        // Test AND operation
        sw = 16'hf0f0; btnl = 0; btnc = 0; btnr = 0; #10; btnd = 1; #10; btnd = 0;

        // Test XOR operation
        sw = 16'h1fa2; btnl = 1; btnc = 1; btnr = 1; #10; btnd = 1; #10; btnd = 0;

        // Test addition (ADD)
        sw = 16'h6aa2; btnl = 0; btnc = 1; btnr = 0; #10; btnd = 1; #10; btnd = 0;

        // Test Logical Shift Left (LSL)
        sw = 16'h0004; btnl = 1; btnc = 0; btnr = 1; #10; btnd = 1; #10; btnd = 0;

        // Test Shift Right Arithmetic (SRA)
        sw = 16'h0001; btnl = 1; btnc = 1; btnr = 0; #10; btnd = 1; #10; btnd = 0;

        // Test Less Than (LT)
        sw = 16'h46ff; btnl = 1; btnc = 0; btnr = 0; #10; btnd = 1; #10; btnd = 0;

        // Test reset with btnu
        btnu = 1; #10; btnu = 0; #10;

        // End simulation
        $finish;
    end

endmodule