`timescale 1ns / 1ps
//old aesenc, Peter's copy? No genvars
module aesenc(
    input clk,
    input [511:0] s,
    input [127:0] rk, 
    output reg [0:511] s_out
    );
    
localparam sbox  = { 8'h63, 8'h7c, 8'h77, 8'h7b, 8'hf2, 8'h6b, 8'h6f, 8'hc5, 8'h30, 8'h01, 8'h67, 8'h2b, 8'hfe,
  8'hd7, 8'hab, 8'h76, 8'hca, 8'h82, 8'hc9, 8'h7d, 8'hfa, 8'h59, 8'h47, 8'hf0, 8'had, 8'hd4,
  8'ha2, 8'haf, 8'h9c, 8'ha4, 8'h72, 8'hc0, 8'hb7, 8'hfd, 8'h93, 8'h26, 8'h36, 8'h3f, 8'hf7,
  8'hcc, 8'h34, 8'ha5, 8'he5, 8'hf1, 8'h71, 8'hd8, 8'h31, 8'h15, 8'h04, 8'hc7, 8'h23, 8'hc3,
  8'h18, 8'h96, 8'h05, 8'h9a, 8'h07, 8'h12, 8'h80, 8'he2, 8'heb, 8'h27, 8'hb2, 8'h75, 8'h09,
  8'h83, 8'h2c, 8'h1a, 8'h1b, 8'h6e, 8'h5a, 8'ha0, 8'h52, 8'h3b, 8'hd6, 8'hb3, 8'h29, 8'he3,
  8'h2f, 8'h84, 8'h53, 8'hd1, 8'h00, 8'hed, 8'h20, 8'hfc, 8'hb1, 8'h5b, 8'h6a, 8'hcb, 8'hbe,
  8'h39, 8'h4a, 8'h4c, 8'h58, 8'hcf, 8'hd0, 8'hef, 8'haa, 8'hfb, 8'h43, 8'h4d, 8'h33, 8'h85,
  8'h45, 8'hf9, 8'h02, 8'h7f, 8'h50, 8'h3c, 8'h9f, 8'ha8, 8'h51, 8'ha3, 8'h40, 8'h8f, 8'h92,
  8'h9d, 8'h38, 8'hf5, 8'hbc, 8'hb6, 8'hda, 8'h21, 8'h10, 8'hff, 8'hf3, 8'hd2, 8'hcd, 8'h0c,
  8'h13, 8'hec, 8'h5f, 8'h97, 8'h44, 8'h17, 8'hc4, 8'ha7, 8'h7e, 8'h3d, 8'h64, 8'h5d, 8'h19,
  8'h73, 8'h60, 8'h81, 8'h4f, 8'hdc, 8'h22, 8'h2a, 8'h90, 8'h88, 8'h46, 8'hee, 8'hb8, 8'h14,
  8'hde, 8'h5e, 8'h0b, 8'hdb, 8'he0, 8'h32, 8'h3a, 8'h0a, 8'h49, 8'h06, 8'h24, 8'h5c, 8'hc2,
  8'hd3, 8'hac, 8'h62, 8'h91, 8'h95, 8'he4, 8'h79, 8'he7, 8'hc8, 8'h37, 8'h6d, 8'h8d, 8'hd5,
  8'h4e, 8'ha9, 8'h6c, 8'h56, 8'hf4, 8'hea, 8'h65, 8'h7a, 8'hae, 8'h08, 8'hba, 8'h78, 8'h25,
  8'h2e, 8'h1c, 8'ha6, 8'hb4, 8'hc6, 8'he8, 8'hdd, 8'h74, 8'h1f, 8'h4b, 8'hbd, 8'h8b, 8'h8a,
  8'h70, 8'h3e, 8'hb5, 8'h66, 8'h48, 8'h03, 8'hf6, 8'h0e, 8'h61, 8'h35, 8'h57, 8'hb9, 8'h86,
  8'hc1, 8'h1d, 8'h9e, 8'he1, 8'hf8, 8'h98, 8'h11, 8'h69, 8'hd9, 8'h8e, 8'h94, 8'h9b, 8'h1e,
  8'h87, 8'he9, 8'hce, 8'h55, 8'h28, 8'hdf, 8'h8c, 8'ha1, 8'h89, 8'h0d, 8'hbf, 8'he6, 8'h42,
  8'h68, 8'h41, 8'h99, 8'h2d, 8'h0f, 8'hb0, 8'h54, 8'hbb, 8'h16 };
    
    
reg [32:0] s_memory [15:0]; //for debugging


function [7:0] xt;
    input [7:0] v_in;
    begin
    xt = (((v_in) << 1) ^ ((((v_in) >> 7) & 1) * 8'h1b));
    end
endfunction


function [7:0] get_v;
    input [2:0] v_i;
    input [2:0] v_j;
    
    begin
        if (v_i == 0 && v_j == 0) begin
            get_v = sbox[(2040-(s[7:0]*8))+:8];
        end else if (v_i == 0 && v_j == 1) begin
            get_v = sbox[(2040-(s[47:40]*8))+:8];
        end else if (v_i == 0 && v_j == 2) begin
            get_v = sbox[(2040-(s[87:80]*8))+:8];
        end else if (v_i == 0 && v_j == 3) begin
            get_v = sbox[(2040-(s[127:120]*8))+:8];
            
        end else if (v_i == 1 && v_j == 0) begin
            get_v = sbox[(2040-(s[39:32]*8))+:8];           
        end else if (v_i == 1 && v_j == 1) begin
            get_v = sbox[(2040-(s[79:72]*8))+:8];
        end else if (v_i == 1 && v_j == 2) begin
            get_v = sbox[(2040-(s[119:112]*8))+:8];
        end else if (v_i == 1 && v_j == 3) begin
            get_v = sbox[(2040-(s[31:24]*8))+:8];
            
        end else if (v_i == 2 && v_j == 0) begin
            get_v = sbox[(2040-(s[71:64]*8))+:8];     
        end else if (v_i == 2 && v_j == 1) begin
            get_v = sbox[(2040-(s[111:104]*8))+:8];
        end else if (v_i == 2 && v_j == 2) begin
            get_v = sbox[(2040-(s[23:16]*8))+:8];
        end else if (v_i == 2 && v_j == 3) begin
            get_v = sbox[(2040-(s[63:56]*8))+:8];
            
        end else if (v_i == 3 && v_j == 0) begin
            get_v = sbox[(2040-(s[103:96]*8))+:8];        
        end else if (v_i == 3 && v_j == 1) begin
            get_v = sbox[(2040-(s[15:8]*8))+:8];
        end else if (v_i == 3 && v_j == 2) begin
            get_v = sbox[(2040-(s[55:48]*8))+:8];
        end else if (v_i == 3 && v_j == 3) begin
            get_v = sbox[(2040-(s[95:88]*8))+:8];
        end
        
    end
endfunction

/*      Traditional V assignments. Wastes a cycle
        v[0][0] = sbox[(2040-(s[7:0]*8))+:8];
        v[3][1] = sbox[(2040-(s[15:8]*8))+:8];
        v[2][2] = sbox[(2040-(s[23:16]*8))+:8];
        v[1][3] = sbox[(2040-(s[31:24]*8))+:8];
        v[1][0] = sbox[(2040-(s[39:32]*8))+:8];
        v[0][1] = sbox[(2040-(s[47:40]*8))+:8];
        v[3][2] = sbox[(2040-(s[55:48]*8))+:8];
        v[2][3] = sbox[(2040-(s[63:56]*8))+:8];
        v[2][0] = sbox[(2040-(s[71:64]*8))+:8];
        v[1][1] = sbox[(2040-(s[79:72]*8))+:8];
        v[0][2] = sbox[(2040-(s[87:80]*8))+:8];
        v[3][3] = sbox[(2040-(s[95:88]*8))+:8];
        v[3][0] = sbox[(2040-(s[103:96]*8))+:8];
        v[2][1] = sbox[(2040-(s[111:104]*8))+:8];
        v[1][2] = sbox[(2040-(s[119:112]*8))+:8];
        v[0][3] = sbox[(2040-(s[127:120]*8))+:8];
*/

always@(posedge clk) begin
//        s_out[31:0] <= (get_v(0,0) ^ ((get_v(0,0) ^ get_v(0,1) ^ get_v(0,2) ^ get_v(0,3)) ^ xt(get_v(0,0) ^ get_v(0,1)))) ^ rk[127:120];
//        s_out[63:32] <= (get_v(0,1) ^ ((get_v(0,0) ^ get_v(0,1) ^ get_v(0,2) ^ get_v(0,3)) ^ xt(get_v(0,1) ^ get_v(0,2)))) ^ rk[119:112];
//        s_out[95:64] <= (get_v(0,2) ^ ((get_v(0,0) ^ get_v(0,1) ^ get_v(0,2) ^ get_v(0,3)) ^ xt(get_v(0,2) ^ get_v(0,3)))) ^ rk[111:104];
//        s_out[127:96] <= (get_v(0,3) ^ ((get_v(0,0) ^ get_v(0,1) ^ get_v(0,2) ^ get_v(0,3)) ^ xt(get_v(0,3) ^ sbox[(2040 - (s[7:0]*8)) +: 8]))) ^ rk[103:96];
        
//        s_out[159:128] <= (get_v(1,0) ^ ((get_v(1,0) ^ get_v(1,1) ^ get_v(1,2) ^ get_v(1,3)) ^ xt(get_v(1,0) ^ get_v(1,1)))) ^ rk[95:88];
//        s_out[191:160] <= (get_v(1,1) ^ ((get_v(1,0) ^ get_v(1,1) ^ get_v(1,2) ^ get_v(1,3)) ^ xt(get_v(1,1) ^ get_v(1,2)))) ^ rk[87:80];
//        s_out[223:192] <= (get_v(1,2) ^ ((get_v(1,0) ^ get_v(1,1) ^ get_v(1,2) ^ get_v(1,3)) ^ xt(get_v(1,2) ^ get_v(1,3)))) ^ rk[71:64];
//        s_out[255:224] <= (get_v(1,3) ^ ((get_v(1,0) ^ get_v(1,1) ^ get_v(1,2) ^ get_v(1,3)) ^ xt(get_v(1,3) ^ sbox[(2040 - (s[39:32]*8)) +: 8]))) ^ rk[63:56];
        
//        s_out[287:256] <= (get_v(2,0) ^ ((get_v(2,0) ^ get_v(2,1) ^ get_v(2,2) ^ get_v(2,3)) ^ xt(get_v(2,0) ^ get_v(2,1)))) ^ rk[63:56];
//        s_out[319:288] <= (get_v(2,1) ^ ((get_v(2,0) ^ get_v(2,1) ^ get_v(2,2) ^ get_v(2,3)) ^ xt(get_v(2,1) ^ get_v(2,2)))) ^ rk[55:48];
//        s_out[351:320] <= (get_v(2,2) ^ ((get_v(2,0) ^ get_v(2,1) ^ get_v(2,2) ^ get_v(2,3)) ^ xt(get_v(2,2) ^ get_v(2,3)))) ^ rk[47:40];
//        s_out[383:352] <= (get_v(2,3) ^ ((get_v(2,0) ^ get_v(2,1) ^ get_v(2,2) ^ get_v(2,3)) ^ xt(get_v(2,3) ^ sbox[(2040 - (s[71:64]*8)) +: 8]))) ^ rk[39:32];
        
//        s_out[415:384] <= (get_v(3,0) ^ ((get_v(3,0) ^ get_v(3,1) ^ get_v(3,2) ^ get_v(3,3)) ^ xt(get_v(3,0) ^ get_v(3,1)))) ^ rk[31:24];
//        s_out[447:416] <= (get_v(3,1) ^ ((get_v(3,0) ^ get_v(3,1) ^ get_v(3,2) ^ get_v(3,3)) ^ xt(get_v(3,1) ^ get_v(3,2)))) ^ rk[23:16];
//        s_out[479:448] <= (get_v(3,2) ^ ((get_v(3,0) ^ get_v(3,1) ^ get_v(3,2) ^ get_v(3,3)) ^ xt(get_v(3,2) ^ get_v(3,3)))) ^ rk[15:8];
//        s_out[511:480] <= (get_v(3,3) ^ ((get_v(3,0) ^ get_v(3,1) ^ get_v(3,2) ^ get_v(3,3)) ^ xt(get_v(3,3) ^ sbox[(2040 - (s[103:96]*8)) +: 8]))) ^ rk[7:0];

        s_out[0:31] <= (get_v(0,0) ^ ((get_v(0,0) ^ get_v(0,1) ^ get_v(0,2) ^ get_v(0,3)) ^ xt(get_v(0,0) ^ get_v(0,1)))) ^ rk[127:120];
        s_out[32:63] <= (get_v(0,1) ^ ((get_v(0,0) ^ get_v(0,1) ^ get_v(0,2) ^ get_v(0,3)) ^ xt(get_v(0,1) ^ get_v(0,2)))) ^ rk[119:112];
        s_out[64:95] <= (get_v(0,2) ^ ((get_v(0,0) ^ get_v(0,1) ^ get_v(0,2) ^ get_v(0,3)) ^ xt(get_v(0,2) ^ get_v(0,3)))) ^ rk[111:104];
        s_out[96:127] <= (get_v(0,3) ^ ((get_v(0,0) ^ get_v(0,1) ^ get_v(0,2) ^ get_v(0,3)) ^ xt(get_v(0,3) ^ sbox[(2040 - (s[7:0]*8)) +: 8]))) ^ rk[103:96];
        
        s_out[128:159] <= (get_v(1,0) ^ ((get_v(1,0) ^ get_v(1,1) ^ get_v(1,2) ^ get_v(1,3)) ^ xt(get_v(1,0) ^ get_v(1,1)))) ^ rk[95:88];
        s_out[160:191] <= (get_v(1,1) ^ ((get_v(1,0) ^ get_v(1,1) ^ get_v(1,2) ^ get_v(1,3)) ^ xt(get_v(1,1) ^ get_v(1,2)))) ^ rk[87:80];
        s_out[192:223] <= (get_v(1,2) ^ ((get_v(1,0) ^ get_v(1,1) ^ get_v(1,2) ^ get_v(1,3)) ^ xt(get_v(1,2) ^ get_v(1,3)))) ^ rk[71:64];
        s_out[224:255] <= (get_v(1,3) ^ ((get_v(1,0) ^ get_v(1,1) ^ get_v(1,2) ^ get_v(1,3)) ^ xt(get_v(1,3) ^ sbox[(2040 - (s[39:32]*8)) +: 8]))) ^ rk[63:56];
        
        s_out[256:287] <= (get_v(2,0) ^ ((get_v(2,0) ^ get_v(2,1) ^ get_v(2,2) ^ get_v(2,3)) ^ xt(get_v(2,0) ^ get_v(2,1)))) ^ rk[63:56];
        s_out[288:319] <= (get_v(2,1) ^ ((get_v(2,0) ^ get_v(2,1) ^ get_v(2,2) ^ get_v(2,3)) ^ xt(get_v(2,1) ^ get_v(2,2)))) ^ rk[55:48];
        s_out[320:351] <= (get_v(2,2) ^ ((get_v(2,0) ^ get_v(2,1) ^ get_v(2,2) ^ get_v(2,3)) ^ xt(get_v(2,2) ^ get_v(2,3)))) ^ rk[47:40];
        s_out[352:383] <= (get_v(2,3) ^ ((get_v(2,0) ^ get_v(2,1) ^ get_v(2,2) ^ get_v(2,3)) ^ xt(get_v(2,3) ^ sbox[(2040 - (s[71:64]*8)) +: 8]))) ^ rk[39:32];
        
        s_out[384:415] <= (get_v(3,0) ^ ((get_v(3,0) ^ get_v(3,1) ^ get_v(3,2) ^ get_v(3,3)) ^ xt(get_v(3,0) ^ get_v(3,1)))) ^ rk[31:24];
        s_out[416:447] <= (get_v(3,1) ^ ((get_v(3,0) ^ get_v(3,1) ^ get_v(3,2) ^ get_v(3,3)) ^ xt(get_v(3,1) ^ get_v(3,2)))) ^ rk[23:16];
        s_out[448:479] <= (get_v(3,2) ^ ((get_v(3,0) ^ get_v(3,1) ^ get_v(3,2) ^ get_v(3,3)) ^ xt(get_v(3,2) ^ get_v(3,3)))) ^ rk[15:8];
        s_out[480:511] <= (get_v(3,3) ^ ((get_v(3,0) ^ get_v(3,1) ^ get_v(3,2) ^ get_v(3,3)) ^ xt(get_v(3,3) ^ sbox[(2040 - (s[103:96]*8)) +: 8]))) ^ rk[7:0];
        //s_memory[15] = (get_v(3,3) ^ ((get_v(3,0) ^ get_v(3,1) ^ get_v(3,2) ^ get_v(3,3)) ^ xt(get_v(3,3) ^ sbox[(2040 - (s[103:96]*8)) +: 8]))) ^ rk[7:0];
end
endmodule




