`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2022 01:11:01 PM
// Design Name: 
// Module Name: DMEM
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


module DMEM(
    input clk,
    input ena,
    input [10:0] DM_Addr,
    input [31:0] DM_WData,
    output [31:0] DM_RData,
    input DM_W,
    input DM_R
    );

reg [31:0] memory [0:31];

initial
begin
    memory[0] = 32'd999;
    memory[1] = 32'd20;
    memory[2] = 32'b0;
    memory[3] = 32'b0;
    memory[4] = 32'd0;
    memory[5] = 32'd0;
    memory[6] = 32'd0;

end

always @(posedge clk) begin
    if(ena && DM_W) begin
    memory[DM_Addr] <= DM_WData;
    end
end

assign DM_RData = (ena && DM_R) ? memory[DM_Addr] : 32'bz;

ila_0 ila_inst(
    .clk(clk),
    .probe0(memory[1]),
    .probe1(memory[2]),
    .probe2(memory[3]),
    .probe3(memory[4]),
    .probe4(memory[5]),
    .probe5(memory[6]));

endmodule
