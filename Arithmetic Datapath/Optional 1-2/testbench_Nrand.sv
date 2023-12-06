`define N 16
`define maxpositive 32767
`define minnegative -32768

`include "datapath.v"
`timescale 1ns/1ps

module datapathTB;
  reg signed [N-1:0] A,B;
  reg [2:0] opcode;
  wire signed [N-1:0] Y;
  wire co;
  
  datapath #N myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co));
  
  initial
    begin : initLabel

      // INIZIALIZZAZIONE DEL SEED
      $random(seed);

      // GENERA INPUT RANDOMICI
      A = $random;
      B = $random;
      opcode = $random;

      #10;
      $display("[time: %0dns, sum] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);

    end
  
endmodule