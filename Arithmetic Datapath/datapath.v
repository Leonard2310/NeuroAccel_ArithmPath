module datapath (A, B, opcode, Y, co); 
  input signed [15:0] A, B; 
  input [2:0] opcode; 
  output signed [15:0] Y; 
  output co; 
 
  wire [15:0] output_mux1; 
  wire [15:0] output_mux2; 
 
  // MUX 1 
  assign output_mux1 = (opcode[2]) ? 16'd0 : B;   
 
  // MUX 2 
  assign output_mux2 = (opcode[1]) ? ~output_mux1 : output_mux1; 
 
  // ADDER 
  assign {co,Y} = (A + output_mux2 + opcode[0]); 
 
endmodule
