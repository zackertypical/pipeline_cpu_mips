`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:01:30 11/25/2018 
// Design Name: 
// Module Name:    MainCTR 
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
module MainCTR(
	input [31:0]D_IR,
	input clk,
	input reset,
	//���ܿ����ź�
	output [1:0]D_NPC_OP,
	output [3:0]E_ALU_OP,
	output [1:0]D_CMP_OP,
	output D_EXT_OP,
	output D_IFU_OP,
	output [1:0]E_ALU_SRC,
	output M_MEM_WR,
	output M_GRF_WD,//********************
	output [1:0]W_GRF_RW,
	output W_GRF_WE,
	output [4:0]W_A3,
	
	//mux forwardת���ź�
	output [1:0]D_SEL_MF_RS,
	output [1:0]D_SEL_MF_RT,
	output [1:0]E_SEL_MF_RS,
	output [1:0]E_SEL_MF_RT,
	//output [2:0]E_SEL_MF_RD,
	output M_SEL_MF_RT,
	//��ͣ�ź�
	output PC_en,
	output E_clr,
	output D_en
	
    );
	 
	 wire [31:0]	E_IR,M_IR,W_IR;
	 wire [4:0]		D_A3,E_A3,M_A3; 
	 wire 			E_GRF_WE,M_GRF_WE;
	 wire 			en,stall;
	 wire [1:0]		Tnew_D,Tnew_E,Tnew_M,Tnew_W;
	 wire Tuse_RS0,Tuse_RS1,Tuse_RT0,Tuse_RT1,Tuse_RT2;
	 
	 assign en = 1;
	  
//A_TCODE
	A_TCode AT_code(
	D_IR,
	Tuse_RS0,Tuse_RS1,
	Tuse_RT0,Tuse_RT1,
	Tuse_RT2,
	Tnew_D,
	D_A3
    );
	 
	 
//Tnew�Ĵ���
//从d级传入的Tnew
	T_REG E_TNEW(Tnew_D,Tnew_E,clk,(reset|E_clr),en);
	T_REG M_TNEW(Tnew_E,Tnew_M,clk,reset,en);
	T_REG W_TNEW(Tnew_M,Tnew_W,clk,reset,en);

//A3�Ĵ���
	 REG #(5)A3_E(D_A3,E_A3,clk,(reset|E_clr),en);
	 REG #(5)A3_M(E_A3,M_A3,clk,reset,en);
	 REG #(5)A3_W(M_A3,W_A3,clk,reset,en);
	 
//��ˮ�ߴ洢��ָ��Ĵ���
	 REG #(32)IR_E(D_IR,E_IR,clk,(reset|E_clr),en);
	 REG #(32)IR_M(E_IR,M_IR,clk,reset,en);
	 REG #(32)IR_W(M_IR,W_IR,clk,reset,en);

//MuxFORWARDת���ź�
	assign D_SEL_MF_RS = ((`D_A1 == M_A3) & (Tnew_M==0) & M_GRF_WE & (`D_A1!=0))?2:
								((`D_A1 == W_A3) & (Tnew_W==0) & W_GRF_WE & (`D_A1!=0))?1:
																						 0;
																						
	assign D_SEL_MF_RT = ((`D_A2 == M_A3) & (Tnew_M==0) & M_GRF_WE & (`D_A2!=0)) ? 2:
								((`D_A2 == W_A3) & (Tnew_W==0) & W_GRF_WE & (`D_A2!=0)) ? 1:
																						   0;
																							
	assign E_SEL_MF_RS = ((`E_A1 == M_A3) & (Tnew_M==0) & M_GRF_WE & (`E_A1!=0)) ? 2:
								((`E_A1 == W_A3) & (Tnew_W==0) & W_GRF_WE & (`E_A1!=0)) ? 1:
																							0;
	
	assign E_SEL_MF_RT = ((`E_A2 == M_A3) & (Tnew_M==0) & M_GRF_WE & (`E_A2!=0)) ? 2:
								((`E_A2 == W_A3) & (Tnew_W==0) & W_GRF_WE & (`E_A2!=0)) ? 1:
																							0;
																							
	assign M_SEL_MF_RT = ((`M_A2 == W_A3) & (Tnew_W==0) & W_GRF_WE & (`M_A2!=0)) ? 1:
																							0;	
																							

//��������Ĺ��ܿ����ź�
	Controller CTR_D(
	.IR(D_IR),
	.NPC_OP(D_NPC_OP),
	.CMP_OP(D_CMP_OP),
	.EXT_OP(D_EXT_OP),
	.IFU_OP(D_IFU_OP)
    );
	 
	Controller CTR_E(
	.IR(E_IR),
	.ALU_OP(E_ALU_OP),
	.ALU_SRC(E_ALU_SRC),
	.GRF_WE(E_GRF_WE)
    );
	 
	Controller CTR_M(
	.IR(M_IR),
	.MEM_WR(M_MEM_WR),
	.GRF_WE(M_GRF_WE),
	.GRF_WD(M_GRF_WD)
    );
	 
	Controller CTR_W(
	.IR(W_IR),
	.GRF_RW(W_GRF_RW),
	.GRF_WE(W_GRF_WE)
    );

	 
	STALL_SEL stall_sel(
	D_IR,
	Tuse_RS0,Tuse_RS1,Tuse_RT0,Tuse_RT1,Tuse_RT2,
	Tnew_E,Tnew_M,
	E_A3,M_A3,
	//��E����M����дʹ���ź�
	E_GRF_WE,M_GRF_WE,
	stall
    ); 	

	STALLCTR stall_ctr(
	stall,
	PC_en,E_clr,D_en
    );	
	 	 
 

endmodule
