module Status_Register(clk, rst, load, status_in, status);
  input clk, rst, load;
  input [3 : 0] status_in;
  output reg[3: 0] status;

  always@(negedge clk, posedge rst) begin
    if(rst) begin
      status <= 4'b0;
    end
    else if(load) begin
      status <= status_in;
    end
    else begin
      status <= status;
    end
  end

endmodule