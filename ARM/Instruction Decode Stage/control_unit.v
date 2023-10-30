module control_unit(op_code, mode, s_in, exe_cmd, mem_r_en, mem_w_en, s, b, wb_en);
	input [3:0] op_code;
	input [1:0] mode;
	input s_in;
	output reg [3:0] exe_cmd;
	output reg mem_r_en, mem_w_en, s, b, wb_en;
	always @(op_code, mode, s_in) begin
		case(mode)
			2'b00:begin
				case(op_code)	
					4'b0000: begin exe_cmd = 4'b0110; s = s_in; wb_en = 1'b1; end
          				4'b0001: begin exe_cmd = 4'b1000; s = s_in; wb_en = 1'b1; end
          				4'b0010: begin exe_cmd = 4'b0100; s = s_in; wb_en = 1'b1; end
          				4'b0100: begin exe_cmd = 4'b0010; s = s_in; wb_en = 1'b1; end
          				4'b0101: begin exe_cmd = 4'b0011; s = s_in; wb_en = 1'b1; end
          				4'b0110: begin exe_cmd = 4'b0101; s = s_in; wb_en = 1'b1; end
         				4'b1000: begin exe_cmd = 4'b0110; s = s_in; end
          				4'b1010: begin exe_cmd = 4'b0100; s = s_in; end
          				4'b1100: begin exe_cmd = 4'b0111; s = s_in; wb_en = 1'b1; end
          				4'b1101: begin exe_cmd = 4'b0001; s = s_in; wb_en = 1'b1; end
          				4'b1111: begin exe_cmd = 4'b1001; s = s_in; wb_en = 1'b1; end
				endcase
			end
			2'b01:begin
				case(s_in)
          				1'b0: begin exe_cmd = 4'b0010; mem_w_en = 1'b1; end
          				1'b1: begin exe_cmd = 4'b0010; wb_en = 1'b1; mem_r_en = 1'b1; end
        			endcase
			end
			2'b10:begin exe_cmd = 4'bxxxx; s = s_in; b = 1'b1; end
		endcase
	end
endmodule
