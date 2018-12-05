`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:41:58 11/24/2018 
// Design Name: 
// Module Name:    DM 
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
module DM(
	input [31:0]DataIn,
	input [31:0]MemAddr,
	input [31:0]pc,
	input WrEn,
	input Reset,
	input Clk,
	output [31:0]DataOut
    );
	 reg [31:0]MemData[1023:0];
	 integer i;
	 wire [31:2]ad = MemAddr[31:2];
	 ///////////####
	 initial begin
	 	for(i = 0;i <1024;i = i+1)
			MemData[i] <= 0;
	 end
	 
	 always @(posedge Clk)
	 begin
		if(Reset)
		begin
			for(i = 0;i <1024;i = i+1)
				MemData[i] <= 0;
		end
		else
			if(WrEn)
			begin
				MemData[ad]<= DataIn;
				$display("%d@%h: *%h <= %h",$time, pc,MemAddr,DataIn);
			
			end
		
	 
	 end
	 assign DataOut = MemData[ad];


endmodule
