module datapath #(parameter N=16, parameter pipe = 1) (A, B, opcode, Y, co, clk);
  input signed [N-1:0] A, B;
  input [2:0] opcode;
  output signed [N-1:0] Y;
  output co;
  input clk;

  wire [N-1:0] output_mux1;
  wire [N-1:0] output_mux2; 
   
  reg signed [N-1:0] reg_A, reg_B;
  reg [2:0] reg_opcode;
  reg [N-1:0] Y_reg;
  reg co_reg;
  
  generate
    if(pipe == 1)
      begin
        always @ (posedge clk)
          begin
            reg_A <= A;
            reg_B <= B;
            reg_opcode <= opcode;
          end 
  
        // MUX 1: Scelta tra 0 e registro B
        assign output_mux1 = (reg_opcode[2]) ? {N{1'b0}} : reg_B;  

        // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
        assign output_mux2 = (reg_opcode[1]) ? ~output_mux1 : output_mux1;

        // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
        assign {co_reg, Y_reg} = (reg_A + output_mux2 + reg_opcode[0]); 
        
        assign co = co_reg;
        assign Y = Y_reg;
      end
    else
      begin
        // MUX 1: Scelta tra 0 e B
        assign output_mux1 = (opcode[2]) ? {N{1'b0}}  : B;  

        // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
        assign output_mux2 = (opcode[1]) ? ~output_mux1 : output_mux1;

        // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
        assign {co,Y} = (A + output_mux2 + opcode[0]);
      end
  endgenerate
endmodule
