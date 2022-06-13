`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2022 02:27:44 PM
// Design Name: 
// Module Name: tb_cpu
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


module tb_post_cpu;
reg clk = 0;
reg rst = 0;
reg ena = 1;

always #100 clk = ~clk;

initial
begin
    #10 rst = 1;
    #10 rst = 0;
end

CPU uut(
    .clk(clk),
    .rst(rst),
    .ena(ena)
    );

endmodule
