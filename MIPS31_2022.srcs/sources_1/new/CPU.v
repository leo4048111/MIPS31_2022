`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2022 10:14:40 PM
// Design Name: 
// Module Name: CPU
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


module CPU(
    input clk,
    input rst,
    input ena
    );

wire [31:0] PC;
wire DM_W;
wire DM_R;
wire [31:0] DM_RData;
wire [31:0] DM_WData;
wire [10:0] DM_Addr;
wire [31:0] IM_Inst;

Controller controller(
    .clk(clk),
    .ena(ena),
    .rst(rst),
    .IM_Inst(IM_Inst),
    .PC(PC),
    .DM_W(DM_W),
    .DM_R(DM_R),
    .DM_ReadData(DM_RData),
    .DM_WriteData(DM_WData),
    .DM_Addr(DM_Addr)
    );

DMEM dmem(
    .clk(clk),
    .ena(ena),
    .DM_Addr(DM_Addr),
    .DM_WData(DM_WData),
    .DM_RData(DM_RData),
    .DM_W(DM_W),
    .DM_R(DM_R)
    );
    
//wire [10:0] IM_Addr = (PC > 32'h004000d4) ? (32'h004000d8 - 32'h00400000) >> 2 : (PC - 32'h00400000) >> 2;
wire [10:0] IM_Addr = (PC - 32'h00400000) >> 2;

IMEM imem(
    .IM_Addr(IM_Addr),
    .IM_Inst(IM_Inst)
    );

endmodule
