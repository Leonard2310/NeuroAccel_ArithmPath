`include "datapath_NREG.v"
`timescale 1ns/1ps

module datapathTB;
  parameter N = 16;
  parameter pipe = 1;
  reg signed [N-1:0] A, B;
  reg [2:0] opcode;
  wire signed [N-1:0] Y;
  wire co;
  reg clk;

  datapath  #(.N(N), .pipe(pipe)) myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co), .clk(clk)); //cambiato

  always 
  	#5 
    clk = ~clk;

  initial 
    begin
      int file;
      
      clk = 0;
      
      file = $fopen("circuit_input.txt", "r");

      if (file == 0)
        begin
          $display("File non trovato");
          $finish;
        end

      while (!$feof(file)) 
        begin
          $fscanf(file, "%d %d %b", A, B, opcode);

          #20; // Aggiungi un ritardo per garantire che l'assegnazione di pipe abbia effetto

          $display("[time: %0dns, sum] A:%0d, B:%0d, Y:%0d, co:%b", $time, A, B, Y, co);
      
        end

      $fclose(file);
      $finish;
      
      @(posedge clk) 
        	$display("[time: %0dns, result] A:%0d, B:%0d, Y:%0d, co:%b", $time, A, B, Y, co);
    
    end
  
endmodule
