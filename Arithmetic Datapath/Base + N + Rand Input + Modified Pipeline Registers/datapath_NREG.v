module datapath #(parameter N=16, parameter pipe = 0) (A, B, opcode, Y, co);
  input signed [N-1:0] A, B;
  input [2:0] opcode;
  output signed [N-1:0] Y;
  output co;
  input clk;

  wire [N-1:0] output_mux1; 
  wire [N-1:0] output_mux2;

  generate
    if (pipe == 1) begin
      reg signed [N-1:0] reg_A, reg_B;
      reg [2:0] reg_opcode;

      always @(posedge clk) begin
        reg_A <= A;
        reg_B <= B;
        reg_opcode <= opcode;
      end

      // MUX 1: Scelta tra 0 e B
      assign output_mux1 = (reg_opcode[2]) ? {N{1'b0}} : reg_B;  

      // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
      assign output_mux2 = (reg_opcode[1]) ? ~output_mux1 : output_mux1;

      // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
      assign {co, Y} = (reg_A + output_mux2 + reg_opcode[0]);
    end

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

    else begin
      // MUX 1: Scelta tra 0 e B
      assign output_mux1 = (opcode[2]) ? {N{1'b0}} : B;  

      // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
      assign output_mux2 = (opcode[1]) ? ~output_mux1 : output_mux1;

      // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
      assign {co, Y} = (A + output_mux2 + opcode[0]);
    end
  endgenerate

endmodule

