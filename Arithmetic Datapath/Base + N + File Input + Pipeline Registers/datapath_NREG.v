module datapath #(parameter N=16) (A, B, opcode, Y, co, clk, pipe);
  input signed [N-1:0] A, B;
  input [2:0] opcode;
  output signed [N-1:0] Y;
  output co;
  input clk;
  input pipe;

  wire [N-1:0] output_mux1;
  wire [N-1:0] output_mux2;

  reg [N-1:0] output_mux1_reg;
  reg [N-1:0] output_mux2_reg;
  reg [N-1:0] Y_reg;  
  reg co_reg; 

  reg signed [N-1:0] reg_A, reg_B;
  reg [2:0] reg_opcode;

  assign output_muxA = (pipe) ? reg_A : A;
  assign output_muxB = (pipe) ? reg_B : B;  
  assign output_muxOpCode = (pipe) ? reg_opcode : opcode; 
  
  // MUX 1: Scelta tra 0 e B
  assign output_mux1 = (opcode[2]) ? {N{1'b0}} : output_muxB;  

  // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
  assign output_mux2 = (opcode[1]) ? ~output_mux1 : output_mux1;

  // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
  assign {co, Y} = (output_muxA + output_mux2 + output_muxOpCode[0]);

  always @(posedge clk) 
    begin
      if (pipe == 1) 
        begin
          reg_A = A;
          reg_B = B;
          reg_opcode = opcode;
        end

    end

endmodule

