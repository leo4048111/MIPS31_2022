`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2022 05:51:07 PM
// Design Name: 
// Module Name: Controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Controller(
    input clk,
    input ena,
    input rst,
    input [31:0] IM_Inst,  //从IMEM读出的指令
    output reg [31:0] PC,  //PC寄存器，储存下一条指令在IM中的地址
    //DMEM操作控制信号
    output DM_W, 
    output DM_R,
    input [31:0] DM_ReadData,
    output [31:0] DM_WriteData,
    output [10:0] DM_Addr
    //ALU控制信号
    );

//指令译码器部分
wire [5:0]OP,func;
assign OP = IM_Inst[31:26];//RIJ指令类型
assign func = OP ? 6'bz : IM_Inst[5:0];//R指令类型(OP为0)

//R型指令译码
wire ADD, ADDU, SUB, SUBU, AND, OR, XOR, NOR, SLT, SLTU, SLL, SRL, SRA, SLLV, SRLV, SRAV, JR;
assign ADD = (OP == 0 && func == 6'b100000);
assign ADDU = (OP == 0 && func == 6'b100001);
assign SUB = (OP == 0 && func == 6'b100010);
assign SUBU = (OP == 0 && func == 6'b100011);
assign AND = (OP == 0 && func == 6'b100100);
assign OR = (OP == 0 && func == 6'b100101);
assign XOR = (OP == 0 && func == 6'b100110);
assign NOR = (OP == 0 && func == 6'b100111);
assign SLT = (OP == 0 && func == 6'b101010);
assign SLTU = (OP == 0 && func == 6'b101011);
assign SLL = (OP == 0 && func == 6'b000000);
assign SRL = (OP == 0 && func == 6'b000010);
assign SRA = (OP == 0 && func == 6'b000011);
assign SLLV = (OP == 0 && func == 6'b000100);
assign SRLV = (OP == 0 && func == 6'b000110);
assign SRAV = (OP == 0 && func == 6'b000111);
assign JR = (OP == 0 && func == 6'b001000);

//I型指令译码
wire ADDI, ADDIU, ANDI, ORI, XORI, LW, SW, BEQ, BNE, SLTI, SLTIU, LUI;
assign ADDI = (OP == 6'b001000);
assign ADDIU = (OP == 6'b001001);
assign ANDI = (OP == 6'b001100);
assign ORI = (OP == 6'b001101);
assign XORI = (OP == 6'b001110);
assign LW = (OP == 6'b100011);
assign SW = (OP == 6'b101011);
assign BEQ = (OP == 6'b000100);
assign BNE = (OP == 6'b000101);
assign SLTI = (OP == 6'b001010);
assign SLTIU = (OP == 6'b001011);
assign LUI = (OP == 6'b001111);

//J型指令译码
wire J,JAL;
assign J = (OP == 6'b000010);
assign JAL = (OP==6'b000011);

//寄存器堆控制信号
wire [4:0] RF_RAddr1, RF_RAddr2, RF_WAddr;    //寄存器堆读取地址和写入地址
wire [31:0] RF_RData1, RF_RData2, RF_WData;   //寄存器堆读出数据和写入数据
wire RF_R, RF_W;                              //寄存器堆读写控制信号
assign RF_W = ~(JR|SW|BEQ|BNE|J|(ADD && OF)|(ADDI && OF)|(SUB && OF));
assign RF_R = ~(J|JAL|LUI);
assign RF_RAddr1 = IM_Inst[25:21];
assign RF_RAddr2 = IM_Inst[20:16];
assign RF_WAddr = JAL ? 31 : (OP ? IM_Inst[20:16] :IM_Inst[15:11]);

//ALUC标志位与控制信号
wire ZF, SF, CF, OF;
wire [3:0] ALUC;   
wire [31:0] ALU_A, ALU_B, ALU_Result;  //ALU的两个操作数和计算结果
wire [4:0] shamt;
wire should_sign_ext;
assign should_sign_ext = ADDI | ADDIU | SLTI | SLTIU;
assign shamt = IM_Inst[10:6];
assign ALU_A = (SLL|SRL|SRA) ? {23'b0, shamt} : RF_RData1;
assign ALU_B = OP && !BEQ && !BNE ? (should_sign_ext ? {{16{IM_Inst[15]}}, IM_Inst[15:0]} : {16'b0, IM_Inst[15:0]}) : RF_RData2;
assign ALUC[0] = SUBU | SUB | BEQ | BNE | OR | ORI | NOR  | SLT | SLTI | SRL | SRLV;
assign ALUC[1] = ADD | ADDI | SUB | BEQ | BNE | XOR | XORI | NOR | SLT | SLTI | SLTU | SLTIU | SLL | SLLV;
assign ALUC[2] = AND | ANDI | OR | ORI | XOR | XORI | NOR | SRA | SRAV | SLL | SLLV | SRL | SRLV;
assign ALUC[3] = LUI | SLT | SLTI | SLTU | SLTIU | SRA | SRAV | SLL | SLLV | SRL | SRLV;


//寄存器堆写入数据连接
assign RF_WData = LW ? DM_ReadData : (JAL ? PC_Next : ALU_Result);

//存储器控制信号
assign DM_W = SW;
assign DM_R = LW;
assign DM_WriteData = RF_RData2;
assign DM_Addr = (RF_RData1 + {{16{IM_Inst[15]}}, IM_Inst[15:0]} - 32'h10010000)/4;

//PC更新引脚
wire [31:0] PC_Next;
assign PC_Next = PC + 4;

//PC更新模块，时序逻辑实现
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // reset
        PC <= 32'h00400000;
    end
    else if (JR) begin
        PC <= RF_RData1;   //跳转到寄存器内地址
    end
    else if (J | JAL) begin
        PC <= {PC_Next[31:28], IM_Inst[25:0], 2'b0};  
    end
    else if ((BEQ && ZF) || (BNE && !ZF)) begin
        PC <= PC_Next + {{14{IM_Inst[15]}}, IM_Inst[15:0], 2'b0}; //偏移符号扩展到32位后与PC+4相加
    end
    else begin
        PC <= PC_Next;
    end
end

RegFile RF(
    .RF_ena(ena),
    .RF_rst(rst),
    .RF_clk(clk),
    .RF_RAddr1(RF_RAddr1),
    .RF_RAddr2(RF_RAddr2),
    .RF_WAddr(RF_WAddr),
    .RF_WData(RF_WData),
    .RF_W(RF_W),
    .RF_R(RF_R),
    .RF_RData1(RF_RData1),
    .RF_RData2(RF_RData2)
    );

    
ALU alu(
    .ALU_A(ALU_A),
    .ALU_B(ALU_B),
    .ALU_Result(ALU_Result),
    .ALUC(ALUC),
    .ZF(ZF), 
    .CF(CF), 
    .SF(SF), 
    .OF(OF) 
);

endmodule
