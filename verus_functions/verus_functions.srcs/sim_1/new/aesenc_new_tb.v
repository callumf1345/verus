`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.12.2019 18:33:40
// Design Name: 
// Module Name: aesenc_new_tb
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


module aesenc_new_tb(

    );
reg clk = 1'b0;
reg [511:0] s;
reg [127:0] rk;
wire [127:0] s_out;
aesenc_new UUT(
.clk(clk),
.s_in(s),
.rk(rk),
.s_out(s_out)

);
initial begin
s = {{128{1'b1}},384'b0}; //s1
rk = {128{1'b1}};
#2
s = {{4{32'hff000000}},384'b0}; //s2
rk = {128{1'b1}};
#2
//s = {128'h000102030405060708090a0b0c0d0e0f, 384'b0}; //s3
//rk = {128{1'b1}};
//#2
//s = {128'h000102030405060708090a0b0c0d0e0f, 384'b0};
s = {128'h03020100070605040b0a09080f0e0d0c, 384'b0}; 
rk = 128'h75817b9db2c5fef0e620c00a0684704c;

//rk = {8'h9d, 8'h7b, 8'h81, 8'h75, 8'hf0, 8'hfe, 8'hc5, 8'hb2, 8'h0a, 8'hc0, 8'h20, 8'he6, 8'h4c, 8'h70, 8'h84, 8'h06};


end

always
#1 clk = !clk;
endmodule
