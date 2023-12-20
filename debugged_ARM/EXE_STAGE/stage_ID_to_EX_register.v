module Stage_ID_to_EX_Register(
    input clk, rst,
    input [31:0] pc_in, reg1_in, reg2_in, instruction_in,
    input [3:0] cmd_exe_in,
    input mem_read_in, mem_write_in, wb_en_in, b_in, s_in,
    input carry_in, flush, imm_in,
    input [11:0] shift_operand_in,
    input signed [23:0] imm24_in,
    input [3:0] dest_in,
    output reg [31:0] reg1_out, reg2_out, pc_out, instruction_out,
    output reg mem_read_out, mem_write_out, wb_en_out, b_out, s_out,
    output reg imm_out, carry_out,
    output reg [3:0] exe_cmd_out,
    output reg [11:0] shift_operand_out,
    output reg signed [23:0] imm24_out,
    output reg [3:0] dest_out
);
    always @(posedge clk, posedge rst) begin
        if (rst || flush) begin
            {reg1_out, reg2_out, pc_out, instruction_out} <= 128'd0;
            {mem_read_out, mem_write_out, wb_en_out, b_out, s_out} <= 5'd0;
            {imm_out, carry_out} <= 2'd0;
            exe_cmd_out <= 4'd0;
            shift_operand_out <= 12'd0;
            imm24_out <= 24'd0;
            dest_out <= 4'd0;
        end
        else begin
            {reg1_out, reg2_out, pc_out, instruction_out} <= {reg1_in, reg2_in, pc_in, instruction_in};
            {mem_read_out, mem_write_out, wb_en_out, b_out, s_out} <= {mem_read_in, mem_write_in, wb_en_in, b_in, s_in};
            {imm_out, carry_out} <= {imm_in, carry_in};
            exe_cmd_out <= cmd_exe_in;
            shift_operand_out <= shift_operand_in;
            imm24_out <= imm24_in;
            dest_out <= dest_in;
        end
    end
endmodule