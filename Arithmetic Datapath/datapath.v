module datapath (A, B, opcode, Y, co);
  
  input signed [15:0] A, B;
  input [2:0] opcode;
  output signed [15:0] Y;
  output co;

  assign Y = (opcode == 3'b000) ? A + B :
    		     (opcode == 3'b001) ? A + B + 1'b1 :
    		     (opcode == 3'b010) ? A + (~B) :
    		     (opcode == 3'b011) ? A + (~B) + 1'b1 :
             (opcode == 3'b100) ? A :
    		     (opcode == 3'b101) ? A + 1'b1 :
    		     (opcode == 3'b110) ? A + (~16'd0) :
             (opcode == 3'b111) ? A :
             16'b0;

  assign co = (opcode == 3'b000) ? (A[15] & B[15]):
    		      (opcode == 3'b001) ? (A[15] & B[15]) | (A[15] & opcode[0]) | (B[15] & opcode[0]) :
              (opcode == 3'b010) ? (A[15] & ~B[15]) :
              (opcode == 3'b011) ? (A[15] & ~B[15]) :
              (opcode == 3'b101) ? (A[15] & opcode[0]) :
              (opcode == 3'b110) ? (A[15]) :
              1'b0;

endmodule
