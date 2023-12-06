`include "datapath_N.v"
`timescale 1ns/1ps

module datapathTB;
  parameter N = 16;
  reg signed [N-1:0] A, B;
  reg [2:0] opcode;
  wire signed [N-1:0] Y;
  wire co;
  
  datapath #(.N(N)) myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co)); //cambiato
  
  initial
    begin : initLabel  
      // GENERA INPUT RANDOMICI
      A = $random;
      B = $random;
      opcode = $random;
  
      #10;
      $display("[time: %0dns, sum] opcode:%b, A:%0d, B:%0d, Y:%0d, co:%b", $time, opcode, A, B, Y, co);

      A = $random;
      B = $random;
      opcode = $random;
  
      #10;
      $display("[time: %0dns, sum] opcode:%b, A:%0d, B:%0d, Y:%0d, co:%b", $time, opcode, A, B, Y, co);
   
      A = $random;
      B = $random;
      opcode = $random;
  
      #10;
      $display("[time: %0dns, sum] opcode:%b, A:%0d, B:%0d, Y:%0d, co:%b", $time, opcode, A, B, Y, co);
   
    end
endmodule
