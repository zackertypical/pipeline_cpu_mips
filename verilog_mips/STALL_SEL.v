`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:11:49 11/25/2018 
// Design Name: 
// Module Name:    STALL_SEL 
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
module STALL_SEL(
	input [31:0]IR,
	input Tuse_RS0,Tuse_RS1,Tuse_RT0,Tuse_RT1,Tuse_RT2,
	input [1:0]Tnew_E,Tnew_M,
	input [4:0]A3_E,A3_M,
	//��E����M����дʹ���ź�
	input W_E,W_M,
	output stall
    );
	//RS:A1
	//RT:A2
	//写入的寄存器编号：A3
	//  wire Stall_RS0_E1 = Tuse_RS0 & (Tnew_E == 2'b01) & (`A1 == A3_E) & W_E & (A3_E != 0);
	//  wire Stall_RS0_E2 = Tuse_RS0 & (Tnew_E == 2'b10) & (`A1 == A3_E) & W_E & (A3_E != 0);
	//  wire Stall_RS0_M1 = Tuse_RS0 & (Tnew_M == 2'b01) & (`A1 == A3_M) & W_M & (A3_M != 0);
	//  wire Stall_RS1_E2 = Tuse_RS1 & (Tnew_E == 2'b10) & (`A1 == A3_E) & W_E & (A3_E != 0);
	//  wire Stall_RS = Stall_RS0_E1 | Stall_RS0_E2 |Stall_RS0_M1 |Stall_RS1_E2;
	 //RT  A2
	//  wire Stall_RT0_E1 = Tuse_RT0 & (Tnew_E == 2'b01) & (`A2 == A3_E) & W_E & (A3_E != 0);
	//  wire Stall_RT0_E2 = Tuse_RT0 & (Tnew_E == 2'b10) & (`A2 == A3_E) & W_E & (A3_E != 0);
	//  wire Stall_RT0_M1 = Tuse_RT0 & (Tnew_M == 2'b01) & (`A2 == A3_M) & W_M & (A3_M != 0);
	//  wire Stall_RT1_E2 = Tuse_RT1 & (Tnew_E == 2'b10) & (`A2 == A3_E) & W_E & (A3_E != 0);
	//  wire Stall_RT = Stall_RT0_E1|Stall_RT0_E2|Stall_RT0_M1|Stall_RT1_E2;
 	//考虑写入的寄存器是0，则不能读入数据
	 //E级暂停,RS0 tuse = 0 && E1 tnew = 1，要读的寄存器是rs，BEQ,JR,JALR的情况
	 //Tnew_E>0即暂停
	wire Stall_RS0_E = Tuse_RS0 & (Tnew_E > 0) & (`A1 == A3_E) & W_E & (A3_E != 0);
	wire Stall_RS0_M = Tuse_RS0 & (Tnew_M > 0) & (`A1 == A3_M) & W_M & (A3_M != 0);
	wire Stall_RS1_E = Tuse_RS1 & (Tnew_E > 1) & (`A1 == A3_E) & W_E & (A3_E != 0);
	wire Stall_RS = Stall_RS0_E | Stall_RS0_M |Stall_RS1_E;


	wire Stall_RT0_E = Tuse_RT0 & (Tnew_E > 0) & (`A2 == A3_E) & W_E & (A3_E != 0);
	wire Stall_RT1_E = Tuse_RT1 & (Tnew_E > 1) & (`A2 == A3_E) & W_E & (A3_E != 0);
	wire Stall_RT0_M = Tuse_RT0 & (Tnew_M > 0) & (`A2 == A3_M) & W_M & (A3_M != 0);
	wire Stall_RT = Stall_RT0_E|Stall_RT1_E|Stall_RT0_M;

	assign stall = Stall_RS|Stall_RT;

endmodule
