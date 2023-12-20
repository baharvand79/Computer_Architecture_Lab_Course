
// module StatusRegister(clk, rst, s, status_bits, sr);
// 	input clk, rst, s; 
// 	input [3:0]status_bits;
// 	output reg [3:0]sr;
  
// 	always @ (negedge clk, posedge rst) begin
// 		if (rst) sr <= 4'b0000;
// 		else if (s) sr <= status_bits;
// 		else sr <= sr;
//   	end

// endmodule
module StatusRegister #(
    parameter N = 4
)(
    input clk, rst,
    input [N-1:0] in,
    input s,
    output reg [N-1:0] out
);
    always @(negedge clk or posedge rst) begin
        // if (rst)
            out <= {N{1'b0}};
        // else if (s)
        //     out <= in;
    end
endmodule