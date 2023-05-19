`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2023 16:42:06
// Design Name: 
// Module Name: comm_protocol
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

`ifdef iverilog
	`include "delay.v"
	`include "piezo_driver.v"
	`include "cdc_taskhandler.v"
`endif

`define COMM_TEST //comment out for normal button behaviour

module comm_protocol #(
	parameter DEFAULT_DATA = 4'b0101, parameter DEFAULT_DATA_ASCII = 16'h35, 
	parameter DEFAULT_CHP  = 12'd100, parameter DEFAULT_CHP_ASCII  = 32'h313030,
	parameter DEFAULT_STL  = 16'd500, parameter DEFAULT_STL_ASCII  = 40'h353030,
	parameter DEFAULT_0L   = 12'd100, parameter DEFAULT_0L_ASCII   = 32'h313030,
	parameter DEFAULT_1L   = 12'd200, parameter DEFAULT_1L_ASCII   = 32'h323030,
	parameter DEFAULT_BRL  = 16'd200, parameter DEFAULT_BRL_ASCII  = 40'h323030,
	parameter DEFAULT_CLKDIV  = 9'd200, parameter DEFAULT_CLKDIV_ASCII  = 32'h323030
) (
	input wire clk,

	// button input
	input wire btn_start,
	
	// serial input
	input wire [2:0] rx_dst,
	input wire [3:0] rx_cmd,
	input wire [15:0] rx_val,
	input wire rx_fin,

	// serial output
	input wire tx_ready,
	output reg tx_valid,
	output reg [7:0] tx_data,

	// signalling and piezo driver output
	output reg  comm_fin 		= 1,
	output wire piezodriver_lo,
	output wire piezodriver_hi
);
	`include "serial_defines.hv"

	reg [3:0]  Data         	= DEFAULT_DATA;
	reg [11:0] Charge_Pulses	= DEFAULT_CHP;
	reg [15:0] Start_L_us   	= DEFAULT_STL;
	reg [11:0] Zero_L       	= DEFAULT_0L;
	reg [11:0] One_L        	= DEFAULT_1L;
	reg [15:0] Break_L_us   	= DEFAULT_BRL;
	
	reg [4:0] state_comm = 0;
	reg [1:0] state_test = 0;

	reg comm_start             	= 0;
	reg test_start				= 0;
	reg delay_start				= 0;
	reg [23:0] delay_us			= 0;
	reg piezo_start_cfg_rdy		= 0;
	reg piezo_start				= 0;
	reg [11:0] piezo_numpulses	= 0;
	reg [8:0] piezo_clkdiv		= DEFAULT_CLKDIV;
	wire [21:0] piezo_start_cfg	= {piezo_clkdiv, piezo_numpulses, piezo_start};

	//wire piezo_start_100, piezo_fin_100;
	wire piezo_start_cfg_rcv, piezo_fin, delay_fin;

	piezo_driver m_piezo_driver (
		.clk				(clk),
		.start_cfg			(piezo_start_cfg),
		.start_cfg_rdy		(piezo_start_cfg_rdy),
		.start_cfg_rcv		(piezo_start_cfg_rcv),
		.fin				(piezo_fin),
		.piezodriver_lo		(piezodriver_lo),
		.piezodriver_hi		(piezodriver_hi)
	);

	delay m_delay (
		.clk_12				(clk),
		.delay_us			(delay_us),
		.start				(delay_start),
		.fin				(delay_fin)
	);


	//-------------------------------------RX/TX HANDLING-------------------------------------
	//
	// RX/TX handling via buttons and serial communication.

	localparam SZ_BUF = 568;

	localparam TX_IDLE = 2'b01;
	localparam TX_SEND = 2'b10;

	reg [1:0] 		 state_tx 	  = TX_IDLE;
	reg [SZ_BUF-1:0] write_buffer = 0;
	reg [6:0]		 tx_count	  = 0;
	reg 			 tx_start  	  = 0;

	localparam STRING_VAL_DFLT  = 40'h44464C54;		// "DFLT", unused
	
	// local variables for text output string concat
	localparam ASCII_TXT_DTA   = 40'h4454413A20; 			// "DTA: "
	localparam ASCII_TXT_CHP   = 40'h4348503A20; 			// "CHP: "
	localparam ASCII_TXT_STL   = 40'h53544C3A20; 			// "STL: "
	localparam ASCII_TXT_0L    = 32'h304C3A20; 				// "0L: "
	localparam ASCII_TXT_1L    = 32'h314C3A20; 				// "1L: "
	localparam ASCII_TXT_BRL   = 40'h42524C3A20; 			// "BRL: "
	localparam ASCII_TXT_CLKDIV= 64'h434C4B4449563A20; 		// "CLKDIV: "
	localparam ASCII_TXT_TEST  = 48'h544553543A20; 			// "TEST: "
	localparam ASCII_LF        = 8'h0A; 					// "\n"

	// registers for values output string concat
	reg [15:0] ascii_val_dta	= DEFAULT_DATA_ASCII;
	reg [31:0] ascii_val_chp    = DEFAULT_CHP_ASCII;
	reg [39:0] ascii_val_stl    = DEFAULT_STL_ASCII;
	reg [31:0] ascii_val_0l		= DEFAULT_0L_ASCII;
	reg [31:0] ascii_val_1l     = DEFAULT_1L_ASCII;
	reg [39:0] ascii_val_brl    = DEFAULT_BRL_ASCII;
	reg [31:0] ascii_val_clkdiv = DEFAULT_CLKDIV_ASCII;

	// local variables for input value handling, only read after write to avoid latches!
	reg [15:0] recv_value;
	reg [39:0] recv_value_ascii;
	
	always@(posedge clk) begin
		comm_start <= 0;
		tx_start <= 0;

		//-------------------------------------RX HANDLER-------------------------------------
		if (btn_start == 1) begin 
			`ifdef COMM_TEST
				test_start <= ~test_start;
			`else
				comm_start <= 1;
			`endif
			tx_start <= 0;
		end
		else if (rx_fin && rx_dst == DESTINATION_COMM) begin
			case (rx_cmd)
				// COMM:START [<any number>]: starts the communication protocol with defined settings and data.
				COMMAND_START: begin
					comm_start 		<= 1;
					
					write_buffer	<= {88'h434F4D4D20535441525421, ASCII_LF, // COMM START!
										{SZ_BUF-96{1'b0}}};
					tx_count 		<= 12;
					tx_start 		<= 1;
				end
				// COMM:TEST [0/1]: enables/disables the communication test state.
				COMMAND_TEST: begin
					recv_value		 = rx_val[0];
					recv_value_ascii = bin2ascii10000(recv_value);

					test_start 		<= recv_value;
					
					write_buffer	<= {ASCII_TXT_TEST, recv_value_ascii, ASCII_LF,
										{SZ_BUF-96{1'b0}}};
					tx_count 		<= 12;
					tx_start 		<= 1;
				end
				// COMM:STATUS [<any number>]: return status message.
				COMMAND_STATUS: begin
					if (state_tx == TX_IDLE) begin //TX_IDLE check, may be unneccessary
						write_buffer <= {ASCII_TXT_DTA , ascii_val_dta , ASCII_LF, 
										ASCII_TXT_CHP  , ascii_val_chp , ASCII_LF, 
										ASCII_TXT_STL  , ascii_val_stl , ASCII_LF, 
										ASCII_TXT_0L   , ascii_val_0l  , ASCII_LF, 
										ASCII_TXT_1L   , ascii_val_1l  , ASCII_LF, 
										ASCII_TXT_BRL  , ascii_val_brl , ASCII_LF, 
										ASCII_TXT_CLKDIV, ascii_val_clkdiv , ASCII_LF, 
										{SZ_BUF-568{1'b0}}};
						tx_count <= 71;
						tx_start <= 1;
					end
				end
				// COMM:SETDTA [0..15]: sets the transmission data.
				COMMAND_SETDTA: begin
					// Example for input value handling using local variables; used for:
					// boundary checking and reusability (single definition of used bit_range and single bin2ascii() call)
					recv_value		 = rx_val[3:0];
					if (rx_val > 4'b1111)
						recv_value   = 4'b1111;
					recv_value_ascii = bin2ascii10000(recv_value);

					Data			<= recv_value;
					ascii_val_dta 	<= recv_value_ascii;

					write_buffer	<= {ASCII_TXT_DTA, recv_value_ascii, ASCII_LF,
										{SZ_BUF-88{1'b0}}};
					tx_count 		<= 11;
					tx_start 		<= 1;
				end
				// COMM:SETCHP [0..4095]: sets the amount of charge pulses.
				COMMAND_SETCHP: begin
					recv_value		 = rx_val[11:0];
					recv_value_ascii = bin2ascii10000(recv_value);

					Charge_Pulses 	<= recv_value;
					ascii_val_chp 	<= recv_value_ascii;
					
					write_buffer	<= {ASCII_TXT_CHP, recv_value_ascii, ASCII_LF,
										{SZ_BUF-88{1'b0}}};
					tx_count 		<= 11;
					tx_start 		<= 1;
				end
				// COMM:SETSTL [0..65535]: sets the start delay in microseconds.
				COMMAND_SETSTL: begin
					recv_value		 = rx_val[15:0];
					recv_value_ascii = bin2ascii10000(recv_value);

					Start_L_us 		<= recv_value;
					ascii_val_stl 	<= recv_value_ascii;

					write_buffer	<= {ASCII_TXT_STL, recv_value_ascii, ASCII_LF,
										{SZ_BUF-88{1'b0}}};
					tx_count 		<= 11;
					tx_start 		<= 1;
				end
				// COMM:SET0L [0..4095]: sets the amount of pulses for a 'zero' bit.
				COMMAND_SET0L: begin
					recv_value		 = rx_val[11:0];
					recv_value_ascii = bin2ascii10000(recv_value);

					Zero_L 			<= recv_value;
					ascii_val_0l  	<= recv_value_ascii;

					write_buffer	<= {ASCII_TXT_0L, recv_value_ascii, ASCII_LF,
										{SZ_BUF-80{1'b0}}};
					tx_count 		<= 10;
					tx_start 		<= 1;
				end
				// COMM:SET1L [0..4095]: sets the amount of pulses for a 'one' bit.
				COMMAND_SET1L: begin
					recv_value		 = rx_val[11:0];
					recv_value_ascii = bin2ascii10000(recv_value);

					One_L 			<= recv_value;
					ascii_val_1l  	<= recv_value_ascii;

					write_buffer	<= {ASCII_TXT_1L, recv_value_ascii, ASCII_LF,
										{SZ_BUF-80{1'b0}}};
					tx_count 		<= 10;
					tx_start 		<= 1;
				end
				// COMM:SETBRL [0..65535]: sets the break delay in microseconds.
				COMMAND_SETBRL: begin
					recv_value		 = rx_val[15:0];
					recv_value_ascii = bin2ascii10000(recv_value);

					Break_L_us 		<= recv_value;
					ascii_val_brl  	<= recv_value_ascii;

					write_buffer	<= {ASCII_TXT_BRL, recv_value_ascii, ASCII_LF,
										{SZ_BUF-88{1'b0}}};
					tx_count 		<= 11;
					tx_start 		<= 1;
				end
				// COMM:CLKDIV [0..511]: sets the piezo clock divider value.
				COMMAND_CLKDIV: begin
					recv_value		 = rx_val[8:0];
					recv_value_ascii = bin2ascii10000(recv_value);

					piezo_clkdiv	<= recv_value;
					ascii_val_clkdiv<= recv_value_ascii;

					write_buffer	<= {ASCII_TXT_CLKDIV, recv_value_ascii, ASCII_LF,
										{SZ_BUF-104{1'b0}}};
					tx_count 		<= 13;
					tx_start 		<= 1;
				end
				// COMP:RESET [<any number>]: resets signals
				COMMAND_RESET: begin
					Data         	<= DEFAULT_DATA;
					Charge_Pulses	<= DEFAULT_CHP;
					Start_L_us   	<= DEFAULT_STL;
					Zero_L       	<= DEFAULT_0L;
					One_L        	<= DEFAULT_1L;
					Break_L_us   	<= DEFAULT_BRL;
					piezo_clkdiv	<= DEFAULT_CLKDIV;
					ascii_val_dta	<= DEFAULT_DATA_ASCII;
					ascii_val_chp	<= DEFAULT_CHP_ASCII;
					ascii_val_stl	<= DEFAULT_STL_ASCII;
					ascii_val_0l 	<= DEFAULT_0L_ASCII;
					ascii_val_1l 	<= DEFAULT_1L_ASCII;
					ascii_val_brl	<= DEFAULT_BRL_ASCII;
					ascii_val_clkdiv<= DEFAULT_CLKDIV_ASCII;

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

	//-------------------------------------PIEZO COMM-------------------------------------

	// piezo communication protocol
	always@(posedge clk) begin

		case (state_comm)

			0: 	if (comm_start == 1 && state_test == 0) begin
					state_comm 	<= 1;
					comm_fin 	<= 0;
				end 
				else state_comm <= 0;	
			1:	begin // Send Charge Pulses
					piezo_numpulses <= Charge_Pulses;
					piezo_start_cfg_rdy	<= 1;
					piezo_start 	<= 1;
					state_comm 		<= 2;
				end
			2:	begin
					if (piezo_start_cfg_rcv == 1) begin
						piezo_start_cfg_rdy	<= 0;
						piezo_start 	<= 0;
						state_comm 		<= 3;
					end
				end
			3:	begin
					delay_us <= Start_L_us;
					if (piezo_fin == 1) begin
						delay_start <= 1;		//TODO
						state_comm 	<= 4;
					end
				end
			4:	begin
					delay_start <= 0;
					state_comm 	<= 5;
				end
			5:	begin // Wait for start signal
					if (Data[3] == 1)	piezo_numpulses <= One_L;
					else 				piezo_numpulses <= Zero_L;
					if (delay_fin == 1) begin	// send 1st Bit
						piezo_start_cfg_rdy	<= 1;
						piezo_start 	<= 1;
						state_comm 		<= 6;
					end
				end
			6:	begin
					if (piezo_start_cfg_rcv == 1) begin
						piezo_start_cfg_rdy	<= 0;
						piezo_start 	<= 0;
						state_comm 		<= 7;
					end
				end
			7:	begin 
					delay_us <= Break_L_us;
					if (piezo_fin == 1) begin
						state_comm 	<= 8;
						delay_start <= 1;
					end
				end
			8:	begin
					delay_start <= 0;
					state_comm 	<= 9;
				end
			9:	begin 
					if (Data[2] == 1)	piezo_numpulses <= One_L;
					else 				piezo_numpulses <= Zero_L;
					if (delay_fin == 1) begin 	// send 2nd Bit
						piezo_start_cfg_rdy	<= 1;
						piezo_start 	<= 1;
						state_comm 		<= 10;
					end
				end
			10:	begin
					if (piezo_start_cfg_rcv == 1) begin
						piezo_start_cfg_rdy	<= 0;
						piezo_start 	<= 0;
						state_comm 		<= 11;
					end
				end
			11:	begin 
					delay_us <= Break_L_us;
					if (piezo_fin == 1) begin
						state_comm 	<= 12;
						delay_start <= 1;
					end
				end
			12:	begin
					delay_start <= 0;
					state_comm 	<= 13;
				end
			13:	begin 
					if (Data[1] == 1)	piezo_numpulses <= One_L;
					else 				piezo_numpulses <= Zero_L;
					if (delay_fin == 1) begin 	// send 3rd Bit
						piezo_start_cfg_rdy	<= 1;
						piezo_start 	<= 1;
						state_comm 		<= 14;
					end
				end
			14:	begin
					if (piezo_start_cfg_rcv == 1) begin
						piezo_start_cfg_rdy	<= 0;
						piezo_start 	<= 0;
						state_comm 		<= 15;
					end
				end
			15:	begin 
					delay_us <= Break_L_us;
					if (piezo_fin == 1) begin
						state_comm 	<= 16;
						delay_start <= 1;
					end
				end
			16:	begin
					delay_start <= 0;
					state_comm 	<= 17;
				end
			17:	begin 
					delay_start <= 0;
					if(Data[0] == 1) 	piezo_numpulses <= One_L;
					else 				piezo_numpulses <= Zero_L;
					if (delay_fin == 1) begin 	// send 4th Bit
						piezo_start_cfg_rdy	<= 1;
						piezo_start 	<= 1;
						state_comm 		<= 18;
					end
				end
			18:	begin
					if (piezo_start_cfg_rcv == 1) begin
						piezo_start_cfg_rdy	<= 0;
						piezo_start 	<= 0;
						state_comm 		<= 19;
					end
				end
			19:	begin 
					if (piezo_fin == 1) begin
						state_comm 	<= 0;
						comm_fin 	<= 1;
					end
				end
		endcase

		case (state_test)
			0: begin
				if (test_start == 1 && state_comm == 0 && comm_start == 0) begin
					piezo_start 	<= 1;
					piezo_start_cfg_rdy	<= 1;
					state_test 		<= 2;
				end
			end
			1: begin
				if (piezo_fin == 1 && test_start == 1) begin
					piezo_numpulses <= Charge_Pulses;
					piezo_start 	<= 1;
					piezo_start_cfg_rdy	<= 1;
					state_test 		<= 2;
				end
				if (piezo_fin == 1 && test_start == 0) begin
					state_test <= 0;
				end
			end
			2: begin
				if (piezo_start_cfg_rcv == 1) begin
					piezo_start_cfg_rdy	<= 0;
					piezo_start 	<= 0;
					state_test 		<= 1;
				end
			end
		endcase
	end

endmodule
