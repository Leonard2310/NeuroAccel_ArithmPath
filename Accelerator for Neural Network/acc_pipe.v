module acc_pipe(X1, X2, X3, X4, Y, ready, valid, ready_out, valid_out, clk, arst);
	input signed [7:0] X1, X2, X3, X4;
	output signed [7:0] Y;
	input valid, ready_out;
	output ready, valid_out;
	input clk, arst;

	reg signed [7:0] S1, S2;
	wire signed [7:0] Y1, Y2, Y3;
	
	//parameters for N1
	parameter [7:0] n1_w1 = -8'd115;
	parameter [7:0] n1_w2 = 8'd1;
	parameter [7:0] n1_w3 = -8'd105;
	parameter [7:0] n1_w4 = 8'd16;
	parameter [15:0] n1_bias = 16'd12571;
	parameter [11:0] n1_xmin = -12'd127;
	parameter [11:0] n1_xmax = 12'd127;
	//parameters for N2
	parameter [7:0] n2_w1 = 8'd103;
	parameter [7:0] n2_w2 = -8'd22;
	parameter [7:0] n2_w3 = 8'd32;
	parameter [7:0] n2_w4 = -8'd56;
	parameter [15:0] n2_bias = -16'd8139;
	parameter [11:0] n2_xmin = -12'd127;
	parameter [11:0] n2_xmax = 12'd127;
	//parameters for N3
	parameter [7:0] n3_w1 = 8'd75;
	parameter [7:0] n3_w2 = -8'd85;
	parameter [7:0] n3_w3 = -8'd38;
	parameter [7:0] n3_w4 = 8'd92;
	parameter [15:0] n3_bias = 16'd10182;
	parameter [11:0] n3_xmin = -12'd127;
	parameter [11:0] n3_xmax = 12'd127;

	reg [2:0] current_state;
	parameter [2:0] S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100;

	wire enable1, enable2, enable3;

	always @(posedge clk or posedge arst)
		begin
			if (arst)
				begin
					current_state <= S0;
					ready <= 1'b1;
					valid_out <= 1'b0;
					enable1 <= 1'b0;
					enable2 <= 1'b0;
					enable3 <= 1'b0;
				end
			else
				begin
					case(current_state)
						S0: current_state <= (valid) ? S1 : S0;
						S1: current_state <= S2;
						S2: current_state <= S3;
						S3: current_state <= (ready_out) ? S4 : S3;
						S4: current_state <= S0;
					endcase
				end
		end

	always @(current_state)
		begin
			case(current_state)
				S0: 
					enable1 <= 1'b0;
					enable2 <= 1'b0;
					enable3 <= 1'b0;
					valid_out <= 1'b0;
					ready <= 1'b1;
				S1:
					enable1 <= 1'b1;
					enable2 <= 1'b1;
					enable3 <= 1'b0;
					valid_out <= 1'b0;
					ready <= 1'b1;
				S2:					
					enable1 <= 1'b1;
					enable2 <= 1'b1;
					enable3 <= 1'b0;
					valid_out <= 1'b1;
					ready <= 1'b1;
				S3:
					enable1 <= 1'b0;
					enable2 <= 1'b0;
					enable3 <= 1'b1;
					valid_out <= 1'b1;
					ready <= 1'b0;
				S4:
					enable1 <= 1'b0;
					enable2 <= 1'b0;
					enable3 <= 1'b0;
					valid_out <= 1'b1;
					ready <= 1'b1;
				default:
            		enable1 <= 1'bx;
            		enable2 <= 1'bx;
            		enable3 <= 1'bx;
            		valid_out <= 1'bx;
            		ready <= 1'bx;
			endcase
		end

	always @(posedge clk or posedge arst)
		begin

			N1 neuron (.X1(X1), .X2(X2), .X3(X3), .X4(X4), .W1(n1_w1), .W2(n1_w2), .W3(n1_w3), .W4(n1_w4), 
						.bias(n1_bias), .xmin(n1_xmin), .xmax(n1_xmax), .Y(Y1)));

			N2 neuron (.X1(X1), .X2(X2), .X3(X3), .X4(X4), .W1(n2_w1), .W2(n2_w2), .W3(n2_w3), .W4(n2_w4), 
						.bias(n2_bias), .xmin(n2_xmin), .xmax(n2_xmax), .Y(Y2)));
	
			if(enable1) 
				begin
					assign S1 = Y1;

					if(enable2)
						begin

							assign S2 = Y2;

							N3 neuron (.X1(S1), .X2(S2), .X3(0), .X4(0), .W1(n3_w1), .W2(n3_w2), .W3(n3_w3), .W4(n3_w4), 
										.bias(n3_bias), .xmin(n3_xmin), .xmax(n3_xmax), .Y(Y3)));

							if(enable3)
								begin
									assign Y = Y3;
								end
						end
				end

		end

	
endmodule