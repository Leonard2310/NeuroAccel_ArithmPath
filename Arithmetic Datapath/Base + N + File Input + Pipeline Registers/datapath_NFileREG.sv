`define N 16
`define maxpositive ((2**(`N-1))-1)
`define minnegative (-2**(`N-1))

`include "datapath.v"
`timescale 1ns/1ps

module datapathTB;
  reg signed [N-1:0] A, B;
  reg [2:0] opcode;
  wire signed [N-1:0] Y;
  wire co;
  reg clk;
  reg pipe;

  initial begin
    $display("Inserisci il valore di pipe (0 o 1): ");
    $scanf("%0d", pipe);

    clk = 0;

    int file = $fopen("circuit_input.txt", "r");
    $fscanf(file, "%d %d %b", A, B, opcode);
    $fclose(file);

    $display("[time: %0dns, inputs] A:%0d, B:%0d, opcode:%b, pipe:%0d", $time, A, B, opcode, pipe);

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

  datapath #(N, pipe) myDatapath (.A(A), .B(B), .opcode(opcode), .Y(Y), .co(co), .clk(clk));

endmodule