module Stage_IF_to_ID_Register(
    input clk, rst, freeze, flush,
    input [31:0] pc_in, instruction_in,
    output reg [31:0] pc_out, instruction_out
);
    always @(posedge clk, posedge rst) begin
        if(rst) begin
            pc_out <= 32'd0;
            instruction_out <= 32'd0;
        end
        else if (flush) begin
            pc_out <= 32'd0;
            instruction_out <= 32'd0;
        end
        else if (~freeze) begin
            pc_out <= pc_in;
            instruction_out <= instruction_in;
        end
    end
endmodule