
// module Data_Memory(clk, rst, mem_r_en, mem_w_en, val_rm, alu_res, Data_Memory_Output, instruction_in, instruction_out);
// 	input clk, rst, mem_r_en, mem_w_en;
// 	input [31:0] val_rm, alu_res, instruction_in;
// 	output reg [31:0] Data_Memory_Output;
// 	output [31:0] instruction_out;
// 	reg [31:0] memory[0:64];
// 	wire [31:0] address, Data_Memory_Output_tmp;

// 	assign address = ((val_rm - 1024) >> 2);
// 	assign instruction_out = instruction_in;
// //	integer i;
// //	initial begin
// //		for(i = 0; i < 64; i = i+1)
// //			memory[i] = 32'd0;
// //	end
// //	always @ (posedge clk, posedge rst) begin
// //		if(rst) begin
// //			Data_Memory_Output = 32'b;
// //		end
// //		if(mem_w_en) begin
// //			memory[address] = alu_res;
// //		end
// //	end
// //	always@(mem_r_en, address)begin
// //		if(mem_r_en)begin
// //			Data_Memory_Output = memory[address];
// //		end
// //	end
// 	assign Data_Memory_Output_tmp = (mem_r_en) ? memory[address] : Data_Memory_Output;

// 	always @ (posedge clk, posedge rst) begin
// 		Data_Memory_Output = Data_Memory_Output_tmp;
// 		if(rst) begin
// 			Data_Memory_Output = 32'b0;
// 		end
// 		else if(mem_r_en)begin
// 			memory[address] <= alu_res;
// 		end

// 	end
// endmodule

module DataMemory(
    input clk, rst,
    input [31:0] memAdr, writeData,
    input memRead, memWrite,
    output reg [31:0] readData
);
    localparam WordCount = 64;

    reg [31:0] dataMem [0:WordCount-1]; // 256B memory

    wire [31:0] dataAdr, adr;
    assign dataAdr = memAdr - 32'd1024;
    assign adr = {2'b00, dataAdr[31:2]}; // Align address to the word boundary

    always @(negedge clk) begin
        if (memWrite)
            dataMem[adr] <= writeData;
    end

    always @(memRead or adr) begin
        if (memRead)
            readData = dataMem[adr];
    end
endmodule

