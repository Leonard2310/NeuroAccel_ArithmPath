`timescale 1ns/1ps
`include "neuron.v"
module tb_neuron();
	reg signed [7:0] X1, X2, X3, X4, W1, W2, W3, W4;
	reg signed [15:0] bias;
	reg signed [11:0] xmin, xmax;
	wire signed [7:0] Y;
	reg signed [7:0] Yfile;
	
	integer f1, f2;
	integer i;
	integer nb;
	integer nerror = 0;
	integer nvalues = 0;
	
	neuron UUT (.X1(X1), .X2(X2), .X3(X3), .X4(X4), .W1(W1), .W2(W2), .W3(W3), .W4(W4), .bias(bias), .xmin(xmin), .xmax(xmax), .Y(Y));
	
	initial
	begin
		f1 = $fopen("neuronInputs.dat","r");
		f2 = $fopen("neuronOutputs.dat","r");
		xmin = -12'd127;
		xmax = 12'd127;
		for(i=0; i<100; i=i+1)
		begin
			nvalues = nvalues + 1;
			nb = $fscanf(f1,"%d %d %d %d %d %d %d %d %d\n",X1, X2, X3, X4, W1, W2, W3, W4, bias);
			nb = $fscanf(f2,"%d\n",Yfile);
			#10;
			if (Yfile != Y) 
			begin
				$display("i: %d - computed value Y=%0d is different from data in the output file Y=%0d",i,Y,Yfile);
				nerror = nerror + 1;
			end
		end
		
		$display("%d cases evaluated, %d errors found", nvalues, nerror);
		
		$fclose(f1);
		$fclose(f2);
	end
endmodule