`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.07.2021 06:47:48
// Design Name: 
// Module Name: uart
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


module uart
    #(parameter CLKS_PER_BIT = 1042, parameter BUFFER_LENGTH = 128)
    (
    input wire sysclk, uart_rx_pin, tx_send_message,
    input wire [BUFFER_LENGTH-1:0] tx_message,
    output wire uart_tx_pin,
    output reg rx_new_message, tx_busy,
    output reg [BUFFER_LENGTH-1:0] rx_message
    );
    
//UART regs
wire w_Rx_DV;
reg  r_Tx_DV = 0;
wire w_Tx_Done;
wire w_Tx_Active;
reg  [7:0] r_Tx_Byte = 0;
wire [7:0] w_Rx_Byte;

reg[BUFFER_LENGTH-1:0] tx_Buffer = 0;
reg[BUFFER_LENGTH-1:0] rx_Buffer = 0;

uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_INST
    (.i_Clock(sysclk),
     .i_Rx_Serial(uart_rx_pin),
     .o_Rx_DV(w_Rx_DV),
     .o_Rx_Byte(w_Rx_Byte)
     );

uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX_INST
    (.i_Clock(sysclk),
     .i_Tx_DV(r_Tx_DV),
     .i_Tx_Byte(r_Tx_Byte),
     .o_Tx_Active(w_Tx_Active),
     .o_Tx_Serial(uart_tx_pin),
     .o_Tx_Done(w_Tx_Done)
     );

always@(posedge(sysclk)) begin
//TX/RX Part---------------------------------------------------------

    //Module I/0
    if (tx_send_message == 1) begin
        tx_Buffer <= tx_message;
    end

    if (tx_Buffer != 0) begin
        tx_busy <= 1;
    end else begin
        tx_busy <= 0;
    end

    //Routine for writing tx buffer into serial port
    if ((tx_Buffer != 0)&&(w_Tx_Active == 0)&&(r_Tx_DV==0)) begin
        r_Tx_DV <= 1'b1;
        r_Tx_Byte <= tx_Buffer[BUFFER_LENGTH-1:BUFFER_LENGTH-8];
        tx_Buffer <= tx_Buffer << 8;
    end
    if ( r_Tx_DV == 1'b1) begin
        r_Tx_DV <= 1'b0;
    end
    
    //Routine for reading rx
    if (w_Rx_DV == 1) begin
        rx_Buffer <= rx_Buffer << 8;
        rx_Buffer[7:0] <= w_Rx_Byte;
    end    
    if (rx_Buffer[7:0] == 10) begin//If newline symbol (ASCII: 10) is received, the message is considered complete, and loaded into rx_message.
        rx_message <= rx_Buffer;
        rx_Buffer <= 0;
        rx_new_message <= 1;
    end
    if (rx_new_message == 1) begin
        rx_new_message <= 0;
    end

end
    

endmodule
