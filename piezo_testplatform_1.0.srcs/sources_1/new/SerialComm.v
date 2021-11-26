`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.08.2021 15:04:39
// Design Name: 
// Module Name: SerialComm
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


module SerialComm
    #(parameter CLKS_PER_BIT = 1042, parameter BUFFER_LENGTH = 128)
    (
    input wire sysclk, uart_rx_pin, 
    output wire uart_tx_pin,
    
    output reg VGA_Enable = 0,
    output reg PiezoDriverEnable = 0,
    output reg[3:0] Data = 'b1010,
    output reg[11:0] Charge_Pulses = 100,
    output reg[15:0] Start_L_us = 500,
    output reg[11:0] Zero_L = 100,
    output reg[11:0] One_L = 200,
    output reg[15:0] Break_L_us = 200,
    output reg[3:0] DAC_set = 0
    );

    wire[BUFFER_LENGTH-1:0] rx_message;
    reg[BUFFER_LENGTH-1:0] tx_message = 0;
    reg tx_send_message = 0;
    wire rx_new_message, tx_busy;
    reg[7:0] byte1 = 0;
    reg[31:0] byte4 = 0;
    reg wait_cycle = 0;
    
    uart #(.CLKS_PER_BIT(CLKS_PER_BIT), .BUFFER_LENGTH(BUFFER_LENGTH)) UART_INST
    //uart UART_INST
       (.sysclk(sysclk),
        .uart_rx_pin(uart_rx_pin),
        .uart_tx_pin(uart_tx_pin),
        .tx_message(tx_message),
        .tx_send_message(tx_send_message),
        .rx_message(rx_message),
        .rx_new_message(rx_new_message),
        .tx_busy(tx_busy)
        );
    
    always@(posedge sysclk) begin
    //UART Communication
        if (tx_send_message==1) tx_send_message <=0;//clear after one sysclk cycle
        
        if (rx_new_message==1) begin
            //tx_message <= rx_message;//Send it back as confirmation
            //tx_send_message <= 1;
            wait_cycle <= 1;
            
            //Evaluate arguments of message
            //calculate 1-byte argument
            if (rx_message[15:8] < 'h3A) begin
                byte1 <= rx_message[15:8]-'h30;
            end
            if (rx_message[15:8] > 'h40) begin
                byte1 <= 10 + rx_message[15:8]-'h41;
            end
             
            //calculate 4-byte argument
            if ('h2F < rx_message[15:8] < 'h3A) begin//0th byte
                byte4[7:0] <= rx_message[15:8]-'h30;
            end
            /*if (rx_message[15:8] > 'h40) begin
                byte4[7:0] <= 10 + rx_message[15:8]-'h41;
            end*/
            if ('h2F < rx_message[23:16] < 'h3A) begin//1st byte
                byte4[15:8] <= rx_message[23:16]-'h30;
            end

            if ('h2F < rx_message[31:24] < 'h3A) begin//2nd byte
                byte4[23:16] <= rx_message[31:24]-'h30;
            end

            if ('h2F < rx_message[39:32] < 'h3A) begin//3rd byte
                byte4[31:24] <= rx_message[39:32]-'h30;
            end
   
        end
        
        if (wait_cycle==1) begin//Evaluate operators. Delay by one cycle to allow for sequential calculation of byte1, byte4
            wait_cycle <= 0;
            
            //Evaluate operator
            case (rx_message[47:16])//1-byte argument operations
            
                'h56474120: begin//ASCII for "VGA "
                    VGA_Enable <= byte1;//ASCII "0"
                end
                
                'h50494520: begin//ASCII for "PIE "
                    PiezoDriverEnable <= byte1;//ASCII "0"
                end
                
                'h414d5020: begin//ASCII for "AMP "
                    DAC_set <= byte1;
                end
                
                'h44415420: begin//ASCII for "DAT "
                    Data <= byte1;
                end
            endcase    
            
            case (rx_message[71:40])//4-byte argument operations    
                
                'h43485020: begin//ASCII for "CHP "
                    Charge_Pulses <= byte4[7:0]+10*byte4[15:8]+100*byte4[23:16]+1000*byte4[31:24];
                    tx_message <= 10+256*(byte4[7:0]+10*byte4[15:8]+100*byte4[23:16]+1000*byte4[31:24]);//Send it back as confirmation
                    tx_send_message <= 1;
                    
                end
                
                'h53544c20: begin//ASCII for "STL "
                    Start_L_us <= byte4[7:0]+10*byte4[15:8]+100*byte4[23:16]+1000*byte4[31:24];
                end
                
                'h5a5f4c20: begin//ASCII for "Z_L "
                    Zero_L <= byte4[7:0]+10*byte4[15:8]+100*byte4[23:16]+1000*byte4[31:24];
                end
                
                'h4f5f4c20: begin//ASCII for "O_L "
                    One_L <= byte4[7:0]+10*byte4[15:8]+100*byte4[23:16]+1000*byte4[31:24];
                end
                
                'h425f4c20: begin//ASCII for "B_L "
                    Break_L_us <= byte4[7:0]+10*byte4[15:8]+100*byte4[23:16]+1000*byte4[31:24];
                end               
            endcase
        end    
    end
    
endmodule
