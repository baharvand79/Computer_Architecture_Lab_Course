
module adder(x0, x1, y);
	input [31:0] x0, x1;
	output [31:0] y;
	
	assign y = x0 + x1;
endmodule 