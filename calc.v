`include "alu.v"
`include "calc_enc.v"


module calc(
  input clk,
  input reg btnc,
  input reg btnl,
  input reg btnu, 
  input reg btnr,
  input reg btnd,
  input reg [15:0] sw,
  output[15:0] led
);
  genvar i;
  reg [3:0] alu_op;
  reg [31:0] res, p1, p2;
  
  
  
  
  wire btnc_w = btnc;
  calc_enc calc_enc(btnc_w, btnr, btnl, alu_op);
  
  alu alu(p1, p2, alu_op, z, res);
  
  reg[15:0] accumulator;
  
//   assign sw = res;
  
  for(i=0; i<16; i = i + 1)
    begin
     assign led[i] = accumulator[i];
    end
  
  assign p1 = $signed(accumulator);
  assign p2 = $signed(sw);
  
  
  always @(posedge clk)
    begin
      if(btnu) accumulator = 15'b0;
      else if(btnd) accumulator = res;
//       accumulator = 15'b0;
    end
  

endmodule