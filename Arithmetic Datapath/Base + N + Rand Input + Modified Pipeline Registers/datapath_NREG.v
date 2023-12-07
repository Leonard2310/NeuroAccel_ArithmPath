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
  reg [(N/2)-1:0] add_regL, add_regM;
  reg [(N/2)-1:0] reg_AL, reg_AM, reg_BL, reg_BM;
  reg [N-1:0] Y_reg;
  reg co_reg, reg_coL, reg_coM;
  
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
    else if(pipe == 2)
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
         
         assign reg_AL = reg_A[(N/2)-1:0];
         assign reg_AM = reg_A[N-1:(N/2)];

         assign reg_BL = output_mux2[(N/2)-1:0];
         assign reg_BM = output_mux2[N-1:(N/2)];

         assign {reg_coL, add_regL} = reg_AL + reg_BL;
         assign {reg_coM, add_regM} = reg_AM + reg_BM;

         assign {co_reg, Y_reg} = {add_regM, add_regL} + reg_coL + reg_coM + reg_opcode[0];

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
