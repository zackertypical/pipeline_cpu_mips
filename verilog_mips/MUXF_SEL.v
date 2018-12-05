`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:13:32 11/25/2018 
// Design Name: 
// Module Name:    MUXF_SEL 
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

module MUXF_SEL(
	//当前指令？
	input [31:0]D_IR,E_IR,M_IR,
	//转发级别，写寄存器，由于每条指令的A3是不同的，所以要单独写出来,由T_code决定
	input [4:0]E_A3,M_A3,W_A3,
	input [1:0]E_Tnew,M_Tnew,
	input E_WE,M_WE,W_WE,
	output [2:0]D_SEL_MF_RS,
	output [2:0]D_SEL_MF_RT,
	output [2:0]E_SEL_MF_RS,
	output [2:0]E_SEL_MF_RT,
	//output [2:0]E_SEL_MF_RD,
	output [2:0]M_SEL_MF_RT
    );
	 
	 
//转到D的A1
	assign D_SEL_MF_RS = (M_A3 == `D_A1) && (M_Tnew == 0) && (M_WE) ? 5:
								(M_A3 == `D_A1) && (M_Tnew == 0) && (M_WE) ? 4:
								(W_A3 == `D_A1) && 						(W_WE) ? 3:
								(W_A3 == `D_A1) && 						(W_WE) ? 2:
								(W_A3 == `D_A1) && 						(W_WE) ? 1:
																							0;
	
	assign D_SEL_MF_RT = (M_A3 == `D_A2) && (M_Tnew == 0) && (M_WE) ? 5:
								(M_A3 == `D_A2) && (M_Tnew == 0) && (M_WE) ? 4:
								(W_A3 == `D_A2) && 						(W_WE) ? 3:
								(W_A3 == `D_A2) && 						(W_WE) ? 2:
								(W_A3 == `D_A2) && 						(W_WE) ? 1:
																							0;
																							
	assign E_SEL_MF_RS = (M_A3 == `E_A1) && (M_Tnew == 0) && (M_WE) ? 5:
								(M_A3 == `E_A1) && (M_Tnew == 0) && (M_WE) ? 4:
								(W_A3 == `E_A1) && 						(W_WE) ? 3:
								(W_A3 == `E_A1) && 						(W_WE) ? 2:
								(W_A3 == `E_A1) && 						(W_WE) ? 1:
																							0;
	
	assign E_SEL_MF_RT = (M_A3 == `E_A2) && (M_Tnew == 0) && (M_WE) ? 5:
								(M_A3 == `E_A2) && (M_Tnew == 0) && (M_WE) ? 4:
								(W_A3 == `E_A2) && 						(W_WE) ? 3:
								(W_A3 == `E_A2) && 						(W_WE) ? 2:
								(W_A3 == `E_A2) && 						(W_WE) ? 1:
																							0;																							

	assign M_SEL_MF_RT = (W_A3 == `M_A2) && 						(W_WE) ? 3:
								(W_A3 == `M_A2) && 						(W_WE) ? 2:
								(W_A3 == `M_A2) && 						(W_WE) ? 1:
																							0;
endmodule