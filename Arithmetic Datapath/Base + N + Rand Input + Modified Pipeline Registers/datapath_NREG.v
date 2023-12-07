module datapath #(parameter N=16, parameter pipe = 1) (A, B, opcode, Y, co, clk);
  input signed [N-1:0] A, B;
  input [2:0] opcode;
  output signed [N-1:0] Y;
  output co;
  input clk;

  wire [N-1:0] output1_mux1;
  wire [N-1:0] output2_mux1; 
  wire [N-1:0] output1_mux2;
  wire [N-1:0] output2_mux2;
   
  reg signed [N-1:0] reg_A1, reg_A2, reg_B1, reg_B2;
  reg [2:0] reg_opcode1, reg_opcode2;
  reg [N-1:0] Y_reg1, Y_reg2;
  reg co_reg1, co_reg2;
  
  generate
    if(pipe == 1)
      begin
        always @ (posedge clk)
          begin
            reg_A1 <= A;
            reg_B1 <= B;
            reg_opcode1 <= opcode;
          end 
  
        // MUX 1: Scelta tra 0 e registro B
        assign output1_mux1 = (reg_opcode1[2]) ? {N{1'b0}} : reg_B1;  

        // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
        assign output1_mux2 = (reg_opcode1[1]) ? ~output1_mux1 : output1_mux1;

        // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out 
        assign {co_reg1, Y_reg1} = (reg_A1 + output1_mux2 + reg_opcode1[0]); 
        
        assign co = co_reg1;
        assign Y = Y_reg1;
      end
    else if(pipe == 2)
      begin
      	always @ (posedge clk)
          begin
        	reg_A2 <= A;
        	reg_B2 <= B;
            reg_opcode2 <= opcode;
          end 

         // MUX 1: Scelta tra 0 e registro B
         assign output2_mux1 = (reg_opcode2[2]) ? {N{1'b0}} : reg_B2;

         // MUX 2: Scelta tra l'uscita negata del MUX1 e l'uscita del MUX1
         assign output2_mux2 = (reg_opcode2[1]) ? ~output2_mux1 : output2_mux1;
         
         // TODO: METTERE REGISTRI NELL'ADDER

         // ADDER: Se generato il diciassettesimo bit va nella concatenazione in carry-out
         assign {co_reg2, Y_reg2} = (reg_A2 + output2_mux2 + reg_opcode2[0]);

         assign co = co_reg2;
         assign Y = Y_reg2;
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
