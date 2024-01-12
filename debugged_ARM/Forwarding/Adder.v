module Adder(x, y, res);
  input [31:0] x, y;
  output [31:0] res;

  assign res = x + y;

endmodule