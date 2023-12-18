`include "hazard_unit.v"
`include "stage_if.v"
`include "regs_if_id.v"
`include "stage_id.v"
`include "regs_id_ex.v"
`include "regs_mem_wb.v"
`include "regs_ex_mem.v"
`include "stage_ex.v"
`include "stage_mem.v"
`include "stage_wb.v"
module TopLevel(
    input clk, rst
);
    // Hazard
    wire hazard, hazardTwoSrc;
    wire [3:0] hazardRn, hazardRdm;

    // IF
    wire [31:0] pcOutIf, instOutIf;
    // IF-ID
    wire [31:0] pcOutIfId, instOutIfId;

    // ID
    wire [31:0] pcOutId;
    wire [3:0] aluCmdOutId;
    wire memReadOutId, memWriteOutId, wbEnOutId, branchOutId, sOutId;
    wire [31:0] reg1OutId, reg2OutId;
    wire immOutId;
    wire [11:0] shiftOperandOutId;
    wire [23:0] imm24OutId;
    wire [3:0] destOutId;
    // ID-EX
    wire [31:0] pcOutIdEx;
    wire [3:0] aluCmdOutIdEx;
    wire memReadOutIdEx, memWriteOutIdEx, wbEnOutIdEx, branchOutIdEx, sOutIdEx;
    wire [31:0] reg1OutIdEx, reg2OutIdEx;
    wire immOutIdEx;
    wire [11:0] shiftOperandOutIdEx;
    wire [23:0] imm24OutIdEx;
    wire [3:0] destOutIdEx;
    wire carryOut;

    // EX
    wire memReadOutEx, memWriteOutEx, wbEnOutEx;
    wire branchTaken;
    wire [31:0] branchAddr;
    wire [31:0] aluResOutEx, reg2OutEx;
    wire [3:0] destOutEx;
    wire [3:0] status; // N Z C V
    wire carryIn;
    assign carryIn = status[1];
    // EX-MEM
    wire memReadOutExMem, memWriteOutExMem, wbEnOutExMem;
    wire [31:0] aluResOutExMem, reg2OutExMem;
    wire [3:0] destOutExMem;

    // MEM
    wire memReadOutMem, wbEnOutMem;
    wire [31:0] aluResOutMem, memDataOutMem;
    wire [3:0] destOutMem;
    // MEM-WB
    wire memReadOutMemWb, wbEnOutMemWb;
    wire [31:0] aluResOutMemWb, memDataOutMemWb;
    wire [3:0] destOutMemWb;

    // WB
    wire wbEn;
    wire [31:0] wbValue;
    wire [3:0] wbDest;

    HazardUnit hzrd(
        .rn(hazardRn), .rdm(hazardRdm),
        .twoSrc(hazardTwoSrc),
        .destEx(destOutEx), .destMem(destOutMem),
        .wbEnEx(wbEnOutEx), .wbEnMem(wbEnOutMem),
        .hazard(hazard)
    );

    StageIf stIf(
        .clk(clk), .rst(rst),
        .branchTaken(branchTaken), .freeze(hazard),
        .branchAddr(branchAddr),
        .pc(pcOutIf), .instruction(instOutIf)
    );
    RegsIfId regsIf(
        .clk(clk), .rst(rst),
        .freeze(hazard), .flush(branchTaken),
        .pcIn(pcOutIf), .instructionIn(instOutIf),
        .pcOut(pcOutIfId), .instructionOut(instOutIfId)
    );

    StageId stId(
        .clk(clk), .rst(rst),
        .pcIn(pcOutIfId), .inst(instOutIfId),
        .status(status),
        .wbWbEn(wbEn), .wbValue(wbValue), .wbDest(wbDest),
        .hazard(hazard),
        .pcOut(pcOutId),
        .aluCmd(aluCmdOutId), .memRead(memReadOutId), .memWrite(memWriteOutId),
        .wbEn(wbEnOutId), .branch(branchOutId), .s(sOutId),
        .reg1(reg1OutId), .reg2(reg2OutId),
        .imm(immOutId), .shiftOperand(shiftOperandOutId), .imm24(imm24OutId), .dest(destOutId),
        .hazardRn(hazardRn), .hazardRdm(hazardRdm), .hazardTwoSrc(hazardTwoSrc)
    );
    RegsIdEx regsId(
        .clk(clk), .rst(rst),
        .pcIn(pcOutId),
        .aluCmdIn(aluCmdOutId), .memReadIn(memReadOutId), .memWriteIn(memWriteOutId),
        .wbEnIn(wbEnOutId), .branchIn(branchOutId), .sIn(sOutId),
        .reg1In(reg1OutId), .reg2In(reg2OutId),
        .immIn(immOutId), .shiftOperandIn(shiftOperandOutId), .imm24In(imm24OutId), .destIn(destOutId),
        .carryIn(carryIn), .flush(branchTaken),
        .pcOut(pcOutIdEx),
        .aluCmdOut(aluCmdOutIdEx), .memReadOut(memReadOutIdEx), .memWriteOut(memWriteOutIdEx),
        .wbEnOut(wbEnOutIdEx), .branchOut(branchOutIdEx), .sOut(sOutIdEx),
        .reg1Out(reg1OutIdEx), .reg2Out(reg2OutIdEx),
        .immOut(immOutIdEx), .shiftOperandOut(shiftOperandOutIdEx), .imm24Out(imm24OutIdEx), .destOut(destOutIdEx),
        .carryOut(carryOut)
    );

    StageEx stEx(
        .clk(clk), .rst(rst),
        .wbEnIn(wbEnOutIdEx), .memREnIn(memReadOutIdEx), .memWEnIn(memWriteOutIdEx),
        .branchTakenIn(branchOutIdEx), .ldStatus(sOutIdEx), .imm(immOutIdEx), .carryIn(carryOut),
        .exeCmd(aluCmdOutIdEx), .val1(reg1OutIdEx), .valRm(reg2OutIdEx), .pc(pcOutIdEx),
        .shifterOperand(shiftOperandOutIdEx), .signedImm24(imm24OutIdEx), .dest(destOutIdEx),
        .wbEnOut(wbEnOutEx), .memREnOut(memReadOutEx), .memWEnOut(memWriteOutEx),
        .branchTakenOut(branchTaken), .aluRes(aluResOutEx), .exeValRm(reg2OutEx), .branchAddr(branchAddr),
        .exeDest(destOutEx), .status(status)
    );
    RegsExMem regsEx(
        .clk(clk), .rst(rst),
        .wbEnIn(wbEnOutEx), .memREnIn(memReadOutEx), .memWEnIn(memWriteOutEx),
        .aluResIn(aluResOutEx), .valRmIn(reg2OutEx), .destIn(destOutEx),
        .wbEnOut(wbEnOutExMem), .memREnOut(memReadOutExMem), .memWEnOut(memWriteOutExMem),
        .aluResOut(aluResOutExMem), .valRmOut(reg2OutExMem), .destOut(destOutExMem)
    );

    StageMem stMem(
        .clk(clk), .rst(rst),
        .wbEnIn(wbEnOutExMem), .memREnIn(memReadOutExMem), .memWEnIn(memWriteOutExMem),
        .aluResIn(aluResOutExMem), .valRm(reg2OutExMem), .destIn(destOutExMem),
        .wbEnOut(wbEnOutMem), .memREnOut(memReadOutMem),
        .aluResOut(aluResOutMem), .memOut(memDataOutMem), .destOut(destOutMem)
    );
    RegsMemWb regsMem(
        .clk(clk), .rst(rst),
        .wbEnIn(wbEnOutMem), .memREnIn(memReadOutMem),
        .aluResIn(aluResOutMem), .memDataIn(memDataOutMem), .destIn(destOutMem),
        .wbEnOut(wbEnOutMemWb), .memREnOut(memReadOutMemWb),
        .aluResOut(aluResOutMemWb), .memDataOut(memDataOutMemWb), .destOut(destOutMemWb)
    );

    StageWb stWb(
        .clk(clk), .rst(rst),
        .wbEnIn(wbEnOutMemWb), .memREn(memReadOutMemWb),
        .aluRes(aluResOutMemWb), .memData(memDataOutMemWb), .destIn(destOutMemWb),
        .wbEnOut(wbEn), .wbValue(wbValue), .destOut(wbDest)
    );
endmodule
