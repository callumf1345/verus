`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.09.2019 11:02:24
// Design Name: 
// Module Name: nonce_top
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


module nonce_top(
    input clk,
    input RxD,
    output TxD,
    input btnc,
    output reg [7:0] led =8'b0,  // general purpose outputs
    input [7:0] switches  // general purpose inputs
);

reg transmission_done = 1'b0;
reg [255:0] nonce = 256'b0;
reg [8:0] i = 9'b1000; //offset by 8 so we are displaying bytes received in sync with transmission, not after the fact.
reg [8:0] j = 9'b0;
reg transmit_busy = 1'b0;
reg [7:0] data_out = 8'b0; //holds data to transmit
reg [22:0] send_data = 23'b0; //counts to 16 to slow transmission to allow for sending
reg tx_start = 1'b0;

wire RxD_data_ready;
wire [7:0] RxD_data;
wire button;

async_receiver RX(.clk(clk), .RxD(RxD), .RxD_data_ready(RxD_data_ready), .RxD_data(RxD_data));

debouncer btn_in(
.clk(clk),
.I(btnc),
.O(button)
);


always @(posedge clk) begin
    //led[0] <= button;
    led[6:0] <= send_data[22:16];
    if(RxD_data_ready) begin //add not i[8] to prevent i rolling over our finished value of 256?
        //led <= i[7:0] ; //debug to check we're receiving all data sent right. 
        led[7] <= i[8];
        i <= i +8;
        nonce <= nonce << 8;
        nonce[7:0] <= RxD_data;
        
    end
    if(tx_start) tx_start = 1'b0; //only assert startsend data for one clock cycle
    
    if(i[8]&& !(j[8])&& button) begin //was i[8] change back later
        send_data <= send_data + 1;
        transmit_busy <= 1'b1; //later use to block receive loop from triggering might not need, can use i[8] instead?
        if (send_data[22]) begin //this because python is slow, the initial delay must be this long but subsequent ones can be as fast as 15bits?
            send_data <= 23'b0;
            data_out <= nonce[255:248];
            nonce <= nonce << 8; //don't want every posedge this would be too fast for the transmitter transmission takes 11 clks to send a byte (1start+8data+2stop) so count to 12or16?
            tx_start <= 1; //we can actually run this using send_data[4] but it would be slightly out of sync, think about?
            j <= j + 8; //increments so that once we've sent 256 bits we stop sending
        end 
    end
end

async_transmitter TX(.clk(clk), .TxD(TxD), .TxD_start(tx_start), .TxD_data(data_out));
endmodule