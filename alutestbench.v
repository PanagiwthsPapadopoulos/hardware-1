// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps  
`include "calc.v"
`include "regfile.v"


module alu_tb;
  reg z;
  reg [31:0] res, p1, p2;
  reg [3:0] operation;
  
  reg clk, center, left, up, right, down;
  reg [15:0] switches;
  wire [15:0] led; 
  
  reg[4:0]r1, r2, w;
      reg content;
      int write = 0;
      reg out1, out2;
  
initial begin
    clk = 0;
    forever 
         #5 clk = ~clk;
end
  
  alu alu(p1, p2, operation, z, res);
  calc calculator(clk, center, left, up, right, down, switches, led);
  regfile  #( 32) registers
  (
        clk, 
        r1, 
        r2,
        w, 
        content,
        write,
        out1,
        out2
      );
  initial 
    begin
    $dumpfile("dump.vcd");
    $dumpvars;
    
      p1 = 4'b10;
      p2 = 4'b1;
      
//     #10;
//       $display("Starting Simulation");
//       //
//       operation = 4'b0;
//        #10;
//       //
//     operation = 4'b1;
//        #10;
//       //
//     operation = 4'b10;
//        #10;
//       //
//     #10;operation = 4'b110;
//        #10;
//       //
//   operation = 4'b100;
//        #10;
//       //
//   operation = 4'b1000;
//        #10;
//       //
//       operation = 4'b1001;
//        #10;
//       //
//       operation = 4'b1010;
//        #10;
//       //
//       operation = 4'b101;
//        #10;
//       //
//       //
      
      //
      $display("Starting Simulation for calculator");
      up = 1;
      down = 1;
       #7.5;
      //
      $display("After first command");
      up = 0;
      down = 1;
      
      left = 0;
      center = 1;
      right = 0;
      
      switches = 'h0x354a;
      $display("%d", switches);
      #10;
      left = 0;
      center = 1;
      right = 1;
      
      switches = 'h0x1234;
      
      #10;
      left = 0;
      center = 0;
      right = 1;
      
      switches = 'h0x1001;
      
      #10;
      left = 0;
      center = 0;
      right = 0;
      
      switches = 'h0xf0f0;
      
      #10;
      left = 1;
      center = 1;
      right = 1;
      
      switches = 'h0x1fa2;
      
      #10;
      left = 0;
      center = 1;
      right = 0;
      
      switches = 'h0x6aa2;
      
      #10;
      left = 1;
      center = 0;
      right = 1;
      
      switches = 'h0x0004;
      
      #10;
      left = 1;
      center = 1;
      right = 0;
      
      switches = 'h0x0001;
      
      #10;
      left = 1;
      center = 0;
      right = 0;
      
      switches = 'h0x46ff;

      
      #10;
      //

      
      
      
     $finish;
      
    end
endmodule
