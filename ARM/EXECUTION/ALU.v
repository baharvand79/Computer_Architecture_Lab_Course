
module ALU(input clk, rst, input [31:0]val_1, val_2,
  input [3:0]exe_cmd, sr_in,output reg [31:0]alu_result, output reg [3:0]sr);
  
  reg z, c, n, v;
  wire z_in, c_in, n_in, v_in;
  assign {z_in, c_in, n_in, v_in} = sr_in;
  
  always @ (val_1, val_2, exe_cmd, z_in, c_in, n_in, v_in) begin
    
    alu_result = 32'b00000000000000000000000000000000;
    sr = 4'b0000; n = 1'b0; c = 1'b0; z = 1'b0; v = 1'b0;
    
    case (exe_cmd)
      4'b0001: begin alu_result = val_2; end
      4'b1001: begin alu_result = ~val_2; end
      4'b0010: begin
        {c, alu_result} = val_1 + val_2;
        if ((val_1[31] == val_2[31]) && (val_1[31] == (~alu_result[31]))) v = 1'b1;
      end
      4'b0011: begin
        {c, alu_result} = val_1 + val_2 + c_in;
        if ((val_1[31] == val_2[31]) && (val_1[31] == (~alu_result[31]))) v = 1'b1;
      end
      4'b0100: begin
        {c, alu_result} = val_1 - val_2;
        if ((val_1[31] == (~val_2[31])) && (val_1[31] == (~alu_result[31]))) v = 1'b1;
      end
      4'b0101: begin
        {c, alu_result} = val_1 - val_2 - {{31'b0000000000000000000000000000000}, ~(c_in)};
        if ((val_1[31] == (~val_2[31])) && (val_1[31] == (~alu_result[31]))) v = 1'b1;
      end
      4'b0110: begin alu_result = val_1 & val_2; end
      4'b0111: begin alu_result = val_1 | val_2; end
      4'b1000: begin alu_result = val_1 ^ val_2; end
    endcase

    z = alu_result == 32'b00000000000000000000000000000000 ? 1'b1 : 1'b0;
    n = alu_result[31];    
    sr = {z, c, n, v};
  end
endmodule
