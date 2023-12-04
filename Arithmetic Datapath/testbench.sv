// Code your testbench here
// or browse Examples

`define maxpositive 32767
`define minnegative -32768

`include "datapath.v"
`timescale 1ns/1ps

module datapathTB;
  reg signed [15:0] A,B;
  reg [2:0] opcode;
  wire signed [15:0] Y;
  wire co;
  
  datapath myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co));
  
  initial
    begin : initLabel
      // operation: Sum
      opcode = 3'b000; A = 16'd5; B = 16'd128;
      #10;
      $display("[time: %0dns, sum] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);
      
      // operation: Sumi
      opcode = 3'b001; A = 16'd5; B = 16'd128;
      #10;
      $display("[time: %0dns, sumi] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);
      
      // operation: Subd
      opcode = 3'b010; A = 16'd5; B = 16'd128;
      #10;
      $display("[time: %0dns, subd] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);
      
      // operation: Sub
      opcode = 3'b011; A = 16'd5; B = 16'd128;
      #10;
      $display("[time: %0dns, sub] A:%0d, B:%0d, Y:%0d, co:%b",$time, A, B, Y, co);
      
      // add your code here
	  
    end
  
endmodule