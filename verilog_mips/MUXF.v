`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:04:35 11/25/2018 
// Design Name: 
// Module Name:    MUXF 
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
module MUXF(
	input [31:0]D_IR,E_IR,M_IR,
	input [4:0]E_A3,M_A3,W_A3,
	input [1:0]E_Tnew,M_Tnew,W_Tnew,
	output [2:0]D_SEL_MF_RS,
	output [2:0]D_SEL_MF_RT,
	output [2:0]E_SEL_MF_RS,
	output [2:0]E_SEL_MF_RT,
	output [2:0]E_SEL_MF_RD,
	output [2:0]M_SEL_MF_RT
    );


endmodule
