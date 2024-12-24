`include "alu.v"
`include "calc_enc.v"

module calc(
  input clk,
  input btnc,
  input btnl,
  input btnu, 
  input btnr,
  input btnd,
  input[15:0] sw,
  output[15:0] led
);

  genvar i;
  wire zero;
  wire [3:0] alu_op;
  wire [31:0] result;  
  reg[15:0] accumulator;
  
  calc_enc calc_enc (
    .btnc(btnc), 
    .btnr(btnr), 
    .btnl(btnl), 
    .alu_op(alu_op)
  );
  
  alu alu (
    .op1({{16{accumulator[15]}}, accumulator}), //{20{instr[31]}}
    .op2({{16{sw[15]}}, sw}), 
    .alu_op(alu_op), 
    .zero(zero), 
    .result(result)
  );
  
  for(i=0; i<16; i = i + 1)
    begin
     assign led[i] = accumulator[i];
    end
  
  assign p1 = $signed(accumulator);
  assign p2 = $signed(sw);
  
  always @(posedge clk)
    begin
      if(btnu) accumulator = 15'b0;
      else if(btnd) accumulator = result;
    end

endmodule