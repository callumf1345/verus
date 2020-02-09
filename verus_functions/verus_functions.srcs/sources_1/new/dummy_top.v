`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.11.2019 22:21:01
// Design Name: 
// Module Name: dummy_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module dummy_top(
input clk,
output [7:0] led
    );
 wire [511:0] out;
 reg [511:0] in;
 
    haraka512_perm HARAKA(
    .clk(clk),
    .in(in),
    .perm_out(out)
    );
    
 assign led = out[7:0];
 
 always @ (posedge clk)
	begin
	  in <= in +1'b1;
	   
	       
	   
	end
endmodule
