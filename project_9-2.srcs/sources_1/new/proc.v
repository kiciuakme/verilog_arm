`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.06.2021 13:35:35
// Design Name: 
// Module Name: proc
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


module proc
(
    input clk,
    input  [7:0] gpi,
    output [7:0] gpo
);
// pamieci
reg  [7:0]  ireg [7:0];
initial
begin
    ireg[0] <= 0;
    ireg[1] <= 0;
    ireg[2] <= 0;
    ireg[3] <= 0;
    ireg[4] <= 0;
    //ireg[5] <= 0;
    
    ireg[6] <= 0;
    ireg[7] <= 0;
end

wire [31:0] instr;
// dekodowanie instrukcji
wire [1:0]  pc_op  = instr[25:24];
wire [1:0] alu_op  = instr[21:20];
wire [2:0]  rx_op  = instr[18:16];
wire       imm_op  = instr[15];
wire [2:0]  ry_op  = instr[14:12];
wire        rd_op  = instr[11];
wire [2:0]   d_op  = instr[10:8];
wire [7:0] imm     = instr[7:0];
// multipleksy
wire [7:0] data;
wire [7:0] rxm     = ireg[rx_op];
wire [7:0] rym     = ireg[ry_op];
wire [7:0] immm    = imm_op? imm : rym;
wire [7:0] alu_and = rxm & rym;
wire [7:0] alu_add = rxm + rym;
wire [7:0] alu_eq0 = {7'b0, rxm==0};
wire [7:0] alum    = alu_op[1]? (alu_op[0]? immm    : alu_eq0)
                              : (alu_op[0]? alu_add : alu_and);
    // alu_op: 00 and 01 add 10 eq0 11 mv imm
wire       jmpc    =  pc_op[1]? (!alu_eq0[0]) : pc_op[0];
    // pc_op: 00 bez skoku 01 skok bwar 10 skok rx==0 11 skok rx!=0
wire [7:0] pcm     =      jmpc? alum : (ireg[7]+1);
wire [7:0] rdm     =     rd_op? alum : data;
wire       dekoder;
// banki
d_mem data_memory (.address(alum   ), .data(data ));
i_mem instr_memory(.address(ireg[7]), .data(instr));
// synchro
always @(posedge clk) if(d_op<5) ireg[d_op] <= rdm;
always @(posedge clk)            ireg[7]    <= pcm;
// GPIO
always @(posedge clk) ireg[5] <= gpi;
assign gpo = ireg[4];

endmodule
