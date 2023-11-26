
module IF_Stage_Reg (input clk, rst, input [31:0]pc_in, instruction_in,  
  input flush, freeze, output reg [31:0] pc, instruction);
  
  always @ (posedge clk, posedge rst) begin
    if (rst) begin
      pc <= 32'b00000000000000000000000000000000;
      instruction <= 32'b11100000000000000000000000000000;
    end else if (!freeze) begin
      if (flush) begin
        pc <= 32'b00000000000000000000000000000000;
        instruction <= 32'b11100000000000000000000000000000;
      end else begin instruction <= instruction_in; pc <= pc_in; end
    end
  end

endmodule
