`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.09.2019 16:29:21
// Design Name: 
// Module Name: memory_cp_tb
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


module memory_cp_tb(

    );
reg clk = 0;
reg [127:0] input1, input2;
reg selector = 0;   
wire [127:0] out;
  
memcopy memory_cp (
.clk(clk),
.string1(input1),
.string2(input2),
.selector(selector), 
.out(out)
);    

initial begin
  input1 = 128'b0;
  input2 = 128'b00001010000010110000110000001101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000; //abcd 
  selector = 1'b0; //test low mode
  #6 // 2 ns
  input1 = 128'b00001010000010110000110000001101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  input2 = 128'b0; //abcd
  selector = 1'b0; //test low mode
  #6 
  input1 = 128'b00001010000010110000110000001101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
  input2 = 128'b11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111; //abcd
  selector = 1'b0; //test low mode
  #6 // 2 ns
  input1 = 128'b0;
  input2 = 128'b00001010000010110000110000001101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011; //abcd
  selector = 1'b1; //test low mode
  #6 
  $display("Test Complete");
end
    
always 
    #1 clk = !clk;    
    
endmodule
