module datapath #(parameter N=16, parameter pipe = 1) (A, B, opcode, Y, co, clk);
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

/*
    else if (pipe == 2) begin
      reg [N-1:0] reg_A1, reg_B1;
      reg [2:0] reg_opcode1;

      always @(posedge clk) begin
        reg_A1 <= A;
        reg_B1 <= B;
        reg_opcode1 <= opcode;
      end

      wire [N-1:0] output_mux1_1; 
      wire [N-1:0] output_mux2_1;
      wire co_1;
      wire [N:0] adder_output_1;

      // MUX 1: Scelta tra 0 e B
      assign output_mux1_1 = (reg_opcode1[2]) ? {N{1'b0}} : reg_B1;  

      // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
      assign output_mux2_1 = (reg_opcode1[1]) ? ~output_mux1_1 : output_mux1_1;

      // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
      assign {co_1, adder_output_1} = (reg_A1 + output_mux2_1 + reg_opcode1[0]);

      // MUX 1: Scelta tra 0 e B
      assign output_mux1 = (opcode[2]) ? {N{1'b0}} : adder_output_1[N-1:0];  

      // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
      assign output_mux2 = (opcode[1]) ? ~output_mux1 : output_mux1;

      // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
      assign {co, Y} = (A + output_mux2 + opcode[0]);
    end


endmodule
*/
