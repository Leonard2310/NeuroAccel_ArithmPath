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

	// TODO: DA FARE
	reg signed [7:0] IN1_N1, IN2_N1, IN3_N1, IN4_N1, IN1_N2, IN2_N2, IN3_N2, IN4_N2;
	reg signed [7:0] W1_N1, W2_N1, W3_N1, W4_N1, W1_N2, W2_N2, W3_N2, W4_N2;
	reg signed [15:0] BIAS_N1, BIAS_N2;
	reg signed [11:0] XMIN_N1, XMIN_N2, XMAX_N1, XMAX_N2;

	reg [2:0] current_state;
	parameter [2:0] T0=3'b000, T1=3'b001, T2=3'b010, T3=3'b011, T4=3'b100, T5=3'b101;

	reg enable1, enable2, enable3;
	reg ready_reg, valid_out_reg;
	reg signed [7:0] Y_reg;

	reg cycle = 1'b0;
	reg ctrl1, ctrl2, ctrl5;
	reg [1:0] ctrl3, ctrl4;

	neuron N1 (.X1(IN1_N1), .X2(IN2_N1), .X3(IN3_N1), .X4(IN4_N1), .W1(W1_N1), .W2(W2_N1), .W3(W3_N1), .W4(W4_N1), 
				.bias(BIAS_N1), .xmin(XMIN_N1), .xmax(XMAX_N1), .Y(Y1));
	
	neuron N2 (.X1(IN1_N2), .X2(IN2_N2), .X3(IN3_N2), .X4(IN4_N2), .W1(W1_N2), .W2(W2_N2), .W3(W3_N2), .W4(W4_N2), 
				.bias(BIAS_N2), .xmin(XMIN_N2), .xmax(XMAX_N2), .Y(Y2));

	assign ready = ready_reg;
	assign valid_out = valid_out_reg;
	assign Y = Y_reg;

	always @(posedge clk or posedge arst)
		begin
			if (arst)
				begin
					current_state <= T0;
				end
			else
				begin
					case(current_state)
						T0: current_state <= (valid) ? T1 : T0;
						T1: current_state <= T2;
						T2: current_state <= (cycle) ? T5 : T3;
						T3: current_state <= (ready_out) ? T4 : T3;
						T5: current_state <= T4;
						T4: current_state <= T0;
						default:
							current_state <= T0;

					endcase
				end
		end

	always @(current_state)
		begin
			case(current_state)
				T0: 
					begin
						ctrl1 <= 1'b0;
						ctrl2 <= 1'b0;
						ctrl3 <= 2'b00;
						ctrl4 <= 2'b01;
						ctrl5 <= 1'bx;
						enable1 <= 1'b0;
						enable2 <= 1'b0;
						enable3 <= 1'b0;
						valid_out_reg <= 1'b0;
						ready_reg <= 1'b1;
					end
				T1:
					begin
						enable1 <= 1'b1;
						enable2 <= 1'b1;
						enable3 <= 1'b0;
						valid_out_reg <= 1'b0;
						ready_reg <= 1'b1;
					end
				T2:	
					begin				
						enable1 <= 1'b1;
						enable2 <= 1'b1;
						enable3 <= 1'b0;
						valid_out_reg <= 1'b1;
						ready_reg <= 1'b1;
					end
				T3:
					begin
						ctrl1 <= 1'b1;
						ctrl2 <= 1'b0;
						ctrl3 <= 2'b10;
						ctrl4 <= 2'b01;
						ctrl5 <= 1'b0;
						enable1 <= 1'b0;
						enable2 <= 1'b0;
						enable3 <= 1'b1;
						valid_out_reg <= 1'b1;
						ready_reg <= 1'b0;
					end
				T5:
					begin
						ctrl1 <= 1'b0;
						ctrl2 <= 1'b1;
						ctrl3 <= 2'b00;
						ctrl4 <= 2'b10;
						ctrl5 <= 1'b1;
						enable1 <= 1'b0;
						enable2 <= 1'b0;
						enable3 <= 1'b1;
						valid_out_reg <= 1'b1;
						ready_reg <= 1'b0;
					end
				T4:
					begin
						enable1 <= 1'b0;
						enable2 <= 1'b0;
						enable3 <= 1'b0;
						valid_out_reg <= 1'b1;
						ready_reg <= 1'b1;
						cycle <= ~cycle;
					end
				default:
					begin
						ctrl1 <= 1'bx;
						ctrl2 <= 1'bx;
						ctrl3 <= 2'bxx;
						ctrl4 <= 2'bxx;
						ctrl5 <= 1'bx;
						enable1 <= 1'bx;
						enable2 <= 1'bx;
						enable3 <= 1'bx;
						valid_out_reg <= 1'bx;
						ready_reg <= 1'bx;
					end
			endcase
		end

	always @(posedge clk)
		begin

			if(ctrl3 == 2'b00)
				begin
					W1_N1 <= n1_w1;
					W2_N1 <= n1_w2;
					W3_N1 <= n1_w3;
					W4_N1 <= n1_w4;
					BIAS_N1 <= n1_bias;
					XMIN_N1 <= n1_xmin;
					XMAX_N1 <= n1_xmax;
				end
			else if(ctrl3 == 2'b10)
				begin
					W1_N1 <= n3_w1;
					W2_N1 <= n3_w2;
					W3_N1 <= n3_w3;
					W4_N1 <= n3_w4;
					BIAS_N1 <= n3_bias;
					XMIN_N1 <= n3_xmin;
					XMAX_N1 <= n3_xmax;
				end
			
			if(ctrl4 == 2'b01)
				begin
					W1_N2 <= n2_w1;
					W2_N2 <= n2_w2;
					W3_N2 <= n2_w3;
					W4_N2 <= n2_w4;
					BIAS_N2 <= n2_bias;
					XMIN_N2 <= n2_xmin;
					XMAX_N2 <= n2_xmax;
				end
			else if(ctrl4 == 2'b10)
				begin
					W1_N2 <= n3_w1;
					W2_N2 <= n3_w2;
					W3_N2 <= n3_w3;
					W4_N2 <= n3_w4;
					BIAS_N2 <= n3_bias;
					XMIN_N2 <= n3_xmin;
					XMAX_N2 <= n3_xmax;
				end

			if(ctrl1 == 1'b0)
				begin
					IN1_N1 <= X1;
					IN2_N1 <= X2;
					IN3_N1 <= X3;
					IN4_N1 <= X4;
				end
			else
				begin
					IN1_N1 <= S1;
					IN2_N1 <= S2;
					IN3_N1 <= 8'd0;
					IN4_N1 <= 8'd0;	
				end
			
			if(ctrl2 == 1'b0)
				begin
					IN1_N2 <= X1;
					IN2_N2 <= X2;
					IN3_N2 <= X3;
					IN4_N2 <= X4;
				end
			else
				begin
					IN1_N2 <= S1;
					IN2_N2 <= S2;
					IN3_N2 <= 8'd0;
					IN4_N2 <= 8'd0;	
				end
	
			if(enable1) 
				begin
					S1 <= Y1;

					if(enable2)
						begin
							S2 <= Y2;						
						end

				end
			
			if(ctrl5 == 1'b0)
				begin
					Y_reg <= S1;
				end	
			else
				begin
					Y_reg <= S2;
				end

		end

	
endmodule