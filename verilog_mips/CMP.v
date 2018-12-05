`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:28:34 11/24/2018 
// Design Name: 
// Module Name:    CMP 
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
module CMP(
	input [1:0]CMPOp,
	input signed [31:0]CMPA,
	input signed [31:0]CMPB,
	output CMPOut
    );
	 
	 assign CMPOut = (CMPOp == `CMP_beq)?(CMPA == CMPB):
							0;
	
endmodule
