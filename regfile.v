`timescale 1ns/1ps
module regfile #(parameter DATAWIDTH = 32)
  (
  input clk,
  input [4:0] readReg1,
  input [4:0] readReg2,
  input [4:0] writeReg,
  input [DATAWIDTH-1:0] writeData,
  input write,
  output wire [DATAWIDTH-1:0] readData1,
  output wire [DATAWIDTH-1:0] readData2
);
  
  reg [DATAWIDTH-1:0] registers [0:31];
  integer i;

  initial begin
    for(i=0; i<32; i++)
      begin
        registers[i] <= 0;
      end

      #1;  // Delay slightly to ensure values are set after simulation start
    for (i = 0; i < 32; i++) begin
        $display("Register %d: %h", i, registers[i]);
    end
  end
  
  always @(posedge clk) begin
    if(write) registers[writeReg] <= writeData;
    // readData1 <= registers[readReg1];
    // readData2 <= registers[readReg2];
  end

  assign readData1 = registers[readReg1];
  assign readData2 = registers[readReg2];
    
endmodule