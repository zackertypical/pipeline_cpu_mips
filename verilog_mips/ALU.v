`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:39:20 11/24/2018 
// Design Name: 
// Module Name:    ALU 
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

module ALU(
	input signed [31:0]A,
	input signed [31:0]B,
	input [3:0]ALUCtr,
	output signed[31:0]Result
    );
   assign Result = 
		(ALUCtr == `ALU_addu)?	(A+B):
		(ALUCtr == `ALU_subu)?	(A-B):
		(ALUCtr == `ALU_and)?	(A&B):
		(ALUCtr == `ALU_or)?		(A|B):
		(ALUCtr == `ALU_sll16)?	(B<<16):
		(ALUCtr == `ALU_jal)?	B:
		0;
		//JAL将数据从B输入再输出，相当于从ALU产生数据

endmodule
