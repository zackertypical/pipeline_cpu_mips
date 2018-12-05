`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:26:45 11/24/2018 
// Design Name: 
// Module Name:    head 
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
//ALU
`define ALU_addu 4'd0
`define ALU_subu 4'd1
`define ALU_and 4'd2
`define ALU_or 4'd3
`define ALU_sll16 4'd4
`define ALU_jal 4'd5

`define ALU_reg 2'b00
`define ALU_imm 2'b01
`define ALU_pc8 2'b10


//IFU
`define NPC_add4 2'b00
`define NPC_br 2'b01
`define NPC_j 2'b10
`define NPC_jr 2'b11

`define RD_RD	  	2'b00
`define RD_RT	  	2'b01
`define RD_31 		2'b10

`define RegS_ALU  0
`define RegS_DM  	1


//EXT
`define EXT_sign		1
`define EXT_unsign 	0


//TNEW
//DM.!!!initial with 3 一开始tnew寄存器就会自减
`define T_DM 2'b11
//ALU initial with 2
`define T_ALU 2'b10
`define T_PC 2'b00


//CMP
`define	CMP_beq 2'b01

//A1,A2,A3
`define A1 IR[25:21]
`define A2 IR[20:16]
`define A3 IR[15:11]

`define D_A1 D_IR[25:21]
`define D_A2 D_IR[20:16]
`define D_A3 D_IR[15:11]


`define E_A1 E_IR[25:21]
`define E_A2 E_IR[20:16]
`define E_A3 E_IR[15:11]
//rd

`define M_A1 M_IR[25:21]
`define M_A2 M_IR[20:16]
`define M_A3 M_IR[15:11]



//OpCode
`define R_addu	(OpCode == 6'b000000 && func == 6'b100001)
`define R_subu	(OpCode == 6'b000000 && func == 6'b100011)
`define R_jr 	(OpCode == 6'b000000 && func == 6'b001000)
`define R_jalr (OpCode == 6'b000000 && func == 6'b001001)
`define ori		(OpCode == 6'b001101)
`define lw		(OpCode == 6'b100011)
`define sw		(OpCode == 6'b101011)
`define beq		(OpCode == 6'b000100)
`define lui		(OpCode == 6'b001111)
`define j		(OpCode == 6'b000010)
`define jal		(OpCode == 6'b000011)
`define nop		(OpCode == 6'b000000 && func == 6'b000000)

