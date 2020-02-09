`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2019 15:43:27
// Design Name: 
// Module Name: _mm_aesenc_si129_tb
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


module _mm_aesenc_si129_tb();

reg clk = 0;
aesenc UUT (
.clk(clk),
.s(),
.rk()

);    

 always
    #1 clk = !clk;
    
endmodule
