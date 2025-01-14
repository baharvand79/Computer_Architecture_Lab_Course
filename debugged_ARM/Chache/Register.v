module register(clk, rst, ld, in, out);
    input clk, rst, ld; 
    input[31:0] in;
    output reg[31:0] out;

    always @(posedge clk, posedge rst)
	begin
		if(rst) 
            out <= 0;
		else if(~ld)
            out <= in;
	end

endmodule