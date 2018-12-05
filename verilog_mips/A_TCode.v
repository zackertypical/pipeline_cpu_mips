`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:37:58 11/25/2018 
// Design Name: 
// Module Name:    A_TCode 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`include "head.v"
//Ӧ����ÿ������code
//����D_IR�����Tuse��Tnew��A3
module A_TCode(
	input [31:0]IR,
	//input able,
	output Tuse_RS0,Tuse_RS1,
	output Tuse_RT0,Tuse_RT1,
	output Tuse_RT2,
	output [1:0]Tnew_D,
	output [4:0] A3
    );
	 
	wire [5:0]OpCode = IR[31:26];
	wire [5:0]func = IR[5:0];
	
	//A3单独解码，写寄存器的编号
	 assign A3 = (`jal)?5'd31:
					 (`ori|`lw|`lui)?`A2:
					 (`R_addu|`R_subu|`R_jalr)?`A3:
					 `A3;
						
	//进入D级的tuse
	assign Tuse_RS0 = `beq | `R_jr |`R_jalr;
	assign Tuse_RS1 = `R_addu|`R_subu|`ori|`lw|`sw;
	 
	 
	assign Tuse_RT0 = `beq;
	assign Tuse_RT1 = `R_addu|`R_subu;
	assign Tuse_RT2 = `sw;
	 
	//D级的Tnew
	assign Tnew_D = (`lw)?`T_DM:
						 (`R_addu|`R_subu|`ori|`lui)?`T_ALU:
						 `T_PC;
endmodule

