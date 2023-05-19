`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2023 16:42:06
// Design Name: 
// Module Name: vga_driver
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


module vga_driver #(
	parameter DEFAULT_POWER  = 1'b0, 		parameter DEFAULT_POWER_ASCII	= 8'h30,
	parameter DEFAULT_GAIN	 = 4'd4, 		parameter DEFAULT_GAIN_ASCII  	= 16'h34
) (
    input wire clk,
    input wire power_signal,
    input wire gain_inc_signal,
    input wire gain_dec_signal,

    input wire [2:0] rx_dst,
    input wire [3:0] rx_cmd,
    input wire [15:0] rx_val,
    input wire rx_fin,

    input wire tx_ready,
    output reg tx_valid,
    output reg [7:0] tx_data,

    output reg [3:0] dac_value = DEFAULT_GAIN,
    output reg vga_enable = DEFAULT_POWER,
    
    output wire led0,
    output wire led1,
    output wire led2,
    output wire led3
);

    `include "serial_defines.hv"

	//-------------------------------------RX/TX HANDLING-------------------------------------
	//
	// RX/TX handling via buttons and serial communication.

	localparam SZ_BUF = 144;

	localparam TX_IDLE = 2'b01;
	localparam TX_SEND = 2'b10;


	// local variables for text output string concat
	localparam ASCII_TXT_POWER	= 56'h504F5745523A20;	// "POWER: "
    localparam ASCII_TXT_GAIN   = 48'h4741494E3A20;     // "GAIN: "
	localparam ASCII_LF        	= 8'h0A;	 			// "\n"


	reg [1:0] 		 state_tx 	  = TX_IDLE;
	reg [SZ_BUF-1:0] write_buffer = 0;
	reg [4:0]		 tx_count	  = 0;
	reg 			 tx_start  	  = 0;

    
	// registers for values output string concat
	reg [7:0] ascii_val_power		= DEFAULT_POWER_ASCII;
	reg [15:0] ascii_val_gain		= DEFAULT_GAIN_ASCII;

	// local variables for input value handling, only read after write to avoid latches!
	reg [15:0] recv_value;
	reg [15:0] recv_value_ascii;
    
    
    always@(posedge clk) begin
		tx_start <= 0;

		//-------------------------------------RX HANDLER-------------------------------------
        if (power_signal == 1) begin
            recv_value		 = ~vga_enable;
            vga_enable      <= recv_value;
            ascii_val_power <= bin2ascii10(recv_value);
        end
        else if (gain_inc_signal == 1) begin 
            recv_value		 = dac_value + 1;
            dac_value       <= recv_value;
            ascii_val_gain  <= bin2ascii10(recv_value);
        end
        else if (gain_dec_signal == 1) begin
            recv_value		 = dac_value - 1;
            dac_value       <= recv_value;
            ascii_val_gain  <= bin2ascii10(recv_value);
        end
        else if (rx_fin && rx_dst == DESTINATION_VGA) begin
            case (rx_cmd)
				// VGA:POWER [0/1]: enables/disables vga.
				COMMAND_POWER: begin
					recv_value		 = rx_val[0];
					recv_value_ascii = bin2ascii10(recv_value);

					vga_enable 		<= recv_value;
					ascii_val_power <= recv_value_ascii;
					
					write_buffer	<= {ASCII_TXT_POWER, recv_value_ascii, ASCII_LF,
										{SZ_BUF-80{1'b0}}};
					tx_count 		<= 10;
					tx_start 		<= 1;
				end
				// VGA:STATUS [<any number>]: return status message.
                COMMAND_STATUS: begin
					write_buffer <= {ASCII_TXT_POWER	, ascii_val_power	, ASCII_LF,
									 ASCII_TXT_GAIN		, ascii_val_gain	, ASCII_LF, 
									 {SZ_BUF-144{1'b0}}};
					tx_start <= 1;
					tx_count <= 18;
                end
				// VGA:GAIN [0..15]: sets the vga gain.
                COMMAND_GAIN: begin
					recv_value		 = rx_val[3:0];
					recv_value_ascii = bin2ascii10(recv_value);

					dac_value 		<= recv_value;
					ascii_val_gain  <= recv_value_ascii;
					
					write_buffer	<= {ASCII_TXT_GAIN, recv_value_ascii, ASCII_LF,
										{SZ_BUF-72{1'b0}}};
					tx_count 		<= 9;
					tx_start 		<= 1;
                end
				// VGA:RESET [<any number>]: resets signals
				COMMAND_RESET: begin
					vga_enable    	<= DEFAULT_POWER;
					dac_value		<= DEFAULT_GAIN;
					ascii_val_power	<= DEFAULT_POWER_ASCII;
					ascii_val_gain	<= DEFAULT_GAIN_ASCII;

					write_buffer	<= {112'h434F4D4D205245534554204F4B21, ASCII_LF, // COMM RESET OK!
										{SZ_BUF-120{1'b0}}};
					tx_count 		<= 15;
					tx_start 		<= 1;
				end
            endcase
        end
        
		//-------------------------------------TX HANDLER-------------------------------------
		case (state_tx)
			// Wait for reply data
			TX_IDLE: if (tx_start) begin
				state_tx <= TX_SEND;
			end
			// Send buffered data as reply to RX
			TX_SEND: begin
				if (tx_count > 0) begin	
					tx_valid			<= #1 1'b1;
					tx_data 			<= #1 write_buffer[SZ_BUF-1:SZ_BUF-8];
					if (tx_ready) begin
						write_buffer	<= #1 write_buffer << 8;
						tx_count 		<= #1 tx_count - 1;
					end
				end
				else begin
					tx_valid	<= #1 1'b0;
					state_tx	<= #1 TX_IDLE;
				end
			end
		endcase
    end

    //DAC. Output Voltage = DACValue/15 [V]
    assign led0 = dac_value[0];
    assign led1 = dac_value[1];
    assign led2 = dac_value[2];
    assign led3 = dac_value[3];

endmodule
