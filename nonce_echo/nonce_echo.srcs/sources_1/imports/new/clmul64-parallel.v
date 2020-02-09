module clmul64_parallel (
    input clk,
    input [63:0] a,
    input [63:0] b,
    output [63:0] r0, //I think it uses a passed pointer just to get the outcome, can't see it's previous value being used at all
    output [63:0] r1 //seperated due to not liking array outputs
    
);
//given these are parameters why waste space, trim signal length to minimum needed?
parameter two_s = 64'b10000; //all three don't seem to change, set as params, do you not need to set amount of bits for params??
parameter s = 8'd4;
parameter smask = two_s -1; //15 i.e all 1s

wire [63:0] u_setup[15:0];
reg [63:0] u[15:0][18:0];
//reg [63:0] temp; was in c code, not needed here
reg [63:0] ifmask[2:0];
reg [63:0] temp_r0[18:0]; //we store enough of these to shunt through 15 different inputs preserving the FIFO nature of their R0 and R1
reg [63:0] temp_r1[18:0];
reg [63:0] a_reg[18:0];
reg [63:0] b_reg[18:0];

wire [63:0] m[2:0]; 

assign u_setup[0] = 64'b0;
assign u_setup[1] = b; 
assign r0 = temp_r0[18];
assign r1 = temp_r1[18];
assign m[0] = {16{4'b1110}}; //0xEEEEEEEEEEEEEEEE m only interacts with itself so just set them manually
assign m[1] = {16{4'b1100}}; //0xCCCCCCCCCCCCCCCC
assign m[2] = {16{4'b1000}}; //0x8888888888888888
//precomputation and multiply setup
genvar i, j, k, l, n;
generate //check if i needs to be declared an integer or not
    for(i =2; i <two_s; i = i+2) begin
            assign u_setup[i] = u_setup[(i >>1)] <<1;
            assign u_setup[i+1] = u_setup[i] ^ b; //so that u can have all it states assigned at once using a wire and we don't have to determine how long this will take if clocked and then move b around
       
    end
    for (j =0; j <15; j = j+1) begin //MULTIPLY LOOP
        always@(posedge clk)begin
            temp_r0[j+1] <= temp_r0[j] ^ (u[a_reg[j] >> (4+ (j*4)) & smask][j]) << (4+ (j*4)); 
            temp_r1[j+1] <= temp_r1[j] ^ (u[a_reg[j] >> (4+ (j*4)) & smask][j]) >> (64- (4+ (j*4))); //(4+ (j*4)) is a horrid way of getting 4,8,12,16...60
            a_reg[j+1] <= a_reg[j];
            b_reg[j+1] <= b_reg[j];
        end
        for(l = 0; l <19; l = l +1)begin
            always@(posedge clk)begin
                u[j][l+1] <= u[j][l];
                u[15][l+1] <= u[15][l]; //j loop doesnt run long enough, could make another loop but we're using nested generates anyway so cba?
            end
        end
    end
    for (k =1; k <4; k = k+1) begin //REPAIR LOOP
        always@(posedge clk)begin
           ifmask[k-1] <= ((b_reg[13+k] >> (64- k)) & 1) ? {64{1'b1}}: 64'b0; //if this breaks it was b_reg[14+k]
           temp_r1[15+k] <= temp_r1[14+k] ^ (((a_reg[14+k]&m[k-1]) >> k)& ifmask[k-1]);
           temp_r0[15+k] <= temp_r0[14+k];
           a_reg[15+k] <= a_reg[14+k];
           b_reg[15+k] <= b_reg[14+k]; 
        end
        
     for(n=0; n<16; n = n+1)begin
        always@(posedge clk) u[n][0] <= u_setup[n]; 
     end   
    end
    
    
endgenerate

always@(posedge clk)begin
    //assign initial  non predictable beginning states
    temp_r0[0] <= u_setup[(a & smask)];  // originally u[(a & smask)][0]; this way avoids additional latency
    temp_r1[0] <= 64'b0;
    a_reg[0] <= a;
    b_reg[0] <= b;   
end

endmodule