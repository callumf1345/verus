`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.09.2019 10:45:43
// Design Name: 
// Module Name: aesenc_tb
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


module aesenc_tb();
    
reg clk = 1'b0;
reg start = 1'b0;
reg [511:0] s;
reg [127:0] rk;
wire [511:0] s_out;

aesenc UUT(
.clk(clk),
.s(s),
.rk(rk),
.s_out(s_out)
);

initial begin
s = 0;
//s[7:0] = 8'd255;
//s[15:8] = 8'd254;
//s[23:16] = 8'd127;
rk = {8'h9d, 8'h7b, 8'h81, 8'h75, 8'hf0, 8'hfe, 8'hc5, 8'hb2, 8'h0a, 8'hc0, 8'h20, 8'he6, 8'h4c, 8'h70, 8'h84, 8'h06};
//#2
//s[7:0] = 8'd255;
//s[15:8] = 8'd8;
//s[23:16] = 8'd154;
end
    
always
    #1 clk = !clk;
    
endmodule
