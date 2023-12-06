`define N 16
`define maxpositive ((2**(`N-1))-1)
`define minnegative (-2**(`N-1))

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
      int file;
      
      file = $fopen("circuit_input.txt", "r");

      $fscanf(file, "%d %d %b", A, B, opcode);
      
      $display("[Initial inputs] A:%0d, B:%0d, opcode:%b", A, B, opcode);

      #10;
      $display("[time: %0dns, sum] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);

      $fclose(file);
      
    end
  
endmodule