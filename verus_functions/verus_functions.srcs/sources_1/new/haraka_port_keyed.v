`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.09.2019 14:12:49
// Design Name: 
// Module Name: haraka_port_keyed
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
//void haraka512_port_keyed(unsigned char *out, const unsigned char *in, const u128 *rc)
//{
//    int i;

//    unsigned char buf[64];

//    haraka512_perm_keyed(buf, in, rc);
//    /* Feed-forward */
//    for (i = 0; i < 64; i++) {
//        buf[i] = buf[i] ^ in[i];
//    }

//    /* Truncated */
//    memcpy(out,      buf + 8, 8);
//    memcpy(out + 8,  buf + 24, 8);
//    memcpy(out + 16, buf + 32, 8);
//    memcpy(out + 24, buf + 48, 8);
//}


module haraka_port_keyed( //clock lag will be important when trying to determine which nonce relates to which hash
input clk,
input in,
input rc,
output [255:0] out
    );
wire  [511:0] buff_0, buff_1;
    
    haraka512_perm_keyed h_permk( //? clk delay
    .clk(clk),
    .in(in),
    .rc(rc), //make local if not needed elsewhere/not edited 
    .out(buff_0)
    );
    
    feedforward feed_f( //1 clk delay
    .clk(clk),
    .buffer(buff_0),
    .out(buff_1)
    );
    
    truncate trunc( //1 clk delay
    .clk(clk),
    .buffer(buff_1[447:64]), //not all the buffer is used so don't bother sending it all.
    .out(out)
    );
endmodule

module truncate( //copying 32bits but input signal is a chunk of 8-56bytes so 48 bytes
input clk, //does this even need a clock?
input [383:0] buffer,
output [255:0] out
);


assign out[255:192] = buffer[383:320]; //ignore the first 8 bytes as we never use it so don't send it
assign out[191:128] = buffer[255:192];
assign out[127:64] = buffer[191:128];
assign out[63:0] = buffer[63:0];


endmodule

module feedforward(
    input clk,
    input [511:0] buffer, //index via bytes as only systemverilog allows packed dimensions I believe 
    input [511:0] in, //check size?
    output [511:0] buff_out //might be easier to handle as a single large register as thenw e can pass straight away to truncate in one go?
);

genvar i;
generate 
    for(i =512; i+1 >0; i = i -8) begin
            assign buff_out[i-: 8] = buffer[i-: 8] ^ in[i-:8]; //if we need space we can fold the design over several clock cycles?
          end
endgenerate
endmodule


