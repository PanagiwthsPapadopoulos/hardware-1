`include "top_proc.v"
`include "rom.v"
`include "ram.v"
`include "datapath.v"
`include "alu.v"
`include "regfile.v"
// `include "home/runner/rom_bytes.data"


`timescale 1ns/1ps


module top_proc_tb;

    // Clock and reset signals
    reg clk;
    reg rst;

    // Inputs and outputs to/from top_proc
    wire [31:0] PC;
    wire [31:0] dAddress;
    wire [31:0] dWriteData;
    wire [31:0] WriteBackData;
    wire MemRead;
    wire MemWrite;
    wire [31:0] instr;       // From ROM
    wire [31:0] dReadData;  // From RAM

    // Instantiate ROM and RAM
    INSTRUCTION_MEMORY rom_inst (
      .clk(clk),
      .addr(PC[8:0]),   // Instruction address (word-aligned)
      .dout(instr)       // Fetched instruction
    );

    DATA_MEMORY ram_inst (
        .clk(clk),
        .we(MemWrite),
      .addr(dAddress[8:0]), // Data address (word-aligned)
        .din(dWriteData),
        .dout(dReadData)
    );

    // Instantiate top_proc
    top_proc #(
        .INITIAL_PC(32'h00400000)  // Initial program counter
    ) uut (
        .clk(clk),
        .rst(rst),
        .instr(instr),
        .dReadData(dReadData),
        .PC(PC),
        .dAddress(dAddress),
        .dWriteData(dWriteData),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .WriteBackData(WriteBackData)
    );

    // Clock generation
    initial begin
       $dumpfile("dump.vcd"); 
$dumpvars;
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Test sequence
    initial begin
        // Initialize reset
        rst = 1;
        #15;
        rst = 0;

        // Wait for simulation to complete
        #1000;  // Run the simulation for a sufficient amount of time
        $stop;
    end

 
  
endmodule

