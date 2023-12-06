`include "datapath.v"
`timescale 1ns/1ps

module datapathTB;
  parameter N = 16;
  reg signed [N-1:0] A, B;
  reg [2:0] opcode;
  wire signed [N-1:0] Y;
  wire co;
  reg clk;
  reg pipe;

  initial begin
    $display("Inserisci il valore di pipe (0, 1 o 2): ");
    $scanf("%0d", pipe);

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
   
    // Simulazione per diversi cicli di clock
    #50;
    repeat (10) begin
      clk = ~clk;

      // Visualizza i risultati sul fronte di salita del clock
      @(posedge clk) $display("[time: %0dns, result] A:%0d, B:%0d, Y:%0d, co:%b", $time, A, B, Y, co);
    end

    #10;
    $finish;
  end

  datapath myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co), .clk(clk));

endmodule
