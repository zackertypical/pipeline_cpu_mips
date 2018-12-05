`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:43:18 11/24/2018 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
	input	[31:0]IR,
	output [1:0]NPC_OP,
	output [3:0]ALU_OP,
	output [1:0]CMP_OP,
	output EXT_OP,
	output IFU_OP,
	output [1:0]ALU_SRC,
	output MEM_WR,
	output GRF_WD,
	output [1:0]GRF_RW,
	output GRF_WE
    );

	 wire [5:0]OpCode = IR[31:26];
	 wire [5:0]func = IR[5:0];
	 
	 assign ALU_OP = `R_subu?			`ALU_subu:
						  `ori?				`ALU_or:
						  `lui?				`ALU_sll16:
						  (`R_jalr|`jal)?	`ALU_jal:
												 0;
	//写pc类的放到alu的运算当中
						  
	 assign NPC_OP = `beq?				`NPC_br:
						  (`j|`jal)?		`NPC_j:
						  (`R_jalr|`R_jr)?`NPC_jr:
												`NPC_add4;
						  
	 
	 assign EXT_OP = `beq||`sw||`lw;
	 assign IFU_OP = `beq||`R_jr||`R_jalr||`j||`jal;
	 assign CMP_OP = `beq?`CMP_beq:2'b00;
	 
	 

	 assign ALU_SRC = (`ori||`lw||`sw||`lui)?	`ALU_imm:
							(`jal||`R_jalr)?	`ALU_pc8:
												`ALU_reg;
	 
	 assign MEM_WR = `sw;

	 
	 assign GRF_WE = `R_addu || `R_subu || `R_jalr||`jal ||`lw ||`ori||`lui;

	 assign GRF_WD = (`lw)?		`RegS_DM:
								`RegS_ALU;
	//写pc类的放到alu的运算当中							

	 assign GRF_RW = (`R_addu | `R_subu | `R_jalr)?	`RD_RD:
						  (`jal)								 ?	`RD_31:
						  `RD_RT;
	
		


endmodule
