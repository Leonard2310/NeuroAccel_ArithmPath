module datapath #(parameter N=16) (A, B, opcode, Y, co);
  input signed [N-1:0] A, B;
  input [2:0] opcode;
  output signed [N-1:0] Y;
  output co;
  
  wire [N-1:0] output_mux1; 
  wire [N-1:0] output_mux2;
  
  // MUX 1: Scelta tra 0 e B
  assign output_mux1 = (opcode[2]) ? {N{1'b0}}  : B;  
  
  // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
  assign output_mux2 = (opcode[1]) ? ~output_mux1 : output_mux1;
  
  // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
  assign {co,Y} = (A + output_mux2 + opcode[0]);
endmodule

