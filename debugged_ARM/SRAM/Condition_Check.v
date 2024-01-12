
module Condition_Check(cond, status_regs, cond_res);

  input [3:0] cond, status_regs; 
  output reg cond_res;

  wire n, z, c, v;

  assign {n, z, c, v} = status_regs;

  always@(*) begin
    cond_res = 1'b0;
    case(cond)
    4'b0000: if(z) cond_res = 1'b1;
    4'b0001: if(~z) cond_res = 1'b1;
    4'b0010: if(c) cond_res = 1'b1;
    4'b0011: if(~c) cond_res = 1'b1;
    4'b0100: if(n) cond_res = 1'b1;
    4'b0101: if(~n) cond_res = 1'b1;
    4'b0110: if(v) cond_res = 1'b1;
    4'b0111: if(~v) cond_res = 1'b1;
    4'b1000: if(c && ~z) cond_res = 1'b1;
    4'b1001: if(~c || z) cond_res = 1'b1;
    4'b1010: if(n == v) cond_res = 1'b1;
    4'b1011: if(n != v) cond_res = 1'b1;
    4'b1100: if(~z && n == v) cond_res = 1'b1;
    4'b1101: if(z && n != v) cond_res = 1'b1;
    4'b1110: cond_res = 1'b1;
    endcase
  end

endmodule
