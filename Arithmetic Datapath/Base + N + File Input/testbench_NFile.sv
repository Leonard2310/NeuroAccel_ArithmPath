`include "datapath_N.v"
`timescale 1ns/1ps

module datapathTB;
  parameter N = 16;
  reg signed [N-1:0] A, B;
  reg [2:0] opcode;
  wire signed [N-1:0] Y;
  wire co;
  
  datapath myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co));
  
  initial
    begin : initLabel
      int file;
      
      file = $fopen("circuit_input.txt", "r");

      if (file == 0)
        begin
          $display("File non trovato");
          $finish;
        end

      while (!$feof(file)) 
       begin
        $fscanf(file, "%d %d %b", A, B, opcode);

        #10;
        $display("[time: %0dns, sum] A:%0d, B:%0d, Y:%0d, co:%b", $time, A, B, Y, co);
      end

      $fclose(file);
      $finish;
    end
endmodule