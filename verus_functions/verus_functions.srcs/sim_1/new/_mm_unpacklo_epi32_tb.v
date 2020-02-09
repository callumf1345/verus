`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2019 15:51:16
// Design Name: 
// Module Name: _mm_unpacklo_epi32_tb
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


module _mm_unpacklo_or_hi_epi32_tb(

    );
reg select;
reg [511:0] t,a,b;
reg clk = 1'b0;
reg [127:0] out;    
_mm_unpacklo_or_hi_epi32 UTT(
.clk(clk),
.t(t),
.a(a),
.b(b),
.lohi(select), 
.out(out)
);

initial begin
  t = 512'b0;
  a= 512'b0;
  b = 512'b0;
  select = 1'b0; //test low mode
  #2 // 2 ns
  t = 512'b1;
  a= 512'b1;
  b = 512'b1;
  select = 1'b0; //test low mode
  #2 
  t = 512'b0;
  a= 512'b0;
  b = 512'b0;
  select = 1'b1; //test hi mode
  #2 // 2 ns
  t = 512'b1;
  a= 512'b1;
  b = 512'b1;
  select = 1'b1;
  #2 
  $display("Test Complete");
end

always
    #1 clk = !clk;
    
    
    
endmodule
