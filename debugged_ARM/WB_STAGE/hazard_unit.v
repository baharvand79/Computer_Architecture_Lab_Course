module hazard_unit(
    	input exe_wb_en,
	input [3:0] src_1, src_2, exe_dest, mem_dest,
	input [31:0] instruction_exe, instruction_mem,
	input mem_wb_en, two_src,
	output reg hazard_detected
);

	wire [3:0] op_code_exe, op_code_mem;
	assign op_code_exe = instruction_exe[24:21];
  	assign op_code_mem = instruction_mem[24:21];

	always @ (*) begin
		hazard_detected = 1'b0;
		if (exe_wb_en && (src_1 == exe_dest) && (op_code_exe != 4'b1101) && (op_code_exe != 4'b1111)) hazard_detected = 1'b1;
       		else if (mem_wb_en && (src_1 == mem_dest) && (op_code_mem != 4'b1101) && (op_code_mem != 4'b1111)) hazard_detected = 1'b1;
        	else if (mem_wb_en && two_src && (src_2 == mem_dest)) hazard_detected = 1'b1;
        	else if (exe_wb_en && two_src && (src_2 == exe_dest))  hazard_detected = 1'b1;
        end
endmodule

	