`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: TU Darmstadt - Integrierte Elektronische Systeme
// Engineer: Malte Nilges
// 
// Create Date: 05.02.2023 16:40:56
// Design Name: 
// Module Name: adc_driver
// Project Name: Piezo_TestPlatform
// Target Devices: XC7S25
// Tool Versions: 2022.2
// Description: 
//	Module for ADC configuration, data acqusition and transmission
// 
// Dependencies: 
//	adc_mmcme2_top.v
//	fifo_aggregate.v
//	fifo_x2byte.v
//	pulse_stretcher.v
//	serial_defines.hv
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adc_driver #(
	parameter DEFAULT_POWER  = 1'b0, 		parameter DEFAULT_POWER_ASCII	= 8'h30, 
	parameter DEFAULT_TRIG   = 1'b0, 		parameter DEFAULT_TRIG_ASCII 	= 8'h30, 
	parameter DEFAULT_THOLD  = 8'd200, 		parameter DEFAULT_THOLD_ASCII	= 24'h323030,
	parameter DEFAULT_MAXSMP = 16'd40000, 	parameter DEFAULT_MAXSMP_ASCII  = 40'h3430303030,
	parameter DEFAULT_WIDTH	 = 4'd5, 		parameter DEFAULT_WIDTH_ASCII  	= 16'h35,
	parameter DEFAULT_FREQ   = 14'd5000, 	parameter DEFAULT_FREQ_ASCII	= 40'h35303030		// 250..10000 [kHz] in 250 [kHz] steps
) (
	// clk input and clk_adc output
    input wire clk,
	output wire clk_adc,

	// adc input (signed K2)
    input wire signed [9:0] adc_in,

	// trigger output for external triggering elsewhere
	output wire trigger_out,
    
	// serial input
	input wire [2:0] rx_dst,
	input wire [3:0] rx_cmd,
	input wire [15:0] rx_val,
	input wire rx_fin,

	// serial output
	input wire tx_ready,
	output reg tx_valid,
	output reg [7:0] tx_data,

	// enable pin driver (~enable)
	output reg adc_en = ~DEFAULT_POWER
);
	`include "serial_defines.hv"

	localparam DEFAULT_FREQSTATE = (DEFAULT_FREQ / 250) - 1;	// freq_state for mmcme2_drp state machine
	localparam FIFO_WIDTH_BYTES = 6;							// width of a fifo word (change may require changing bram_fifo depth to meet fpga specs)
	localparam FIFO_WIDTH = FIFO_WIDTH_BYTES * 8;				
	localparam MAX_SAMPLE_WIDTH = 10;							// fixed value based on board and adc

	localparam TX_IDLE = 3'd0;
	localparam TX_STRM = 3'd1;
	localparam TX_OFFR = 3'd2;
	localparam TX_WAIT = 3'd3;
	localparam SZ_BUF = 536;

	integer ii;

	reg reset = 1'b1;
	reg [5:0]  freq_state 	= DEFAULT_FREQSTATE;

	//-------------------------------------CLK WIZARD-------------------------------------
	// 
	// Changes the frequency on freq_state and freq_update input. Keep freq_update high for
	// only one cycle.
	// Additional reset generation for BRAM fifo for frequency change (TODO: needed?, initial rst?)

	adc_clkgen  u_adc_clkgen (
		.SSTEP                   ( freq_update  ),
		.STATE                   ( freq_state   ),
		.RST                     ( 1'b0         ),
		.CLKIN                   ( clk          ),

		.LOCKED_OUT              ( freq_locked  ),
		.CLK_ADC                 ( clk_adc      )
	);

	wire reset_w = freq_update | reset;

	// freq_update
	wire reset_w_stretched;

	pulse_stretcher #(
		.NUM_STRETCH_CYCLES(4000) // long stretching for long enough reset
	) u_pulse_stretcher_freq_update (
		.clk		(clk),
		.pulse_src	(reset_w),
		.pulse_dst	(reset_w_stretched)
	);

	//trigger_out
	xpm_cdc_single #( // version 2020.2
		.DEST_SYNC_FF	(2),	// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),	// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.SIM_ASSERT_CHK	(0),	// DECIMAL; 0=disable simulation messages, 1=enable simulation messages 
		.SRC_INPUT_REG	(0)		// DECIMAL; 0=do not register input, 1=register input
	) u_cdc_bram_reset ( 
		.dest_out	(bram_reset),			// 1-bit output: src_in synchronized to the destination clock domain. This output is registered. 
		.dest_clk	(clk_adc),				// 1-bit input: Clock signal for the destination clock domain. 
		.src_clk	(clk),					// 1-bit input: optional; required when SRC_INPUT_REG = 1 
		.src_in		(reset_w_stretched)	// 1-bit input: Input signal to be synchronized to dest_clk domain.
	);
	

	//-------------------------------------RX/TX HANDLING-------------------------------------
	//
	// RX/TX handling via buttons and serial communication.

	reg [2:0] 		 state_tx 	  = TX_IDLE;
	reg [SZ_BUF-1:0] write_buffer = 0;
	reg [5:0]		 tx_count	  = 0;
	reg 			 tx_start  	  = 0;


	reg trigger 			= DEFAULT_TRIG;
	reg signed [MAX_SAMPLE_WIDTH-1:0] trigger_threshold = DEFAULT_THOLD;
	reg [15:0] max_samples 	= DEFAULT_MAXSMP;
	reg [3:0]  width		= DEFAULT_WIDTH;
	reg force_single 		= 1'b0;
	reg freq_update 		= 1'b1;
	reg config_rdy			= 1'b0;
	wire freq_locked;

	localparam STRING_VAL_DFLT  = 40'h44464C54;		// "DFLT", unused
	
	// local variables for text output string concat
	wire [55:0] ascii_txt_power  	= 56'h504F5745523A20;	// "POWER: "
	wire [47:0] ascii_txt_trig  	= 48'h545249473A20;		// "TRIG: "
	wire [55:0] ascii_txt_thold 	= 56'h54484F4C443A20; 	// "THOLD: "
	wire [63:0] ascii_txt_maxsmp  	= 64'h4D4158534D503A20; // "MAXSMP: "
	wire [55:0] ascii_txt_width 	= 56'h57494454483A20; 	// "WIDTH: "
	wire [47:0] ascii_txt_freq 		= 48'h465245513A20; 	// "FREQ: "
	wire [7:0]  ascii_lf        	= 8'h0A;	 			// "\n"

	// registers for values output string concat
	reg [7:0] ascii_val_trig		= DEFAULT_TRIG_ASCII;
	reg [7:0] ascii_val_power		= DEFAULT_POWER_ASCII;
	reg [23:0] ascii_val_thold		= DEFAULT_THOLD_ASCII;
	reg [39:0] ascii_val_maxsmp		= DEFAULT_MAXSMP_ASCII;
	reg [15:0] ascii_val_width		= DEFAULT_WIDTH_ASCII;
	reg [39:0] ascii_val_freq		= DEFAULT_FREQ_ASCII;

	// local variables for input value handling, only read after write to avoid latches!
	reg [15:0] recv_value;
	reg [39:0] recv_value_ascii;
	
	always@(posedge clk) begin

		// reset pulses
		force_single			<= 1'b0;
		config_rdy				<= 1'b0;
		tx_start				<= 1'b0;
		reset 					<= 1'b0;
		if (freq_locked == 1)
			freq_update			<= 1'b0;

		// rx handler
		if (rx_fin && rx_dst == DESTINATION_ADC) begin
			case (rx_cmd)
				COMMAND_POWER: begin
					recv_value		 = rx_val[0];
					recv_value_ascii = bin2ascii10000(recv_value);

					adc_en 			<= ~recv_value;
					ascii_val_power <= recv_value_ascii;
					
					write_buffer	<= {ascii_txt_power, recv_value_ascii, ascii_lf,
										{SZ_BUF-104{1'b0}}};
					tx_count 		<= 13;
					tx_start 		<= 1;
				end
				COMMAND_STATUS: begin
					if (state_tx == TX_IDLE) begin
						write_buffer <= {ascii_txt_power, ascii_val_power, ascii_lf,
										 ascii_txt_trig, ascii_val_trig , ascii_lf, 
										 ascii_txt_thold, ascii_val_thold , ascii_lf, 
										 ascii_txt_maxsmp, ascii_val_maxsmp , ascii_lf,
										 ascii_txt_width, ascii_val_width, ascii_lf, 
										 ascii_txt_freq, ascii_val_freq, ascii_lf, 
										 {SZ_BUF-528{1'b0}}};
						tx_start <= 1;
						tx_count <= 66;
					end
				end
				COMMAND_TRIG: begin
					recv_value		 = rx_val[0];
					recv_value_ascii = bin2ascii10000(recv_value);

					trigger 		<= recv_value;
					config_rdy 		<= 1'b1;
					ascii_val_trig 	<= recv_value_ascii;
					
					write_buffer	<= {ascii_txt_trig, recv_value_ascii, ascii_lf,
										{SZ_BUF-96{1'b0}}};
					tx_count 		<= 12;
					tx_start 		<= 1;
				end
				COMMAND_THOLD: begin
					recv_value		 = rx_val[MAX_SAMPLE_WIDTH-1:0];
					recv_value_ascii = bin2ascii10000(recv_value);

					trigger_threshold		<= recv_value;
					config_rdy 				<= 1'b1;
					ascii_val_thold 		<= recv_value_ascii;
					
					write_buffer	<= {ascii_txt_thold, recv_value_ascii, ascii_lf,
										{SZ_BUF-104{1'b0}}};
					tx_count 		<= 13;
					tx_start 		<= 1;
				end
				COMMAND_MAXSMP: begin
					recv_value		 = rx_val[15:0];
					recv_value_ascii = bin2ascii10000(recv_value);

					max_samples 		<= recv_value;
					config_rdy 			<= 1'b1;
					ascii_val_maxsmp 	<= recv_value_ascii;
					
					write_buffer	<= {ascii_txt_maxsmp, recv_value_ascii, ascii_lf,
										{SZ_BUF-112{1'b0}}};
					tx_count 		<= 14;
					tx_start 		<= 1;
				end
				COMMAND_FORCE: begin
					force_single <= 1'b1;

					write_buffer	<= {96'h464F5243452053494E474C45, ascii_lf, // "FORCE SINGLE"
										{SZ_BUF-104{1'b0}}};
					tx_count 		<= 13;
					tx_start 		<= 1;
				end
				COMMAND_FREQ: begin
					recv_value		 = rx_val;
					recv_value_ascii = 'h494E56; // "INV"

					for (ii = 1; ii <= 40; ii = ii + 1) begin
						if (recv_value == (ii * 250)) begin
							recv_value_ascii	= bin2ascii10000(recv_value);

							freq_state			<= ii - 1;
							freq_update			<= 1'b1;
							ascii_val_freq		<= recv_value_ascii;
						end
					end

					write_buffer	<= {ascii_txt_freq, recv_value_ascii, ascii_lf,
										{SZ_BUF-96{1'b0}}};
					tx_count 		<= 12;
					tx_start 		<= 1;
				end
				COMMAND_WIDTH: begin
					recv_value		 = rx_val[3:0];
					if (recv_value > 4'd10)
						recv_value	 = 4'd10;
					recv_value_ascii = bin2ascii10000(recv_value);

					width 				<= recv_value;
					config_rdy 			<= 1'b1;
					ascii_val_width 	<= recv_value_ascii;
					
					write_buffer	<= {ascii_txt_width, recv_value_ascii, ascii_lf,
										{SZ_BUF-80{1'b0}}};
					tx_count 		<= 10;
					tx_start 		<= 1;
				end
				COMMAND_RESET: begin
					reset <= 1;

					write_buffer	<= {64'h5245534554204F4B, ascii_lf, // RESET OK
										{SZ_BUF-72{1'b0}}};
					tx_count 		<= 9;
					tx_start 		<= 1;
				end
			endcase
		end

		// tx handler
		case (state_tx)
			TX_IDLE: begin
				if (tx_start) begin	
					state_tx 			<= #1 TX_OFFR;
				end
				else if (outfifo_vld && !reset_w_stretched) begin
					state_tx 			<= #1 TX_STRM;
					// tx_valid			<= #1 1'b1;
					// tx_data				<= #1 sample_stream;
					// send_sample_stream	<= #1 1'b1;
				end
				else begin
					state_tx			<= #1 TX_IDLE;
				end
			end
			TX_STRM: begin
				send_sample_stream 		<= #1 1'b0;
				if (outfifo_vld == 1 && !reset_w_stretched) begin
					tx_valid			<= #1 1'b1;
					tx_data				<= #1 sample_stream;
					if (tx_ready) begin
						send_sample_stream	<= #1 1'b1;
					end
				end
				else begin
					tx_valid			<= #1 1'b0;
					state_tx			<= #1 TX_IDLE;
				end
			end
			// TX_STRM: begin
			// 	send_sample_stream	<= #1 1'b0;
			// 	if (tx_ready == 1) begin
			// 		if (outfifo_vld == 1) begin
			// 			tx_valid			<= #1 1'b1;
			// 			tx_data				<= #1 sample_stream;
			// 			send_sample_stream	<= #1 1'b1;
			// 		end
			// 		else begin
			// 			tx_valid			<= #1 1'b0;
			// 			state_tx			<= #1 TX_IDLE;
			// 		end
			// 	end
			// end
			// TX_OFFR: begin
			// 	if (tx_count != 0) begin  								// if write_buffer not empty,
			// 		tx_valid 	<= #1 1;                              	// offer tx_data
			// 		tx_data 	<= #1 write_buffer[SZ_BUF-1:SZ_BUF-8];
			// 		state_tx 	<= #1 TX_WAIT;                          // change to wait state
			// 	end
			// 	else begin
			// 		state_tx 	<= #1 TX_IDLE;
			// 		tx_valid 	<= #1 0;
			// 	end
			// end
			TX_OFFR: begin
				if (tx_count > 0) begin	
					tx_data 	<= #1 write_buffer[SZ_BUF-1:SZ_BUF-8];
					tx_valid	<= 1;
					if (tx_ready) begin
						write_buffer <= #1 write_buffer << 8;
						tx_count <= #1 tx_count - 1;
					end
				end
				else begin
					tx_valid	<= #1 0;
					state_tx	<= #1 TX_IDLE;
				end
			end
			TX_WAIT: begin
				if (tx_ready) begin                                 // if tx accepted the byte
					// write_buffer <= write_buffer << tx_shift_amount;// left-shift write buffer to select next byte
					write_buffer <= #1 write_buffer << 8;
					state_tx <= #1 TX_OFFR;                            // and change to offer state
					tx_count <= #1 tx_count - 1;
				end
			end
		endcase

	end

	//-------------------------------------ADC CONTROL-------------------------------------

	reg signed [MAX_SAMPLE_WIDTH-1:0] trigger_threshold_adc = DEFAULT_THOLD;
	reg [15:0] max_samples_adc 	= DEFAULT_MAXSMP;
	reg [3:0] width_adc 		= DEFAULT_WIDTH;
	reg trigger_adc 			= DEFAULT_TRIG;
	wire force_single_adc;
	
	reg trigger_out_adc 	= 1'b0;

	reg [1:0] state_sample 	= 2'b0;
	reg [17:0] sample_count = 18'b0;
	reg triggered			= 1'b0;

	always@(posedge clk_adc) begin
		sample_in_vld	<= 1'b0;
		triggered 		<= 1'b0;
		case (state_sample)
			0: begin
				if (force_single_adc || (trigger_adc && adc_in_sim > trigger_threshold_adc) || triggered) begin
					if (sample_count > 0 && !bram_full) begin
						sample_in		<= adc_in_sim >> (MAX_SAMPLE_WIDTH - width_adc);
						sample_in_vld	<= 1'b1;
						triggered 		<= 1'b1;
						sample_count	<= sample_count - 1;
					end
					else begin
						sample_in_vld	<= 1'b0;
						triggered 		<= 1'b0;
						sample_count	<= 1'b0;
					end
				end
				else begin
					sample_in_vld		<= 1'b0;
				end
			end
		endcase

		if (sample_count == 0) begin
			if (max_samples_adc == 0)
				sample_count <= {18{1'b1}};
			else
				sample_count <= max_samples_adc;
		end
	end
	
	always @(posedge clk_adc) begin
		if (adc_in >= trigger_threshold_adc)
			trigger_out_adc <= 1;
		else
			trigger_out_adc <= 0;
	end

	//--------------------------------SIGNAL SYNCHRONIZATION--------------------------------
	//
	// Signals for configuration and commands received via serial communication or buttons 
	// are transferred to the adc clock domain.
	// trigger_out signal from the synchronous to the adc clock domain is transferred to the
	// system clock domain.
	
	// config
	localparam CONFIG_WIDTH = MAX_SAMPLE_WIDTH+16+4+1;
	wire [CONFIG_WIDTH-1:0] config_w = {trigger_threshold, max_samples, width, trigger};
	wire [CONFIG_WIDTH-1:0] config_adc_w;
	wire config_adc_vld;
	
	xpm_cdc_handshake #( // version 2020.2
		.DEST_EXT_HSK	(0),			// DECIMAL; 0=internal handshake, 1=external handshake 
		.DEST_SYNC_FF	(2),			// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),			// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.SIM_ASSERT_CHK	(0),			// DECIMAL; 0=disable simulation messages, 1=enable simulation messages 
		.SRC_SYNC_FF	(2),			// DECIMAL; range: 2-10 
		.WIDTH			(CONFIG_WIDTH)	// DECIMAL; range: 1-1024
	) u_cdc_trigger_threshold ( 
		.dest_out	(config_adc_w),		// WIDTH-bit output: Input bus (src_in) synchronized to destination clock domain.  This output is registered. 
		.dest_req	(config_adc_vld),	// 1-bit output: Assertion of this signal indicates that new dest_out data has been  received and is ready to be used or captured by the destination logic. When  DEST_EXT_HSK = 1, this signal will deassert once the source handshake  acknowledges that the destination clock domain has received the transferred data.  When DEST_EXT_HSK = 0, this signal asserts for one clock period when dest_out bus  is valid. This output is registered. 
		.src_rcv	(),					// 1-bit output: Acknowledgement from destination logic that src_in has been  received. This signal will be deasserted once destination handshake has fully  completed, thus completing a full data transfer. This output is registered. 
		.dest_ack	(),					// 1-bit input: optional; required when DEST_EXT_HSK = 1 
		.dest_clk	(clk_adc),			// 1-bit input: Destination clock. 
		.src_clk	(clk),				// 1-bit input: Source clock. 
		.src_in		(config_w),			// WIDTH-bit input: Input bus that will be synchronized to the destination clock  domain. 
		.src_send	(config_rdy)		// 1-bit input: Assertion of this signal allows the src_in bus to be synchronized to  the destination clock domain. This signal should only be asserted when src_rcv is  deasserted, indicating that the previous data transfer is complete. This signal  should only be deasserted once src_rcv is asserted, acknowledging that the src_in  has been received by the destination logic.
	);

	always @(posedge clk_adc) begin
		if (config_adc_vld) begin
			trigger_adc				<= config_adc_w[0];
			width_adc				<= config_adc_w[4:1];
			max_samples_adc			<= config_adc_w[20:5];
			trigger_threshold_adc 	<= config_adc_w[MAX_SAMPLE_WIDTH-1+21:21];
		end
	end

	// force_single
	wire force_single_stretched;

	pulse_stretcher #(
		.NUM_STRETCH_CYCLES(100) // ~ two periods @ 250 kHz (slowest sampling period)
	) u_pulse_stretcher_force_single (
		.clk		(clk),
		.pulse_src	(force_single),
		.pulse_dst	(force_single_stretched)
	);
 
	xpm_cdc_pulse #( // version 2020.2
		.DEST_SYNC_FF	(2),   	// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),   	// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.REG_OUTPUT		(0),    // DECIMAL; 0=disable registered output, 1=enable registered output 
		.RST_USED		(0),	// DECIMAL; 0=no reset, 1=implement reset 
		.SIM_ASSERT_CHK	(0)  	// DECIMAL; 0=disable simulation messages, 1=enable simulation messages
	) u_cdc_force_single ( 
		.dest_pulse	(force_single_adc),			// 1-bit output: Outputs a pulse the size of one dest_clk period when a pulse  transfer is correctly initiated on src_pulse input. This output is combinatorial unless REG_OUTPUT is set to 1.
		.dest_clk	(clk_adc),     				// 1-bit input: Destination clock. 
		.dest_rst	(),     					// 1-bit input: optional; required when RST_USED = 1 
		.src_clk	(clk),      				// 1-bit input: Source clock. 
		.src_pulse	(force_single_stretched),	// 1-bit input: Rising edge of this signal initiates a pulse transfer to the  destination clock domain. The minimum gap between each pulse transfer must be at the minimum 2*(larger(src_clk period, dest_clk period)). This is measured  between the falling edge of a src_pulse to the rising edge of the next  src_pulse.
		.src_rst	()   						// 1-bit input: optional; required when RST_USED = 1
	);

	//trigger_out
	xpm_cdc_single #( // version 2020.2
		.DEST_SYNC_FF	(2),	// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),	// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.SIM_ASSERT_CHK	(0),	// DECIMAL; 0=disable simulation messages, 1=enable simulation messages 
		.SRC_INPUT_REG	(0)		// DECIMAL; 0=do not register input, 1=register input
	) u_cdc_trigger_out ( 
		.dest_out	(trigger_out),		// 1-bit output: src_in synchronized to the destination clock domain. This output is registered. 
		.dest_clk	(clk),				// 1-bit input: Clock signal for the destination clock domain. 
		.src_clk	(clk_adc),			// 1-bit input: optional; required when SRC_INPUT_REG = 1 
		.src_in		(trigger_out_adc)	// 1-bit input: Input signal to be synchronized to dest_clk domain.
	);

	
	//-------------------------------------FIFO CHAIN-------------------------------------
	//
	// Input is buffered and aggregated into the infifo, pushed into bram, and pulled and 
	// seperated via the outfifo for data transfer over the serial line.
	// Advantages:  - increased sampling time
	//				- clock domain crossing
	//				- adjustable sampling frequency and sample width during runtime


	reg [MAX_SAMPLE_WIDTH-1:0] sample_in = 0;
	reg sample_in_vld = 0;
	wire [FIFO_WIDTH-1:0] infifo_data;
	wire infifo_vld;

	wire [FIFO_WIDTH-1:0] bram_data;
	wire bram_empty;
	wire bram_full;
	wire bram_vld = ~bram_empty;
	wire bram_rdy = ~bram_full;
	wire bram_rd_rst_busy;

	wire [7:0] sample_stream;
	wire outfifo_empty; 
	wire outfifo_full;
	wire outfifo_vld = ~outfifo_empty;
	wire outfifo_rdy = ~outfifo_full & ~bram_reset & ~bram_rd_rst_busy;

	reg send_sample_stream = 0;

	
	fifo_aggregate #(
		.MAX_INPUT_WIDTH    ( MAX_SAMPLE_WIDTH  ),
		.OUTPUT_WIDTH_BYTES ( FIFO_WIDTH_BYTES  ))
	u_infifo (
		.clk               	( clk_adc         	),
		.rst               	( reset_w_stretched ),
		.input_width       	( width_adc			),
		.wr_en             	( sample_in_vld     ),
		.data_in           	( sample_in    		),
		.data_out          	( infifo_data 		),
		.full              	( infifo_vld    	)
	);


	// xpm_fifo_async: Asynchronous FIFO
	// Xilinx Parameterized Macro, version 2020.2
	xpm_fifo_async #(
		.CDC_SYNC_STAGES		(2),       		// DECIMAL
		.DOUT_RESET_VALUE		("0"),    		// String
		.ECC_MODE				("no_ecc"),		// String
		.FIFO_MEMORY_TYPE		("block"), 		// String
		.FIFO_READ_LATENCY		(0),     		// DECIMAL
		.FIFO_WRITE_DEPTH		(16384),   		// DECIMAL
		.FULL_RESET_VALUE		(0),      		// DECIMAL
		.PROG_EMPTY_THRESH		(10),    		// DECIMAL
		.PROG_FULL_THRESH		(10),     		// DECIMAL
		.RD_DATA_COUNT_WIDTH	(1),   			// DECIMAL
		.READ_DATA_WIDTH		(FIFO_WIDTH),	// DECIMAL
		.READ_MODE				("fwft"),		// String
		.RELATED_CLOCKS			(0),        	// DECIMAL
		.SIM_ASSERT_CHK			(0),        	// DECIMAL; 0=disable simulation messages, 1=enable simulation messages
		.USE_ADV_FEATURES		("0000"), 		// String
		.WAKEUP_TIME			(0),           	// DECIMAL
		.WRITE_DATA_WIDTH		(FIFO_WIDTH),  	// DECIMAL
		.WR_DATA_COUNT_WIDTH	(1)    			// DECIMAL
	) u_bramfifo (
		.almost_empty			(),   			// 1-bit output: Almost Empty : When asserted, this signal indicates that  only one more read can be performed before the FIFO goes to empty.
		.almost_full			(),     		// 1-bit output: Almost Full: When asserted, this signal indicates that  only one more write can be performed before the FIFO is full.
		.data_valid				(),       		// 1-bit output: Read Data Valid: When asserted, this signal indicates  that valid data is available on the output bus (dout).
		.dbiterr				(),             // 1-bit output: Double Bit Error: Indicates that the ECC decoder detected  a double-bit error and data in the FIFO core is corrupted.
		.dout					(bram_data),	// READ_DATA_WIDTH-bit output: Read Data: The output data bus is driven  when reading the FIFO.
		.empty					(bram_empty),   // 1-bit output: Empty Flag: When asserted, this signal indicates that the  FIFO is empty. Read requests are ignored when the FIFO is empty,  initiating a read while empty is not destructive to the FIFO.
		.full					(bram_full),    // 1-bit output: Full Flag: When asserted, this signal indicates that the  FIFO is full. Write requests are ignored when the FIFO is full,  initiating a write when the FIFO is full is not destructive to the  contents of the FIFO.
		.overflow				(),           	// 1-bit output: Overflow: This signal indicates that a write request  (wren) during the prior clock cycle was rejected, because the FIFO is  full. Overflowing the FIFO is not destructive to the contents of the  FIFO.
		.prog_empty				(),       		// 1-bit output: Programmable Empty: This signal is asserted when the  number of words in the FIFO is less than or equal to the programmable  empty threshold value. It is de-asserted when the number of words in  the FIFO exceeds the programmable empty threshold value.
		.prog_full				(),         	// 1-bit output: Programmable Full: This signal is asserted when the  number of words in the FIFO is greater than or equal to the  programmable full threshold value. It is de-asserted when the number of  words in the FIFO is less than the programmable full threshold value.
		.rd_data_count			(), 			// RD_DATA_COUNT_WIDTH-bit output: Read Data Count: This bus indicates the  number of words read from the FIFO.
		.rd_rst_busy			(bram_rd_rst_busy),     		// 1-bit output: Read Reset Busy: Active-High indicator that the FIFO read  domain is currently in a reset state.
		.sbiterr				(),             // 1-bit output: Single Bit Error: Indicates that the ECC decoder detected  and fixed a single-bit error.
		.underflow				(),         	// 1-bit output: Underflow: Indicates that the read request (rd_en) during  the previous clock cycle was rejected because the FIFO is empty. Under  flowing the FIFO is not destructive to the FIFO.
		.wr_ack					(),             // 1-bit output: Write Acknowledge: This signal indicates that a write  request (sample_in_vld) during the prior clock cycle is succeeded.
		.wr_data_count			(), 			// WR_DATA_COUNT_WIDTH-bit output: Write Data Count: This bus indicates  the number of words written into the FIFO.
		.wr_rst_busy			(),     		// 1-bit output: Write Reset Busy: Active-High indicator that the FIFO  write domain is currently in a reset state.
		.din					(infifo_data),  // WRITE_DATA_WIDTH-bit input: Write Data: The input data bus used when  writing the FIFO.
		.injectdbiterr			(1'b0), 		// 1-bit input: Double Bit Error Injection: Injects a double bit error if  the ECC feature is used on block RAMs or UltraRAM macros.
		.injectsbiterr			(1'b0), 		// 1-bit input: Single Bit Error Injection: Injects a single bit error if  the ECC feature is used on block RAMs or UltraRAM macros.
		.rd_clk					(clk),          // 1-bit input: Read clock: Used for read operation. rd_clk must be a free  running clock.
		.rd_en					(outfifo_rdy),  // 1-bit input: Read Enable: If the FIFO is not empty, asserting this  signal causes data (on dout) to be read from the FIFO. Must be held  active-low when rd_rst_busy is active high.
		.rst					(bram_reset),   // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be  unstable at the time of applying reset, but reset must be released only  after the clock(s) is/are stable.
		.sleep					(1'b0),         // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo  block is in power saving mode.
		.wr_clk					(clk_adc),      // 1-bit input: Write clock: Used for write operation. wr_clk must be a  free running clock.
		.wr_en					(infifo_vld)    // 1-bit input: Write Enable: If the FIFO is not full, asserting this  signal causes data (on din) to be written to the FIFO. Must be held  active-low when rst or wr_rst_busy is active high.
	);

	fifo_x2byte #(
		.INPUT_WIDTH_BYTES ( FIFO_WIDTH_BYTES	),
		.FIFO_DEPTH_INPUT  ( 2 	                ))
	u_outfifo (
		.clk     		( clk                 	),
		.rst     		( reset_w_stretched		),
		.rd_en   		( send_sample_stream	),
		.wr_en   		( bram_vld       		),
		.data_in 		( bram_data    			),
		.data_out		( sample_stream       	),
		.full    		( outfifo_full         	),
		.empty   		( outfifo_empty        	)
	);

	// // serial_tx simulation
	// reg [4:0] simcounter = 0;
	// always @(posedge clk) begin
	// 	send_sample_stream <= 0;
	// 	if (simcounter == 0 && outfifo_vld) begin
	// 		simcounter <= 9;
	// 		send_sample_stream <= 1;
	// 	end
	// 	if (simcounter > 0) begin
	// 		simcounter <= simcounter - 1;
	// 	end
	// end
	
	// input simulation
	reg signed [9:0] adc_in_sim = 0;
	always @(posedge clk_adc) begin
		adc_in_sim <= adc_in_sim + 1;
		if (adc_en) adc_in_sim <= trigger_threshold_adc;
	end


endmodule
