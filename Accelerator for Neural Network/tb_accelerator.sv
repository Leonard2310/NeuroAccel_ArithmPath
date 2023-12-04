`timescale 1ns/1ps
`include "acc_pipe.v"
`include "neuron.v"

module tb_accelerator1();
	reg signed [7:0] X1, X2, X3, X4;
	wire signed [7:0] Y;
	reg valid, ready_out;
	wire ready, valid_out;
	reg clk = 1'b0;
	reg arst;
	
	integer f1, f2;
	integer i,j;
	integer seed =13;
	integer nb;
	reg signed [7:0] Yfile;
	integer nerror = 0;
	integer nvalues = 0;
	
	acc_pipe UUT(.X1(X1), .X2(X2), .X3(X3), .X4(X4), .Y(Y), .ready(ready), .valid(valid), .ready_out(ready_out), .valid_out(valid_out), .clk(clk), .arst(arst));
	
	always
	begin
		#5;
		clk <= ~clk;
	end
	
	//constant signals to ease the test
	initial
	begin
		valid = 1'b1;
		ready_out = 1'b1;
	end
	
	//inputs
	initial
	begin
		f1 = $fopen("accel_in.dat","r");
		//initial reset
		arst = 1'b1;
		#50;
		arst = 1'b0;
		//data loop: on the negedge of the clock
		for(i=0; i<100; i=i+1)
		begin
			nb = $fscanf(f1,"%d %d %d %d\n",X1, X2, X3, X4);
			while(ready != 1'b1)
			begin
				#10; //next posedge clk data will be consumed
			end
			#10; //values have been read
		end
		
		$fclose(f1);
	end
	
	//outputs
	initial
	begin
		f2 = $fopen("accel_out.dat","r");
		#10; // guard for initial undefined values
		for(j=0; j<100; j=j+1)
		begin
			nvalues = nvalues + 1;
			while(valid_out != 1'b1)
			begin
				#10; //next posedge clk data will be consumed
			end
			nb = $fscanf(f2,"%d\n",Yfile);
			if(Y != Yfile)
			begin
				$display("j:%d, output failed",j);
				nerror = nerror + 1;
			end
			#10;
		end
		$fclose(f2);
		$display("%d cases evaluated, %d errors found", nvalues, nerror);
		$finish;
	end

endmodule