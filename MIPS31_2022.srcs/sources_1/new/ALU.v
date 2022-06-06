`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2022 10:32:47 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] ALU_A,  //操作数A
    input [31:0] ALU_B,
    input [3:0] ALUC, //控制信号
    output reg [31:0] ALU_Result=0, //由a b 经过 aluc 指定操作生成
    output reg ZF=0,  //零标志位，运算结果为0即影响该标志位
    output reg CF=0, //进位标志位，无符号加减法，比较和移位影响该标志位
    output reg SF=0, //负数标志位，所有运算影响该标志位
    output reg OF=0 //溢出标志位，有符号加减法影响该标志位 
    );

    always@(*)  //采用组合逻辑设计ALU
    begin
    casex (ALUC)
        4'b0000:  //ADDU ADDIU
            {CF,ALU_Result} = {1'b0,ALU_A} + {1'b0,ALU_B};   //单符号位加法    
        4'b0010: //ADD ADDI
            //使用双符号位运算，符号位不同即溢出
            begin
            {OF, ALU_Result} = {ALU_A[31], ALU_A} + {ALU_B[31], ALU_B};
            OF = OF ^ ALU_Result[31];
            end
        4'b0001: //SUBU
            begin
            {CF, ALU_Result} = {1'b0, ALU_A} - {1'b0, ALU_B};
            end
        4'b0011://SUB BEQ BEN
            begin
            {OF, ALU_Result} = {ALU_A[31], ALU_A} - {ALU_B[31], ALU_B};
            OF = OF ^ ALU_Result[31];
            end
        4'b0100://AND ANDI
            ALU_Result = ALU_A & ALU_B;
        4'b0101://OR ORI
            ALU_Result = ALU_A | ALU_B;
        4'b0110://XOR XORI
            ALU_Result = ALU_A ^ ALU_B;  
        4'b0111://NOR
            ALU_Result = ~(ALU_A | ALU_B);
        4'b100x://LUI置高位立即数
            ALU_Result = {ALU_B[15:0], 16'b0};
        4'b1011://SLT SLTI 
            begin
            ALU_Result = ALU_A - ALU_B;//-  + = +；+  - = -

            if(ALU_A[31] ^ ALU_B[31])begin //正数一定大于负数，负数一定小于正数
                SF = ALU_A[31];
            end else begin
                SF = ALU_Result[31]; 
            end 
            ALU_Result = SF;
            end
        4'b1010://SLTU SLTIU
            begin
            {CF, ALU_Result}={1'b0,ALU_A} - {1'b0,ALU_B};
        
            ALU_Result = CF;
            end
        4'b1100://SRA SRAV
            {ALU_Result, CF} = ALU_B[31] ? ~(~{ALU_B,1'b0} >> ALU_A): {ALU_B,1'b0}>>ALU_A;
        4'b111x://SLL SLLV
            {CF, ALU_Result} = {1'b0, ALU_B} << ALU_A;
        4'b1101://SRL SRLV
            {ALU_Result, CF} = {ALU_B ,1'b0} >> ALU_A;
        default:
            ;
    endcase
    
    if(ALU_Result == 32'b0)
        ZF = 1;
    else 
        ZF = 0;
            
    if(ALUC != 4'b101x)
        SF = ALU_Result[31];
    else;

    end
endmodule
