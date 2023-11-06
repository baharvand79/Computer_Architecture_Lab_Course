module ControlUnit (mode, op_code, s_in,
  output reg [3:0] exe_cmd, output reg mem_r_en, mem_w_en, wb_en, s, b);

  input [1:0]mode;
  input [3:0]op_code;
  input s_in;

  always @ (op_code, mode, s_in) begin
    mem_w_en = 1'b0; mem_r_en = 1'b0; exe_cmd = 4'b0000; wb_en = 1'b0; s = 1'b0; b = 1'b0;
    case (mode)
      2'b00: begin
        case (op_code)
          4'b0000: begin exe_cmd = 4'b0110; wb_en = 1'b1; s = s_in; end
          4'b0001: begin exe_cmd = 4'b1000; wb_en = 1'b1; s = s_in; end
          4'b0010: begin exe_cmd = 4'b0100; wb_en = 1'b1; s = s_in; end
          4'b0100: begin exe_cmd = 4'b0010; wb_en = 1'b1; s = s_in; end
          4'b0101: begin exe_cmd = 4'b0011; wb_en = 1'b1; s = s_in; end
          4'b0110: begin exe_cmd = 4'b0101; wb_en = 1'b1; s = s_in; end
          4'b1000: begin exe_cmd = 4'b0110; s = s_in; end
          4'b1010: begin exe_cmd = 4'b0100; s = s_in; end
          4'b1100: begin exe_cmd = 4'b0111; wb_en = 1'b1; s = s_in; end
          4'b1101: begin exe_cmd = 4'b0001; wb_en = 1'b1; s = s_in; end
          4'b1111: begin exe_cmd = 4'b1001; wb_en = 1'b1; s = s_in; end
        endcase
      end
      2'b01: begin
        case (s_in)
          1'b0: begin exe_cmd = 4'b0010; mem_w_en = 1'b1; end
          1'b1: begin exe_cmd = 4'b0010; wb_en = 1'b1; mem_r_en = 1'b1; end
        endcase
      end
      2'b10: begin exe_cmd = 4'bxxxx; s = s_in; b = 1'b1; end
    endcase
  end

endmodule

