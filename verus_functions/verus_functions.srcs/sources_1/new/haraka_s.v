`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2019 20:50:08
// Design Name: 
// Module Name: haraka_s
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

//This is just a frame and basically needs to be reworked entirely.
module haraka_s(

    );
wire [7:0] s[63:0];
wire absorb_done, squeeze1_done;
reg out; //how big does this signal need to be?
//reg [7:0] s[63:0] = {64{8'b0}};  //gives a dimensional error
genvar i;
generate

    for(i = 0; i <64; i = i +1)
            begin
            assign s[i] = 8'b0;
        end
endgenerate
    
haraka_s_absorb h_absorb(
    .s(s),
    .m(in),
    .mlen(in_len),
    .p(0x1F),
    .out(),
    .done(absorb_done)
    );
//possibly use inouts to act like pointers   
haraka_s_squeezeblocks(
    .h(out),
    .nblocks(outlen),
    .s(s),
    .r(32),
    .out(),
    .ready(absorb_done),
    .done(squeeze1_done)
    );
 always @(*) begin
    if(squeeze1_done)
        begin
            out = out + (outlen/32)*32;
            if(outlen % 32) begin
                //change signals of the squeezeblocks imp to use it again
                end
        end
    end
 
    
 
    
endmodule
