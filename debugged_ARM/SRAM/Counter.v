module Counter(clk, rst, cnt_en, count_res);
    input clk, rst, cnt_en; 
    output reg[2:0] count_res;
    
    always @(posedge clk, posedge rst) begin
        if (rst)
            count_res <= 3'b0;
        else if (cnt_en) begin
            if (count_res == 3'b101 + 1)
                count_res <= 3'b0;
            else
                count_res <= count_res + 1;
      end
  end

endmodule