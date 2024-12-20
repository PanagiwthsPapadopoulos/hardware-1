module regfile #(parameter DATAWIDTH = 32)
  (
  input clk,
  input [4:0] readReg1,
  input [4:0] readReg2,
  input [4:0] writeReg,
  input [DATAWIDTH-1:0] writeData,
  input write,
  output reg [DATAWIDTH-1:0] readData1,
  output reg [DATAWIDTH-1:0] readData2
);
  
  reg[31:DATAWIDTH-1] registers;
  integer i;

  initial begin
    for(i=0; i<32; i++)
      begin
        registers[i] = 0;
      end
  end
  
  always @(posedge clk)
    begin
      if(write) registers[writeReg] = writeData;
        readData1 = registers[readReg1];
      readData2 = registers[readReg2];
    end
    
endmodule