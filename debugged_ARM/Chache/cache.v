`timescale 1ns/1ns
module Cache (input clk, rst, cache_write_en, cache_read_en, check_invalid,
    input    [16:0]   cache_address,
    input    [63:0]   cache_write_data,
    output   hit,
    output   [31:0]   readData       
);
    wire [5:0] index;
    wire [9:0] tag;
    wire offset;

    wire hit_1;
    wire hit_2;

    reg [31:0] data_1  [0:63][0:1];
    reg [31:0] data_2  [0:63][0:1];
    reg        valid_1 [0:63];
    reg        valid_2 [0:63];
    reg [9:0]  tag_1   [0:63];
    reg [9:0]  tag_2   [0:63];
    reg        LRU  [0:63];
    
    assign {tag, index, offset}  =  cache_address;
    assign hit_1 = (tag == tag_1[index]) && valid_1[index];
    assign hit_2 = (tag == tag_2[index]) && valid_2[index];
    assign hit = hit_1 || hit_2;
    assign readData = hit_1 ? data_1[index][offset] : (
                      hit_2 ? data_2[index][offset] : 32'b0);
                      
    integer i;
    always @(posedge clk, posedge rst) begin
        if (rst) begin
				  for (i = 0; i < 64; i = i + 1) begin
					   data_1 [i][0] <= 32'b0;
					   data_1 [i][1] <= 32'b0;
					   data_2 [i][0] <= 32'b0;
					   data_2 [i][1] <= 32'b0;
					   tag_1 [i] <= 10'b0;
					   tag_2 [i] <= 10'b0;
					   valid_1 [i] <= 1'b0;
					   valid_2 [i] <= 1'b0;
					   LRU [i] <= 1'b0;
					end
        end
        else if(cache_read_en) begin
          if(hit_1) LRU[index] = 1'b0;
          else if(hit_2) LRU[index] = 1'b1;
        end
        else if (cache_write_en) begin
          if(LRU[index]) begin
            data_1[index][0] <= cache_write_data[31:0];
            data_1[index][1] <= cache_write_data[63:32];
            tag_1[index] <= tag;
            valid_1[index] <= 1'b1;
          end
          else begin
            data_2[index][0] <= cache_write_data[31:0];
            data_2[index][1] <= cache_write_data[63:32];
            tag_2[index] <= tag;
            valid_2[index] <= 1'b1;
          end
        end
        if(check_invalid) begin
          if(hit_1) begin
            valid_1[index] = 1'b0;
            LRU[index] = 1'b1;
          end
        else if(hit_2) begin
          valid_2[index] = 1'b0;
          LRU[index] = 1'b0;
        end
      end
    end

endmodule

