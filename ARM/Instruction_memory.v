
module Instruction_memory(input clk, rst, input [31:0]PC, output reg [31:0]Instruction);

    reg [7:0] _Instruction[191:0];

    always @ (*) begin
        if (rst) begin
            {_Instruction[3],  _Instruction[2],  _Instruction[1],  _Instruction[0]} =  32'b1110_00_1_1101_0_0000_0000_000000010100;
            {_Instruction[7],  _Instruction[6],  _Instruction[5],  _Instruction[4]} =  32'b1110_00_1_1101_0_0000_0001_101000000001;
            {_Instruction[11],  _Instruction[10],  _Instruction[9], _Instruction[8]} = 32'b1110_00_1_1101_0_0000_0010_000100000011;
            {_Instruction[15], _Instruction[14], _Instruction[13], _Instruction[12]} = 32'b1110_00_0_0100_1_0010_0011_000000000010;
            {_Instruction[19], _Instruction[18], _Instruction[17], _Instruction[16]} = 32'b1110_00_0_0101_0_0000_0100_000000000000;
            {_Instruction[23], _Instruction[22], _Instruction[21], _Instruction[20]} = 32'b1110_00_0_0010_0_0100_0101_000100000100;
            {_Instruction[27], _Instruction[26], _Instruction[25], _Instruction[24]} = 32'b1110_00_0_0110_0_0000_0110_000010100000;
            {_Instruction[31], _Instruction[30], _Instruction[29], _Instruction[28]} = 32'b1110_00_0_1100_0_0101_0111_000101000010;
            {_Instruction[35], _Instruction[34], _Instruction[33], _Instruction[32]} = 32'b1110_00_0_0000_0_0111_1000_000000000011;
            {_Instruction[39], _Instruction[38], _Instruction[37], _Instruction[36]} = 32'b1110_00_0_1111_0_0000_1001_000000000110;
            {_Instruction[43], _Instruction[42], _Instruction[41], _Instruction[40]} = 32'b1110_00_0_0001_0_0100_1010_000000000101;
            {_Instruction[47], _Instruction[46], _Instruction[45], _Instruction[44]} = 32'b1110_00_0_1010_1_1000_0000_000000000110;
            {_Instruction[51], _Instruction[50], _Instruction[49], _Instruction[48]} = 32'b0001_00_0_0100_0_0001_0001_000000000001;
            {_Instruction[55], _Instruction[54], _Instruction[53], _Instruction[52]} = 32'b1110_00_0_1000_1_1001_0000_000000001000;
            {_Instruction[59], _Instruction[58], _Instruction[57], _Instruction[56]} = 32'b0000_00_0_0100_0_0010_0010_000000000010;
            {_Instruction[63], _Instruction[62], _Instruction[61], _Instruction[60]} = 32'b1110_00_1_1101_0_0000_0000_101100000001;
            {_Instruction[67], _Instruction[66], _Instruction[65], _Instruction[64]} = 32'b1110_01_0_0100_0_0000_0001_000000000000;
            {_Instruction[71], _Instruction[70], _Instruction[69], _Instruction[68]} = 32'b1110_01_0_0100_1_0000_1011_000000000000;
            {_Instruction[75], _Instruction[74], _Instruction[73], _Instruction[72]} = 32'b1110_01_0_0100_0_0000_0010_000000000100;
            {_Instruction[79], _Instruction[78], _Instruction[77], _Instruction[76]} = 32'b1110_01_0_0100_0_0000_0011_000000001000;
            {_Instruction[83], _Instruction[82], _Instruction[81], _Instruction[80]} = 32'b1110_01_0_0100_0_0000_0100_000000001101;
            {_Instruction[87], _Instruction[86], _Instruction[85], _Instruction[84]} = 32'b1110_01_0_0100_0_0000_0101_000000010000;
            {_Instruction[91], _Instruction[90], _Instruction[89], _Instruction[88]} = 32'b1110_01_0_0100_0_0000_0110_000000010100;
            {_Instruction[95], _Instruction[94], _Instruction[93], _Instruction[92]} = 32'b1110_01_0_0100_1_0000_1010_000000000100;
            {_Instruction[99],  _Instruction[98],  _Instruction[97], _Instruction[96]} = 32'b1110_01_0_0100_0_0000_0111_000000011000;
            {_Instruction[103], _Instruction[102], _Instruction[101], _Instruction[100]} = 32'b1110_00_1_1101_0_0000_0001_000000000100;
            {_Instruction[107], _Instruction[106], _Instruction[105], _Instruction[104]} = 32'b1110_00_1_1101_0_0000_0010_000000000000;
            {_Instruction[111], _Instruction[110], _Instruction[109], _Instruction[108]} = 32'b1110_00_1_1101_0_0000_0011_000000000000;
            {_Instruction[115], _Instruction[114], _Instruction[113], _Instruction[112]} = 32'b1110_00_0_0100_0_0000_0100_000100000011;
            {_Instruction[119], _Instruction[118], _Instruction[117], _Instruction[116]} = 32'b1110_01_0_0100_1_0100_0101_000000000000;
            {_Instruction[123], _Instruction[122], _Instruction[121], _Instruction[120]} = 32'b1110_01_0_0100_1_0100_0110_000000000100;
            {_Instruction[127], _Instruction[126], _Instruction[125], _Instruction[124]} = 32'b1110_00_0_1010_1_0101_0000_000000000110;
            {_Instruction[131], _Instruction[130], _Instruction[129], _Instruction[128]} = 32'b1100_01_0_0100_0_0100_0110_000000000000;
            {_Instruction[135], _Instruction[134], _Instruction[133], _Instruction[132]} = 32'b1100_01_0_0100_0_0100_0101_000000000100;
            {_Instruction[139], _Instruction[138], _Instruction[137], _Instruction[136]} = 32'b1110_00_1_0100_0_0011_0011_000000000001;
            {_Instruction[143], _Instruction[142], _Instruction[141], _Instruction[140]} = 32'b1110_00_1_1010_1_0011_0000_000000000011;
            {_Instruction[147], _Instruction[146], _Instruction[145], _Instruction[144]} = 32'b1011_10_1_0_111111111111111111110111;
            {_Instruction[151], _Instruction[150], _Instruction[149], _Instruction[148]} = 32'b1110_00_1_0100_0_0010_0010_000000000001;
            {_Instruction[155], _Instruction[154], _Instruction[153], _Instruction[152]} = 32'b1110_00_0_1010_1_0010_0000_000000000001;
            {_Instruction[159], _Instruction[158], _Instruction[157], _Instruction[156]} = 32'b1011_10_1_0_111111111111111111110011;
            {_Instruction[163], _Instruction[162], _Instruction[161], _Instruction[160]} = 32'b1110_01_0_0100_1_0000_0001_000000000000; 
            {_Instruction[167], _Instruction[166], _Instruction[165], _Instruction[164]} = 32'b1110_01_0_0100_1_0000_0010_000000000100;
            {_Instruction[171], _Instruction[170], _Instruction[169], _Instruction[168]} = 32'b1110_01_0_0100_1_0000_0011_000000001000;
            {_Instruction[175], _Instruction[174], _Instruction[173], _Instruction[172]} = 32'b1110_01_0_0100_1_0000_0100_000000001100;
            {_Instruction[179], _Instruction[178], _Instruction[177], _Instruction[176]} = 32'b1110_01_0_0100_1_0000_0101_000000010000;
            {_Instruction[183], _Instruction[182], _Instruction[181], _Instruction[180]} = 32'b1110_01_0_0100_1_0000_0110_000000010100;
            {_Instruction[187], _Instruction[186], _Instruction[185], _Instruction[184]} = 32'b1110_10_1_0_111111111111111111111111;
            {_Instruction[191], _Instruction[190], _Instruction[189], _Instruction[188]} = 32'b0;
        end else Instruction <= {_Instruction[PC + 2'b11], _Instruction[PC + 2'b10], _Instruction[PC + 2'b01], _Instruction[PC + 2'b00]};  
  end
    
endmodule
