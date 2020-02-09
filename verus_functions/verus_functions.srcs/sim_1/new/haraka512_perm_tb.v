`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.09.2019 19:55:11
// Design Name: 
// Module Name: haraka512_perm_tb
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


module haraka512_perm_tb(

    );
reg clk = 1'b0;
reg [511:0] in;
wire [511:0] out;
wire [511:0] in_ordered = {in[127-:128],in[255-:128],in[383-:128],in[511-:128]};
haraka512_perm UUT(
.clk(clk),
.in(in_ordered),
.perm_out(out)
);
initial begin
//in = 64'b1111;
//#2
in= {64{8'b1}};
//#2
//in = 512'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f;

end
always
 #1 clk = !clk;    
endmodule
