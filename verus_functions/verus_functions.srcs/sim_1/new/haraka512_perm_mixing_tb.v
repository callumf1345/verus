`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2019 21:15:31
// Design Name: 
// Module Name: haraka512_perm_mixing_tb
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


module haraka512_perm_mixing_tb(

    );
reg [511:0] s;
wire [511:0] out;
haraka512_perm_mix UUT(
.s(s),
.out(out)  
);

initial begin
s = 512'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d3e3f;
#2
s = 512'hff01020304ff060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132333435363738393a3b3c3d1309;
end
endmodule
