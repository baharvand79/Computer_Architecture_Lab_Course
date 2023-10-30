module IF_Stage(clk, rst, freeze, Branch_Tacken, Branch_Address, Instruction, pc);
    input clk, rst, freeze, Branch_Tacken;
    input [31:0] Branch_Address;
    output [31:0]  Instruction;
    output [31:0] pc;
    wire [31:0] pc_out, adder_o;
    reg [31:0] pc_in;
    wire [31:0] PC_in;
    input [31:0] x0, x1;
	input sel;
	output [31:0] y;
	
    always@(posedge clk)
	    pc_in = Branch_Tacken ? adder_o : Branch_Address;
    assign PC_in = pc_in;
    // mux2to1 mux_IF(.sel(Branch_Tacken), .x0(Branch_Address), .x1(adder_o), .y(pc_in));
    PC pc_instance(.clk(clk), .rst(rst), .freeze(freeze), .in(PC_in), .out(pc_out));
    // assign adder_o = pc_out;
    // assign Instruction = pc_out;
    adder adder_IF(.x0(pc_out), .x1(32'd4), .y(adder_o));
    Instruction_memory IM(.clk(clk), .rst(rst), .PC(pc_out), .Instruction(Instruction));
    assign pc = pc_out;
endmodule
