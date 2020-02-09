`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2019 17:27:45
// Design Name: 
// Module Name: haraka512_perm_aes
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


module haraka512_perm_aes_2clk(
input clk,
input [511:0] s_in ,
output [511:0] s_final
    );
wire [511:0] s[15:0]; //squash our i and j dimensions into one to allow for easy index linking
//reg [511:0] s;


parameter rc = {8'h9d, 8'h7b, 8'h81, 8'h75, 8'hf0, 8'hfe, 8'hc5, 8'hb2, 8'h0a, 8'hc0, 8'h20, 8'he6, 8'h4c, 8'h70, 8'h84, 8'h06,
    8'h17, 8'hf7, 8'h08, 8'h2f, 8'ha4, 8'h6b, 8'h0f, 8'h64, 8'h6b, 8'ha0, 8'hf3, 8'h88, 8'he1, 8'hb4, 8'h66, 8'h8b,
    8'h14, 8'h91, 8'h02, 8'h9f, 8'h60, 8'h9d, 8'h02, 8'hcf, 8'h98, 8'h84, 8'hf2, 8'h53, 8'h2d, 8'hde, 8'h02, 8'h34,
    8'h79, 8'h4f, 8'h5b, 8'hfd, 8'haf, 8'hbc, 8'hf3, 8'hbb, 8'h08, 8'h4f, 8'h7b, 8'h2e, 8'he6, 8'hea, 8'hd6, 8'h0e,
    8'h44, 8'h70, 8'h39, 8'hbe, 8'h1c, 8'hcd, 8'hee, 8'h79, 8'h8b, 8'h44, 8'h72, 8'h48, 8'hcb, 8'hb0, 8'hcf, 8'hcb,
    8'h7b, 8'h05, 8'h8a, 8'h2b, 8'hed, 8'h35, 8'h53, 8'h8d, 8'hb7, 8'h32, 8'h90, 8'h6e, 8'hee, 8'hcd, 8'hea, 8'h7e,
    8'h1b, 8'hef, 8'h4f, 8'hda, 8'h61, 8'h27, 8'h41, 8'he2, 8'hd0, 8'h7c, 8'h2e, 8'h5e, 8'h43, 8'h8f, 8'hc2, 8'h67,
    8'h3b, 8'h0b, 8'hc7, 8'h1f, 8'he2, 8'hfd, 8'h5f, 8'h67, 8'h07, 8'hcc, 8'hca, 8'haf, 8'hb0, 8'hd9, 8'h24, 8'h29,
    8'hee, 8'h65, 8'hd4, 8'hb9, 8'hca, 8'h8f, 8'hdb, 8'hec, 8'he9, 8'h7f, 8'h86, 8'he6, 8'hf1, 8'h63, 8'h4d, 8'hab,
    8'h33, 8'h7e, 8'h03, 8'had, 8'h4f, 8'h40, 8'h2a, 8'h5b, 8'h64, 8'hcd, 8'hb7, 8'hd4, 8'h84, 8'hbf, 8'h30, 8'h1c,
    8'h00, 8'h98, 8'hf6, 8'h8d, 8'h2e, 8'h8b, 8'h02, 8'h69, 8'hbf, 8'h23, 8'h17, 8'h94, 8'hb9, 8'h0b, 8'hcc, 8'hb2,
    8'h8a, 8'h2d, 8'h9d, 8'h5c, 8'hc8, 8'h9e, 8'haa, 8'h4a, 8'h72, 8'h55, 8'h6f, 8'hde, 8'ha6, 8'h78, 8'h04, 8'hfa,
    8'hd4, 8'h9f, 8'h12, 8'h29, 8'h2e, 8'h4f, 8'hfa, 8'h0e, 8'h12, 8'h2a, 8'h77, 8'h6b, 8'h2b, 8'h9f, 8'hb4, 8'hdf,
    8'hee, 8'h12, 8'h6a, 8'hbb, 8'hae, 8'h11, 8'hd6, 8'h32, 8'h36, 8'ha2, 8'h49, 8'hf4, 8'h44, 8'h03, 8'ha1, 8'h1e,
    8'ha6, 8'hec, 8'ha8, 8'h9c, 8'hc9, 8'h00, 8'h96, 8'h5f, 8'h84, 8'h00, 8'h05, 8'h4b, 8'h88, 8'h49, 8'h04, 8'haf,
    8'hec, 8'h93, 8'he5, 8'h27, 8'he3, 8'hc7, 8'ha2, 8'h78, 8'h4f, 8'h9c, 8'h19, 8'h9d, 8'hd8, 8'h5e, 8'h02, 8'h21,
    8'h73, 8'h01, 8'hd4, 8'h82, 8'hcd, 8'h2e, 8'h28, 8'hb9, 8'hb7, 8'hc9, 8'h59, 8'ha7, 8'hf8, 8'haa, 8'h3a, 8'hbf,
    8'h6b, 8'h7d, 8'h30, 8'h10, 8'hd9, 8'hef, 8'hf2, 8'h37, 8'h17, 8'hb0, 8'h86, 8'h61, 8'h0d, 8'h70, 8'h60, 8'h62,
    8'hc6, 8'h9a, 8'hfc, 8'hf6, 8'h53, 8'h91, 8'hc2, 8'h81, 8'h43, 8'h04, 8'h30, 8'h21, 8'hc2, 8'h45, 8'hca, 8'h5a,
    8'h3a, 8'h94, 8'hd1, 8'h36, 8'he8, 8'h92, 8'haf, 8'h2c, 8'hbb, 8'h68, 8'h6b, 8'h22, 8'h3c, 8'h97, 8'h23, 8'h92,
    8'hb4, 8'h71, 8'h10, 8'he5, 8'h58, 8'hb9, 8'hba, 8'h6c, 8'heb, 8'h86, 8'h58, 8'h22, 8'h38, 8'h92, 8'hbf, 8'hd3,
    8'h8d, 8'h12, 8'he1, 8'h24, 8'hdd, 8'hfd, 8'h3d, 8'h93, 8'h77, 8'hc6, 8'hf0, 8'hae, 8'he5, 8'h3c, 8'h86, 8'hdb,
    8'hb1, 8'h12, 8'h22, 8'hcb, 8'he3, 8'h8d, 8'he4, 8'h83, 8'h9c, 8'ha0, 8'heb, 8'hff, 8'h68, 8'h62, 8'h60, 8'hbb,
    8'h7d, 8'hf7, 8'h2b, 8'hc7, 8'h4e, 8'h1a, 8'hb9, 8'h2d, 8'h9c, 8'hd1, 8'he4, 8'he2, 8'hdc, 8'hd3, 8'h4b, 8'h73,
    8'h4e, 8'h92, 8'hb3, 8'h2c, 8'hc4, 8'h15, 8'h14, 8'h4b, 8'h43, 8'h1b, 8'h30, 8'h61, 8'hc3, 8'h47, 8'hbb, 8'h43,
    8'h99, 8'h68, 8'heb, 8'h16, 8'hdd, 8'h31, 8'hb2, 8'h03, 8'hf6, 8'hef, 8'h07, 8'he7, 8'ha8, 8'h75, 8'ha7, 8'hdb,
    8'h2c, 8'h47, 8'hca, 8'h7e, 8'h02, 8'h23, 8'h5e, 8'h8e, 8'h77, 8'h59, 8'h75, 8'h3c, 8'h4b, 8'h61, 8'hf3, 8'h6d,
    8'hf9, 8'h17, 8'h86, 8'hb8, 8'hb9, 8'he5, 8'h1b, 8'h6d, 8'h77, 8'h7d, 8'hde, 8'hd6, 8'h17, 8'h5a, 8'ha7, 8'hcd,
    8'h5d, 8'hee, 8'h46, 8'ha9, 8'h9d, 8'h06, 8'h6c, 8'h9d, 8'haa, 8'he9, 8'ha8, 8'h6b, 8'hf0, 8'h43, 8'h6b, 8'hec,
    8'hc1, 8'h27, 8'hf3, 8'h3b, 8'h59, 8'h11, 8'h53, 8'ha2, 8'h2b, 8'h33, 8'h57, 8'hf9, 8'h50, 8'h69, 8'h1e, 8'hcb,
    8'hd9, 8'hd0, 8'h0e, 8'h60, 8'h53, 8'h03, 8'hed, 8'he4, 8'h9c, 8'h61, 8'hda, 8'h00, 8'h75, 8'h0c, 8'hee, 8'h2c,
    8'h50, 8'ha3, 8'ha4, 8'h63, 8'hbc, 8'hba, 8'hbb, 8'h80, 8'hab, 8'h0c, 8'he9, 8'h96, 8'ha1, 8'ha5, 8'hb1, 8'hf0,
    8'h39, 8'hca, 8'h8d, 8'h93, 8'h30, 8'hde, 8'h0d, 8'hab, 8'h88, 8'h29, 8'h96, 8'h5e, 8'h02, 8'hb1, 8'h3d, 8'hae,
    8'h42, 8'hb4, 8'h75, 8'h2e, 8'ha8, 8'hf3, 8'h14, 8'h88, 8'h0b, 8'ha4, 8'h54, 8'hd5, 8'h38, 8'h8f, 8'hbb, 8'h17,
    8'hf6, 8'h16, 8'h0a, 8'h36, 8'h79, 8'hb7, 8'hb6, 8'hae, 8'hd7, 8'h7f, 8'h42, 8'h5f, 8'h5b, 8'h8a, 8'hbb, 8'h34,
    8'hde, 8'haf, 8'hba, 8'hff, 8'h18, 8'h59, 8'hce, 8'h43, 8'h38, 8'h54, 8'he5, 8'hcb, 8'h41, 8'h52, 8'hf6, 8'h26,
    8'h78, 8'hc9, 8'h9e, 8'h83, 8'hf7, 8'h9c, 8'hca, 8'ha2, 8'h6a, 8'h02, 8'hf3, 8'hb9, 8'h54, 8'h9a, 8'he9, 8'h4c,
    8'h35, 8'h12, 8'h90, 8'h22, 8'h28, 8'h6e, 8'hc0, 8'h40, 8'hbe, 8'hf7, 8'hdf, 8'h1b, 8'h1a, 8'ha5, 8'h51, 8'hae,
    8'hcf, 8'h59, 8'ha6, 8'h48, 8'h0f, 8'hbc, 8'h73, 8'hc1, 8'h2b, 8'hd2, 8'h7e, 8'hba, 8'h3c, 8'h61, 8'hc1, 8'ha0,
    8'ha1, 8'h9d, 8'hc5, 8'he9, 8'hfd, 8'hbd, 8'hd6, 8'h4a, 8'h88, 8'h82, 8'h28, 8'h02, 8'h03, 8'hcc, 8'h6a, 8'h75
};
genvar i, j;
//this was all tested with aesenc from verushash2.0 NOT 2.1 so needs to be retested. 
generate 
    for  (i =0; i<2; i = i +1) begin
        for  (j =0; j<2; j = j +1) begin
            aesenc_new AES_EN_1(
            .clk(clk),
            .s(s[(3*i)+j][127:0]), //top of indexes are one 'row' of rc (16x8 bit) x 40 total rows
            .rk(rc[5119 -(128*4*2*i)-(128*4*j) -: 128] ), //128 is 16x8 bit unsigned chars 
            .s_out(s[(3*i)+j+1][127:0]) 
            );
            aesenc_new AES_EN_2(
            .clk(clk),
            .s(s[(3*i)+j][255:128]),
            .rk(rc[4991 -(128*4*2*i)-(128*4*j) -: 128] ), //add one for each additional module, i.e. 128
            .s_out(s[(3*i)+j+1][255:128])
            );
            aesenc_new AES_EN_3(
            .clk(clk),
            .s(s[(3*i)+j][383:256]),
            .rk(rc[4863 -(128*4*2*i)-(128*4*j) -: 128] ),
            .s_out(s[(3*i)+j+1][383:256])
            );
            aesenc_new AES_EN_4(
            .clk(clk),
            .s(s[(3*i)+j][511:384]),
            .rk(rc[4735 -(128*4*2*i)-(128*4*j) -: 128] ),
            .s_out(s[(3*i)+j+1][511:384]) //
            );
        end
        haraka512_perm_mix MIX(
        .s_in(s[(i*3)+2]), // 2, 5
        .out(s[(i*3)+3]) // 3,6
);
    end
endgenerate

aesenc_new AES_EN_1(
            .clk(clk),
            .s(s[6][127:0]), //top of indexes are one 'row' of rc (16x8 bit) x 40 total rows
            .rk(rc[5119 -(128*4*2*i)-(128*4*j) -: 128] ), //128 is 16x8 bit unsigned chars 
            .s_out(s[(3*i)+j+1][127:0]) 
            );
aesenc_new AES_EN_2(
            .clk(clk),
            .s(s[6][255:128]),
            .rk(rc[4991 -(128*4*2*i)-(128*4*j) -: 128] ), //add one for each additional module, i.e. 128
            .s_out(s[(3*i)+j+1][255:128])
            );
aesenc_new AES_EN_3(
            .clk(clk),
            .s(s[6][383:256]),
            .rk(rc[4863 -(128*4*2*i)-(128*4*j) -: 128] ),
            .s_out(s[(3*i)+j+1][383:256])
            );
aesenc_new AES_EN_4(
            .clk(clk),
            .s(s[6][511:384]),
            .rk(rc[4735 -(128*4*2*i)-(128*4*j) -: 128] ),
            .s_out(s[(3*i)+j+1][511:384])
            );

assign s[0] = s_in;
assign s_final = {s[15][127:0],s[15][255:128],s[15][383:256],s[15][511:384]};
//this is to mirror the output format of C, maybe leave in native form once finished? This is something that needs to be standardized throughout, I have switched between files depending on how I was verifying outputs.
always @(posedge clk)begin
     
end             
endmodule
