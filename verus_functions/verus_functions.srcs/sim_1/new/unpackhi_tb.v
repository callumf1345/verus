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


module unpackhi_tb();

reg [127:0] a,b;
reg clk = 1'b0;
wire [127:0] out;    
_mm_unpackhi_epi32 UTT(
.clk(clk),
.a(a),
.b(b),
.out(out)
);
integer i =0;
initial begin
  a= {16{8'b10101010}};
  b = {16{8'b11111111}};
  #2 // 2 ns
  for(i =0; i <16; i= i +1)begin //for loop in simulation acts like software ones
    a = a << 8;
    a[7:0] = 8'b10101010 + i;
  end
  //b is the same as before
  #2 
  //a is the same as before
  for(i =0; i <16; i= i +1)begin //for loop in simulation acts like software ones
    b = b << 8;
    b[7:0] = 8'b11110000 + i;
  end
  #2 // 2 ns
  a= 128'b1;
  b = 128'b1010000000000000101; //5 0 5 in decimal
  #2 
  $display("Test Complete");
end

always
    #1 clk = !clk;
    
    
    
endmodule
