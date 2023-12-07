`include "datapath_NREG.v"
`timescale 1ns/1ps

module datapathTB;
  parameter N = 16;
  parameter pipe = 2;
  reg signed [N-1:0] A, B;
  reg [2:0] opcode;
  wire signed [N-1:0] Y;
  wire co;
  reg clk;

  datapath  #(.N(N), .pipe(pipe)) myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co), .clk(clk)); 

  always 
  	#5 
    clk = ~clk;
  
  initial 
    begin
      clk = 0;

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
    
      #50;

      @(posedge clk) 
        	$display("[time: %0dns, result] A:%0d, B:%0d, Y:%0d, co:%b", $time, A, B, Y, co);


    end

endmodule
