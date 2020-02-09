`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.11.2019 21:17:45
// Design Name: 
// Module Name: haraka512_perm_mix
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

// in my continuingly annoying way this requires the input string to look identical to the c input NOT be ordered the same
module haraka512_perm_mix(
input [511:0] s_in,
output [511:0] out
    );
wire [127:0] temp;
wire [127:0] s2, s3, s4, s5, s6, s7, s8;
wire  [511:0] s = {s_in[127:0],s_in[255:128],s_in[383:256],s_in[511:384]};
wire [511:0] out_cc; //concate signals

_mm_unpacklo_epi32 LO_1(
.a(s[511 -:128]),
.b(s[383 -:128]),
.out(temp)
);

_mm_unpackhi_epi32 HI_1(
.a(s[511 -:128]),
.b(s[383 -:128]),
.out(s2)
);

_mm_unpacklo_epi32 LO_2(
.a(s[255 -:128]),
.b(s[127 -:128]),
.out(s3)
);

_mm_unpackhi_epi32 HI_2(
.a(s[255 -:128]),
.b(s[127 -:128]),
.out(s4)
);

_mm_unpacklo_epi32 LO_3(
.a(s2),
.b(s4),
.out(s5)
);

_mm_unpackhi_epi32 HI_3(
.a(s2),
.b(s4),
.out(s6)
);

_mm_unpackhi_epi32 HI_4(
.a(s3),
.b(temp),
.out(s7)
);

_mm_unpacklo_epi32 LO_4(
.a(s3),
.b(temp),
.out(s8)
);

assign out_cc = {s6, s8, s7, s5};
assign out = {out_cc[127-:128],out_cc[255-:128],out_cc[383-:128],out_cc[511-:128]}; //this gets the output in a c like format

endmodule
