`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2019 15:50:58
// Design Name: 
// Module Name: _mm_unpacklo_epi32
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


module _mm_unpacklo_epi32(
input [127:0] a, //don't think they need to be this big but both can take S which is 64 bits so to be on the safe side we are.
input [127:0] b,
output [127:0] out
);

assign out[127:96] = a[127:96];//indexes can probably be shifted right down in all cases
assign out[95:64] = b[127:96]; // if we don't use all the data why pass it around?
assign out[63:32] = a[95:64];
assign out[31:0] = b[95:64];
   
endmodule

module _mm_unpackhi_epi32(
input [127:0] a, //don't think they need to be this big but both can take S which is 64 bytes so to be on the safe side we are.
input [127:0] b, //passing in 16 bytes but lo or hi on their own only address 8 bytes
output [127:0] out
);

assign out[127:96] = a[63:32];
assign out[95:64] = b[63:32];
assign out[63:32] = a[31:0];
assign out[31:0] = b[31:0];
   
endmodule



//note, this normally works with char arrays in c but here we have converted it to pure bits
// for example tmp[16] is 16*8=128 bits
module memcopy   //no of bytes to copy
(
    input clk,
    input [127:0] string1,
    input [127:0] string2,
    input selector,
    //no of bytes to copy restricted to 4 or 16 here, so boolean
    output reg [127:0] out
);

always @(posedge clk)
    begin   
        case (selector)
            1'b0 : begin
                    out[127:96] <= string2[127:96];
                    out[95:0] <= string1[95:0];
                    end
            1'b1 :  out <= string2; //as we're copying 16 char and tmp is onyl 16 char anyway so basically copying it all 
            default : begin
                $display("Error selector default triggered OR 8 BYTES"); //getting 3 phases out of 1 bit, sloppy but works?
                out[127:64] <= string2[127:64]; //copy 8 bytes
                out[63:0] <= string1[63:0];
                end
           endcase
    end

endmodule
//to reduce latency you could mess the process of 5 memcopys together and so calculate them all together?
//given we only need specific types/sequences of memcopy not general. 

