module neuron(X1, X2, X3, X4, W1, W2, W3, W4, bias, xmin, xmax, Y);

	input signed [7:0] X1, X2, X3, X4, W1, W2, W3, W4;
	input signed [15:0] bias;
	input signed [11:0] xmin, xmax;
	output signed [7:0] Y;
	
	wire signed [18:0] Sum;

	assign Sum = X1 * W1 + X2 * W2 + X3 * W3 + X4 * W4 + bias;

  	activationFunc activation_module (.x(Sum[18:7]), .f(Y), .xmin(xmin), .xmax(xmax));

endmodule


module activationFunc(x,f,xmin,xmax);

	input signed [11:0] x;
	output signed [7:0] f;
	input signed [11:0] xmin, xmax;

	assign f = (x >= xmin && x <= xmax) ? x : (x < xmin) ? xmin : xmax;

endmodule

