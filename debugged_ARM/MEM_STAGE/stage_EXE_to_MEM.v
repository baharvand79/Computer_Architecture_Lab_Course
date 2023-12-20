module Stage_EXE_to_MEM_Reg(
    input clk, rst,
    input wb_en_in, mem_read_en_in, mem_write_en_in,
    input [31:0] alu_res_in, val_rm_in, instruction_in,
    input [3:0] dest_in,
    output reg wb_en_out, mem_read_en_out, mem_write_en_out,
    output reg [31:0] alu_res_out, val_rm_out, instruction_out,
    output reg [3:0] dest_out
);
    always@(posedge clk, posedge rst) begin
        if(rst) begin
            {wb_en_out, mem_read_en_out, mem_write_en_out} <= 3'd0;
            {alu_res_out, val_rm_out, instruction_out} <= 96'd0;
            dest_out <= 4'd0;
        end else begin
            {wb_en_out, mem_read_en_out, mem_write_en_out} <= {wb_en_in, mem_read_en_in, mem_write_en_in};
            {alu_res_out, val_rm_out, instruction_out} <= {alu_res_in, val_rm_in, instruction_in};
            dest_out <= dest_in;
        end
    end
endmodule