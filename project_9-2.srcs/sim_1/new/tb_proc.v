`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.06.2021 05:37:53
// Design Name: 
// Module Name: tb_proc
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


module tb_proc
();
reg clk=1'b0;
reg [7:0] gpi = 0;
wire [7:0] gpo;
reg [31:0] clkctr = 0;

initial
begin
    while(1)
    begin
        #1 clk=1'b0;
        #1 clk=1'b1;
        clkctr <= clkctr + 1;
    end
end

proc proc_i
(
    .clk(clk)
);

endmodule
