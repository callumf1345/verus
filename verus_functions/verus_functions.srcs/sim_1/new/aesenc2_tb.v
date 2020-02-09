`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.11.2019 08:21:38
// Design Name: 
// Module Name: aesenc2_tb
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


module aesenc2_tb(

    );
reg clk = 1'b0;
reg start = 1'b0;
reg [511:0] s;
reg [127:0] rk;
wire [127:0] s_out;

aesenc2 UUT(
.clk(clk),
.s(s),
.rk(rk),
.s_out(s_out)
);
initial begin
//s = 512'b0;
//rk = {8'h8a, 8'h2d, 8'h9d, 8'h5c, 8'hc8, 8'h9e, 8'haa, 8'h4a, 8'h72, 8'h55, 8'h6f, 8'hde, 8'ha6, 8'h78, 8'h04, 8'hfa};
//rk = {8'h9d, 8'h7b, 8'h81, 8'h75, 8'hf0, 8'hfe, 8'hc5, 8'hb2, 8'h0a, 8'hc0, 8'h20, 8'he6, 8'h4c, 8'h70, 8'h84, 8'h06};
//#2
//s = {512{1'b1}};
//rk = {8'h79, 8'h4f, 8'h5b, 8'hfd, 8'haf, 8'hbc, 8'hf3, 8'hbb, 8'h08, 8'h4f, 8'h7b, 8'h2e, 8'he6, 8'hea, 8'hd6, 8'h0e};
//#2
//s = {32{16'b1111111100000001}};
//rk = {8'h79, 8'h4f, 8'h5b, 8'hfd, 8'haf, 8'hbc, 8'hf3, 8'hbb, 8'h08, 8'h4f, 8'h7b, 8'h2e, 8'he6, 8'hea, 8'hd6, 8'h0e};
//#2
//s = {8'ha0, 8'ha1, 8'ha2, 8'ha3, 8'ha4, 8'ha5, 8'ha6, 8'ha7, 8'ha8, 8'ha9, 8'hb1, 8'hb2, 8'hb3, 8'hb4, 8'hb5, 8'hb6};
//rk = {8'h79, 8'h4f, 8'h5b, 8'hfd, 8'haf, 8'hbc, 8'hf3, 8'hbb, 8'h08, 8'h4f, 8'h7b, 8'h2e, 8'he6, 8'hea, 8'hd6, 8'h0e};
//#2
//rk = {8'ha1, 8'h9d, 8'hc5, 8'he9, 8'hfd, 8'hbd, 8'hd6, 8'h4a, 8'h88, 8'h82, 8'h28, 8'h02, 8'h03, 8'hcc, 8'h6a, 8'h75};
//further tests for haraka_perm
rk = {8'h9d, 8'h7b, 8'h81, 8'h75, 8'hf0, 8'hfe, 8'hc5, 8'hb2, 8'h0a, 8'hc0, 8'h20, 8'he6, 8'h4c, 8'h70, 8'h84, 8'h06};
//s = 128'h0f0e0d0c0b0a09080706050403020100;
s = 128'h000102030405060708090a0b0c0d0e0f;
end


always
#1 clk = !clk;
endmodule
