`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2019 22:26:52
// Design Name: 
// Module Name: haraka512_perm_aes_tb
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


module haraka512_perm_aes_tb();
reg clk = 1'b0;
reg [511:0] s;
wire [511:0] s_final; 
wire [511:0] s_final2; 
wire [511:0] s_ordered = {s[127-:128],s[255-:128],s[383-:128],s[511-:128]}; //this just allows you to send in c copied inputs and reorders them for you 

haraka512_perm_aes UUT(
.clk(clk),
.s_in(s_ordered),
.s_final(s_final)
);

haraka512_perm_aes_2clk UUT2(
.clk(clk),
.s_input(s_ordered),
.s_final(s_final2)
);



initial begin
//these testbenches will probably not work as I've since added the mix step inside AES
s = 512'b0;
//#2
//s= {64{8'b1}};
//#2
//s = 512'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f;
//s = 512'h303132333435363738393a3b3c3d3e3f202122232425262728292a2b2c2d2e2f101112131415161718191a1b1c1d1e1f000102030405060708090a0b0c0d0e0f;
//the above signal becomes this after s_ordered changes it.
end

always
#1 clk = !clk;
endmodule