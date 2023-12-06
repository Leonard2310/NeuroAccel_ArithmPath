module datapath #(parameter N=16, parameter pipe=1) (A, B, opcode, Y, co, clk);
  input signed [N-1:0] A, B;
  input [2:0] opcode;
  output signed [N-1:0] Y;
  output co;
  input clk;

  wire [N-1:0] output_mux1;
  wire [N-1:0] output_mux2;

  wire [N-1:0] output_muxA;
  wire [N-1:0] output_muxB;
//  wire [2:0] output_muxOpCode;
  wire [15:0] output_muxY;
  wire output_muxCo;
   

  reg signed [N-1:0] reg_A, reg_B;
  reg [2:0] reg_opcode;
  reg [15:0] Y_reg;
  reg co_reg;
  

  // MUX Ingresso A: scelta tra registro e linea
  assign output_muxA = (pipe) ? reg_A : A;
  // MUX Ingresso B: scelta tra registro e linea
  assign output_muxB = (pipe) ? reg_B : B;
  // MUX Ingresso opcode: scelta tra registro e linea  
//  assign output_muxOpCode = (pipe) ? reg_opcode : opcode;
  // MUX Uscita Y: scelta tra registro e linea
  assign output_muxY = (pipe) ? Y_reg : Y;
  // MUX Uscita co: scelta tra registro e linea
  assign output_muxCo = (pipe) ? co_reg : co;

  
  // MUX 1: Scelta tra 0 e B
  assign output_mux1 = (opcode[2]) ? {N{1'b0}} : output_muxB;  

  // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
  assign output_mux2 = (opcode[1]) ? ~output_mux1 : output_mux1;

  // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
  assign {output_muxCo, output_muxY} = (output_muxA + output_mux2 + opcode[0]);

  always @(posedge clk) 
    begin
      if (pipe) 
        begin
          reg_A = A;
          reg_B = B;
          reg_opcode = opcode;
        end

    end

endmodule

