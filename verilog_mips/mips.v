`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:02:43 11/25/2018 
// Design Name: 
// Module Name:    mips 
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
module mips(
    input clk,
    input reset
    );
	 
	 //���ܲ��������ź�
	 //D
	wire [1:0]D_NPC_OP,D_CMP_OP;
	wire D_EXT_OP,D_IFU_OP;
	//E
	wire [3:0]E_ALU_OP;
	wire [1:0]E_ALU_SRC;
	//M
	wire M_MEM_WR,M_GRF_WD;
	//W
	wire [1:0]W_GRF_RW;
	wire W_GRF_WE;
	wire [4:0]W_A3;
	
	//mux forwardת���ź�
	wire [1:0]D_SEL_MF_RS,D_SEL_MF_RT,E_SEL_MF_RS,E_SEL_MF_RT;
	wire M_SEL_MF_RT;
	
	//��ͣ�ź�
	wire PC_en,E_clr,D_en;
	wire en = 1;
	
	//ÿ�������ź�
	//F
	wire [31:0]F_PC,F_PC4,F_PC8,F_IR,F_PC_IN;
	//D
	wire [31:0]D_IR,D_PC,D_PC4,D_PC8,D_EXTOUT,D_NPC,D_GRFA,D_GRFB,D_RS,D_RT;
	wire [4:0]D_A1,D_A2;
	assign D_A1 = D_IR[25:21];
	assign D_A2 = D_IR[20:16];
	wire D_CMPOut;
	//E
	wire [31:0]E_IR,E_PC,E_PC8,E_EXTOUT,E_RS,E_RT;
	wire [31:0]E_ALUA,E_ALUB0,E_ALUB,E_ALUOUT;
	//M
	wire [31:0]M_IR,M_PC,M_ALUOUT,M_RT,M_DMDATA,M_DMOut,M_REGW;
	//W
	wire [31:0]W_IR,W_REGW,W_PC;

	 
	MainCTR mainctr(
	D_IR,
	clk,
	reset,
	//���ܿ����ź�
	D_NPC_OP,
	E_ALU_OP,
	D_CMP_OP,
	D_EXT_OP,
	D_IFU_OP,
	E_ALU_SRC,
	M_MEM_WR,
	M_GRF_WD,//********************
	W_GRF_RW,
	W_GRF_WE,
	W_A3,
	
	//mux forwardת���ź�
	D_SEL_MF_RS,
	D_SEL_MF_RT,
	E_SEL_MF_RS,
	E_SEL_MF_RT,
	M_SEL_MF_RT,
	//��ͣ�ź�
	PC_en,E_clr,D_en
    );

/////////IF ȡָ��
//0��add4
	mux2 #(32) F_MUX_PC(D_IFU_OP,F_PC4,D_NPC,F_PC_IN);
	PC pc(F_PC_IN,F_PC,PC_en,clk,reset);
	ADD4 add4(F_PC,F_PC4,F_PC8);
	IM im(F_PC,F_IR);
	 
/////////D�Ĵ���
	REG #(32) REG_IR_D(F_IR,D_IR,clk,reset,D_en);
	REG #(32) REG_PC_D(F_PC,D_PC,clk,reset,D_en);
	REG #(32) REG_PC4_D(F_PC4,D_PC4,clk,reset,D_en);
	REG #(32) REG_PC8_D(F_PC8,D_PC8,clk,reset,D_en);
	
	 
/////////Decode
	mux3#(32) D_MUX_MF_RS(D_SEL_MF_RS,D_GRFA,W_REGW,M_ALUOUT,D_RS);
	mux3#(32) D_MUX_MF_RT(D_SEL_MF_RT,D_GRFB,W_REGW,M_ALUOUT,D_RT);
	
	GRF grf(D_A1,D_A2,W_A3,W_REGW,clk,reset,W_GRF_WE,W_PC,D_GRFA,D_GRFB);
	EXT ext(D_IR[15:0],D_EXT_OP,D_EXTOUT);
	 
	CMP cmp(D_CMP_OP,D_RS,D_RT,D_CMPOut);
	//����npc��ֵ��ת�������ֵ����jr��ָ�� 
	NPC npc(
	.PC4(D_PC4),
	.PC_B(D_EXTOUT),
	.PC_J(D_IR),
	.PC_JR(D_RS),
	.NPCOp(D_NPC_OP),
	.able(D_CMPOut),
	.NPCOut(D_NPC)
    );
	 
/////////E�Ĵ���
	REG #(32) REG_IR_E(D_IR,E_IR,clk,E_clr|reset,en);
	REG #(32) REG_PC_E(D_PC,E_PC,clk,E_clr|reset,en);
	REG #(32) REG_PC8_E(D_PC8,E_PC8,clk,E_clr|reset,en);
	
	REG #(32) REG_RS_E(D_RS,E_RS,clk,E_clr|reset,en);
	REG #(32) REG_RT_E(D_RT,E_RT,clk,E_clr|reset,en);
	REG #(32) REG_EXT_E(D_EXTOUT,E_EXTOUT,clk,E_clr|reset,en);
	
	
/////////EXCECUTE:ALU
	mux3#(32) E_MUX_MF_RS(E_SEL_MF_RS,E_RS,W_REGW,M_ALUOUT,E_ALUA);
	mux3#(32) E_MUX_MF_RT(E_SEL_MF_RT,E_RT,W_REGW,M_ALUOUT,E_ALUB0);
	//对alu数据进行选择，可能来自pc8、rt、extout，只有rt是寄存器读出来的
	mux3#(32) E_MUX_ALU(E_ALU_SRC,E_ALUB0,E_EXTOUT,E_PC8,E_ALUB);
	ALU alu(E_ALUA,E_ALUB,E_ALU_OP,E_ALUOUT);
 
/////////M级寄存器
	REG #(32) REG_IR_M(E_IR,M_IR,clk,reset,en);
	REG #(32) REG_PC_M(E_PC,M_PC,clk,reset,en);
	REG #(32) REG_ALUOUT_M(E_ALUOUT,M_ALUOUT,clk,reset,en);
	REG #(32) REG_RT_M(E_ALUB0,M_RT,clk,reset,en);
	
/////////DM
	//mux forward，对M_DMDATA进行更新
	mux2#(32) M_MUX_MF_RT(M_SEL_MF_RT,M_RT,W_REGW,M_DMDATA);
	
	DM dm(
	.DataIn(M_DMDATA),
	.MemAddr(M_ALUOUT),
	.pc(M_PC),
	.WrEn(M_MEM_WR),
	.Reset(reset),
	.Clk(clk),
	.DataOut(M_DMOut)
    );
	//对写入寄存器的数据进行选择
	mux2#(32) M_MUX_DM(M_GRF_WD,M_ALUOUT,M_DMOut,M_REGW);
	 
/////////W级寄存器
	REG #(32) REG_IR_W(M_IR,W_IR,clk,reset,en);
	REG #(32) REG_PC_W(M_PC,W_PC,clk,reset,en);
	REG #(32) REG_REGW_W(M_REGW,W_REGW,clk,reset,en);

endmodule
