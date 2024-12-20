module calc_enc(
  input wire btnc, 
  input wire btnr, 
  input wire btnl, 
  output[3:0] alu_op
);
  
  
    
  not(btncNOT, btnc);
  and(w12, btncNOT, btnr);
  and(w13, btnr, btnl);
  or(alu_op[0], w12, w13);
  
  
  not(btnlNOT, btnl);
  and(w22, btnc, btnlNOT);
  not(btnrNOT, btnr);
  and(w23, btnc, btnrNOT);
  or(alu_op[1], w22, w23);
  
  
  and(w31, btnl, btncNOT);
  and(w32, btnc, btnr);
  and(w33, w31, btnrNOT);
  or(alu_op[2], w32, w33);
  
  
  and(w41, btnl, btncNOT);
  and(w42, btnl, btnc);
  and(w43, w41, btnr);
  and(w44, w42, btnrNOT);
  or(alu_op[3], w43, w44);
  
  
  
endmodule
  
  
  
  
  
  
  
  