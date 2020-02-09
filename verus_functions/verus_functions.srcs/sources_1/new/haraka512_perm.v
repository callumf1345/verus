`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 28.09.2019 16:54:44
// Design Name: 
// Module Name: haraka512_perm
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
//void haraka512_perm(unsigned char *out, const unsigned char *in) 
//{
//    int i, j;

//    unsigned char s[64], tmp[16];

//    memcpy(s, in, 16);
//    memcpy(s + 16, in + 16, 16);
//    memcpy(s + 32, in + 32, 16);
//    memcpy(s + 48, in + 48, 16);

//    for (i = 0; i < 5; ++i) {
//        // aes round(s)
//        for (j = 0; j < 2; ++j) {
//            aesenc(s, rc[4*2*i + 4*j]);
//            aesenc(s + 16, rc[4*2*i + 4*j + 1]);
//            aesenc(s + 32, rc[4*2*i + 4*j + 2]);
//            aesenc(s + 48, rc[4*2*i + 4*j + 3]);
//        }

//        // mixing
//        unpacklo32(tmp, s, s + 16);
//        unpackhi32(s, s, s + 16);
//        unpacklo32(s + 16, s + 32, s + 48);
//        unpackhi32(s + 32, s + 32, s + 48);
//        unpacklo32(s + 48, s, s + 32);
//        unpackhi32(s, s, s + 32);
//        unpackhi32(s + 32, s + 16, tmp);
//        unpacklo32(s + 16, s + 16, tmp);
//    }

//    memcpy(out, s, 64);
//}


module haraka512_perm(
input clk,
input [511:0] in,
output [511:0] perm_out
    );
wire [511:0] temp_s;

haraka512_perm_aes AES(
.s_in(in),
.s_final(perm_out) //c format
);



endmodule
