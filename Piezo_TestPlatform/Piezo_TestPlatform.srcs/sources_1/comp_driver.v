`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2023 16:38:20
// Design Name: 
// Module Name: comparator_driver
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


module comparator_driver #(
	parameter DEFAULT_POWER  = 1'b0, 		parameter DEFAULT_POWER_ASCII	= 8'h30, 
	parameter DEFAULT_TRIG   = 1'b0, 		parameter DEFAULT_TRIG_ASCII 	= 8'h30, 
	parameter DEFAULT_MAXSMP = 16'd40000, 	parameter DEFAULT_MAXSMP_ASCII  = 40'h3430303030,
	parameter DEFAULT_WIDTH	 = 5'd20, 		parameter DEFAULT_WIDTH_ASCII  	= 16'h3230
	// parameter DEFAULT_FREQ   = 14'd100, 	parameter DEFAULT_FREQ_ASCII	= 32'h313030		// 25, 50, 100, 200, 300, 400 MHz
) (
    input wire clk,

	// comparator input
    input wire comp_in,

	// trigger input from adc
	input wire trigger_in,
    
	// serial input
	input wire [2:0] rx_dst,
	input wire [3:0] rx_cmd,
	input wire [15:0] rx_val,
	input wire rx_fin,

	// serial output
	input wire tx_ready,
	output reg tx_valid,
	output reg [7:0] tx_data,
	
	// enable pin driver
	output reg comp_en = DEFAULT_POWER
);
	`include "serial_defines.hv"

	localparam DEFAULT_FREQ			=	100;
	localparam DEFAULT_FREQ_ASCII	=	32'h313030;
	localparam DEFAULT_FREQSTATE 	= 	DEFAULT_FREQ == 400 ? 0 :
										DEFAULT_FREQ == 300 ? 1 :
										DEFAULT_FREQ == 200 ? 2 :
										DEFAULT_FREQ == 100 ? 3 :
										DEFAULT_FREQ ==  50 ? 4 :
										DEFAULT_FREQ ==  25 ? 5 :
										5;						// freq_state for mmcme2_drp state machine
	localparam FIFO_WIDTH_BYTES 	= 6;						// width of a fifo word (change may require changing bram_fifo depth to meet fpga specs)
	localparam FIFO_WIDTH 			= FIFO_WIDTH_BYTES * 8;				
	localparam MAX_COUNT_WIDTH 		= 22;						

	integer ii;

	//-------------------------------------RESET------------------------------------------
	//
	// Reset signal handling.
	// Currently reset_w is applied if frequency is updated or sample streaming is finished.
	// Mainly used to clear FIFOs in order to clear unfilled data (remaining in infifo) and
	// specified usage of BRAM in case of frequency change
	// no pulse stretching -> manually ensure that clk_comp > 2*clk for proper sampling or
	//						  stretch pulse otherwise

	reg  reset 		= 1'b1;
	wire reset_w 	= reset; // || freq_update
	wire reset_w_comp;

	xpm_cdc_single #( // version 2020.2
		.DEST_SYNC_FF	(2),	// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),	// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.SIM_ASSERT_CHK	(0),	// DECIMAL; 0=disable simulation messages, 1=enable simulation messages 
		.SRC_INPUT_REG	(0)		// DECIMAL; 0=do not register input, 1=register input
	) u_cdc_reset ( 
		.dest_out	(reset_w_comp),	// 1-bit output: src_in synchronized to the destination clock domain. This output is registered. 
		.dest_clk	(clk_comp),		// 1-bit input: Clock signal for the destination clock domain. 
		.src_clk	(),				// 1-bit input: optional; required when SRC_INPUT_REG = 1 
		.src_in		(reset_w)		// 1-bit input: Input signal to be synchronized to dest_clk domain.
	);

	//-------------------------------------CLK WIZARD-------------------------------------
	// 
	// Optional: Changes the frequency on freq_state and freq_update input. Keep freq_update high for
	// only one cycle.
	// To enable remove comments and comment out "CLK FIXED" section. Needs rewrite of the freq_states, 
	// as the respective frequencies are too large (up to 400 MHz, can't meet timing)

	reg [2:0]  freq_state 	= DEFAULT_FREQSTATE;

	// comp_clkgen  u_comp_clkgen (
	// 	.SSTEP                   ( freq_update  ),
	// 	.STATE                   ( freq_state   ),
	// 	.RST                     ( 1'b0         ),
	// 	.CLKIN                   ( clk          ),

	// 	.LOCKED_OUT              ( freq_locked  ),
	// 	.CLK_COMP                ( clk_comp     )
	// );
	
	//-------------------------------------CLK FIXED-------------------------------------
	//
	// Fixed sampling clock set to 25 MHz. 
	// Increase in frequency may require larger cycle_counter reg and fifo_aggregate input_width in order
	// to avoid cycle counting overflow.

    wire            clkin_buf;
    wire            clk_feedback_buf;
    wire            clk_feedback_unbuf;
    wire            clk_comp_unbuf;
    wire            clk_comp_buf;
	wire 			clk_comp;

    assign clkin_buf = clk;
    BUFG BUFG_FB    (.I (clk_feedback_unbuf), .O (clk_feedback_buf));
    BUFG BUFG_CLK0  (.I (clk_comp_unbuf), .O (clk_comp_buf));
    assign clk_comp = clk_comp_buf;

    MMCME2_BASE #(   // Xilinx HDL Language Template, version 2021.2
    .BANDWIDTH("OPTIMIZED"),        // OPTIMIZED, HIGH, LOW
    .CLKFBOUT_MULT_F    (62.5),     // Multiply value for all CLKOUT (2.000-64.000).
    .CLKFBOUT_PHASE     (0.0),      // Phase offset in degrees of CLKFB, (-360.000-360.000).
    .CLKIN1_PERIOD      (83.333),   // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
    .CLKOUT0_DIVIDE_F   (15.000),
    .CLKOUT0_DUTY_CYCLE (0.5),
    .CLKOUT0_PHASE      (0.0),
    .CLKOUT4_CASCADE	("FALSE"),      // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
    .DIVCLK_DIVIDE      (1),        // Master division value, (1-56)
    .REF_JITTER1        (0.010),    // Reference input jitter in UI, (0.000-0.999).
    .STARTUP_WAIT       ("FALSE")   // Delay DONE until PLL Locks, ("TRUE"/"FALSE")
    ) mmcme2_comp_inst (
    .CLKOUT0            (clk_comp_unbuf),        // 1-bit output: CLKOUT0
    .CLKOUT1            (),                     // 1-bit output: CLKOUT1
    .CLKOUT2            (),                     // 1-bit output: CLKOUT2
    .CLKOUT3            (),                     // 1-bit output: CLKOUT3
    .CLKOUT4            (),                     // 1-bit output: CLKOUT4
    .CLKOUT5            (),                     // 1-bit output: CLKOUT5
    .CLKOUT6            (),                     // 1-bit output: CLKOUT5
    .CLKFBOUT           (clk_feedback_unbuf),   // 1-bit output: Feedback clock
    .CLKFBOUTB          (),                     // 1-bit output: Inverted CLKFBOUT
    .LOCKED             (),                     // 1-bit output: LOCK
    .CLKIN1             (clkin_buf),            // 1-bit input: Input clock
    .PWRDWN             (1'b0),                 // 1-bit input: Power-down
    .RST                (1'b0),                 // 1-bit input: Reset
    .CLKFBIN            (clk_feedback_buf)      // 1-bit input: Feedback clock
    );

	//-------------------------------------RX/TX HANDLING-------------------------------------
	//
	// RX/TX handling via buttons and serial communication.

	localparam SZ_BUF 		= 536;

	localparam TX_IDLE		= 4'd0;
	localparam TX_HEAD1		= 4'd1;
	localparam TX_HEAD2		= 4'd2;
	localparam TX_HEAD3		= 4'd3;
	localparam TX_HEAD4		= 4'd4;
	localparam TX_HEAD5		= 4'd5;
	localparam TX_STREAM	= 4'd6;
	localparam TX_TAIL1		= 4'd7;
	localparam TX_TAIL2		= 4'd8;
	localparam TX_TAIL3		= 4'd9;
	localparam TX_SEND 		= 4'd10;

	// local variables for text output string concat
	localparam ASCII_TXT_POWER	= 56'h504F5745523A20;	// "POWER: "
	localparam ASCII_TXT_TRIG  	= 48'h545249473A20;		// "TRIG: "
	localparam ASCII_TXT_MAXSMP = 64'h4D4158534D503A20; // "MAXSMP: "
	localparam ASCII_TXT_WIDTH 	= 56'h57494454483A20; 	// "WIDTH: "
	localparam ASCII_TXT_FREQ 	= 48'h465245513A20; 	// "FREQ: "
	localparam ASCII_LF        	= 8'h0A;	 			// "\n"

	reg [3:0] 		 state_tx 	  = TX_IDLE;
	reg [SZ_BUF-1:0] write_buffer = 0;
	reg [6:0]		 tx_count	  = 0;
	reg 			 tx_start  	  = 0;

	reg trigger 			= DEFAULT_TRIG;
	reg [15:0] max_samples 	= DEFAULT_MAXSMP;
	reg [4:0]  width		= DEFAULT_WIDTH;
	reg sim_switch			= 1'b0;				// signal to use simulated data instead of real input
	reg force_single 		= 1'b0;				// pulse to force immediate trigger
	// reg freq_update 		= 1'b1;				// pulse to update frequency
	reg config_rdy			= 1'b0;				// pulse to transfer updated configuration to clk_comp domain
	wire freq_locked; // unused
	

	// registers for values output string concat
	reg [7:0] ascii_val_power		= DEFAULT_POWER_ASCII;
	reg [7:0] ascii_val_trig		= DEFAULT_TRIG_ASCII;
	reg [39:0] ascii_val_maxsmp		= DEFAULT_MAXSMP_ASCII;
	reg [15:0] ascii_val_width		= DEFAULT_WIDTH_ASCII;
	reg [31:0] ascii_val_freq		= DEFAULT_FREQ_ASCII;

	// local variables for input value handling, only read after write to avoid latches!
	reg [15:0] recv_value;
	reg [39:0] recv_value_ascii;
	
	always@(posedge clk) begin

		// unset pulses
		force_single			<= 1'b0;
		if (config_rcv)
			config_rdy			<= 1'b0;

		if (!bram_empty) begin // detect triggering on !bram_empty signal (same clock)
			trigger 		<= 0;
			config_rdy 		<= 1'b1;
			ascii_val_trig 	<= 8'h30;
		end

		tx_start				<= 1'b0;
		reset 					<= 1'b0;
		// freq_update				<= 1'b0; // freq_update should only pulse for one cycle
		// // unset freq_update only after freq is locked for sufficient reset_w duration
		// if (freq_locked == 1)
		// 	freq_update			<= 1'b0;

		//-------------------------------------RX HANDLER-------------------------------------
		if (rx_fin && rx_dst == DESTINATION_COMP) begin
			case (rx_cmd)
				// COMP:POWER [0/1]: enables/disables comp.
				COMMAND_POWER: begin
					recv_value		 = rx_val[0];
					recv_value_ascii = bin2ascii10000(recv_value);

					comp_en 		<= recv_value;
					ascii_val_power <= recv_value_ascii;
					
					write_buffer	<= {ASCII_TXT_POWER, recv_value_ascii, ASCII_LF,
										{SZ_BUF-104{1'b0}}};
					tx_count 		<= 13;
					tx_start 		<= 1;
				end
				// COMP:STATUS [<any number>]: return status message.
				COMMAND_STATUS: begin
					write_buffer <= {ASCII_TXT_POWER	, ascii_val_power	, ASCII_LF,
									 ASCII_TXT_TRIG		, ascii_val_trig	, ASCII_LF, 
									 ASCII_TXT_MAXSMP	, ascii_val_maxsmp	, ASCII_LF,
									 ASCII_TXT_WIDTH	, ascii_val_width	, ASCII_LF, 
									 ASCII_TXT_FREQ		, ascii_val_freq	, ASCII_LF, 
									 {SZ_BUF-416{1'b0}}};
					tx_start <= 1;
					tx_count <= 52;
				end
				// COMP:MAXSMP [0..65535]: set maximum amount of samples. '0' equals maximum samples (18'd262.143).
				COMMAND_MAXSMP: begin
					recv_value		 = rx_val[15:0];
					recv_value_ascii = bin2ascii10000(recv_value);

					max_samples 		<= recv_value;
					config_rdy 			<= 1'b1;
					ascii_val_maxsmp 	<= recv_value_ascii;
					
					write_buffer	<= {ASCII_TXT_MAXSMP, recv_value_ascii, ASCII_LF,
										{SZ_BUF-112{1'b0}}};
					tx_count 		<= 14;
					tx_start 		<= 1;
				end
				// COMP:TRIG [0/1]: enable triggering according to adc threshold.
				COMMAND_TRIG: begin
					recv_value		 = rx_val[0];
					recv_value_ascii = bin2ascii10000(recv_value);

					trigger 		<= recv_value;
					config_rdy 		<= 1'b1;
					ascii_val_trig 	<= recv_value_ascii;
					
					write_buffer	<= {ASCII_TXT_TRIG, recv_value_ascii, ASCII_LF,
										{SZ_BUF-96{1'b0}}};
					tx_count 		<= 12;
					tx_start 		<= 1;
				end
				// COMP:FORCE [<any number>]: force immediate triggering.
				COMMAND_FORCE: begin
					force_single <= 1'b1;

					write_buffer	<= {96'h464F5243452053494E474C45, ASCII_LF, // "FORCE SINGLE"
										{SZ_BUF-104{1'b0}}};
					tx_count 		<= 13;
					tx_start 		<= 1;
				end
				// COMP:FREQ [25/50/100/200/300/400]: sets sampling frequency in MHz if input is valid.
				// COMMAND_FREQ: begin
				// 	recv_value		 = rx_val;
				// 	recv_value_ascii = 40'h494E56; // "INV"

				// 	for (ii = 0; ii <= 3; ii = ii + 1) begin // logic for SSTATE 0 - 3 (~400, 300, 200, 100)
				// 		if (recv_value == (400 - ii * 100)) begin
				// 			recv_value_ascii	= bin2ascii10000(recv_value);

				// 			freq_state			<= ii;
				// 			freq_update			<= 1'b1;
				// 			ascii_val_freq		<= recv_value_ascii;
				// 		end
				// 	end
				// 	for (ii = 0; ii <= 1; ii = ii + 1) begin // logic for SSTATE 4 - 5 (50, 25)
				// 		if (recv_value == (25 + ii * 25)) begin
				// 			recv_value_ascii	= bin2ascii10000(recv_value);

				// 			freq_state			<= ii + 4;
				// 			freq_update			<= 1'b1;
				// 			ascii_val_freq		<= recv_value_ascii;
				// 		end
				// 	end

				// 	write_buffer	<= {ASCII_TXT_FREQ, recv_value_ascii, ASCII_LF,
				// 						{SZ_BUF-96{1'b0}}};
				// 	tx_count 		<= 12;
				// 	tx_start 		<= 1;
				// end
				// COMP:WIDTH [0..12]: sets maximum counting width (ensure that the cycle count fits, otherwise overflows may occur)
				COMMAND_WIDTH: begin
					recv_value		 = rx_val[4:0];
					if (recv_value > 5'd22)
						recv_value	 = 5'd22;
					recv_value_ascii = bin2ascii10000(recv_value);

					width 				<= recv_value;
					config_rdy 			<= 1'b1;
					ascii_val_width 	<= recv_value_ascii;
					
					write_buffer	<= {ASCII_TXT_WIDTH, recv_value_ascii, ASCII_LF,
										{SZ_BUF-104{1'b0}}};
					tx_count 		<= 13;
					tx_start 		<= 1;
				end
				// COMP:RESET [<any number>]: resets signals (TODO) and applies reset (emptiing fifos)
				COMMAND_RESET: begin
					reset 			<= 1;

					write_buffer	<= {64'h5245534554204F4B, ASCII_LF, // "RESET OK"
										{SZ_BUF-72{1'b0}}};
					tx_count 		<= 9;
					tx_start 		<= 1;
				end
				// COMP:SIM [0/1]: use simulation data instead of comp_in pins input
				COMMAND_SIM: begin
					recv_value		 = rx_val[0];
					recv_value_ascii = bin2ascii10000(recv_value);

					sim_switch		<= recv_value;
					config_rdy 		<= 1'b1;

					write_buffer	<= {40'h53494D3A20, recv_value_ascii, ASCII_LF, // "SIM: "
										{SZ_BUF-88{1'b0}}};
					tx_count 		<= 11;
					tx_start 		<= 1;
				end
			endcase
		end

		//-------------------------------------TX HANDLER-------------------------------------
		case (state_tx)
			// Wait for reply data or stored samples
			TX_IDLE: begin
				tx_valid	<= #1 1'b0;

				// start data transmission from buffer if tx_start
				if (tx_start) begin	
					state_tx 			<= #1 TX_SEND;
				end
				// start data streaming from fifo if not empty
				else if (outfifo_vld && !reset_w) begin
					state_tx 			<= #1 TX_HEAD1;
				end
			end
			// Mark start of stream with 8'h80 (HEAD1) and 8'7F (HEAD2)
			TX_HEAD1: begin
				tx_valid			<= #1 1'b1;
				tx_data				<= #1 8'b10000000;
				if (tx_ready) begin
					state_tx		<= #1 TX_HEAD2;
				end
			end
			TX_HEAD2: begin
				tx_valid			<= #1 1'b1;
				tx_data				<= #1 8'b01111111;
				if (tx_ready) begin
					state_tx		<= #1 TX_HEAD3;
				end
			end
			// Pass source (COMP)
			TX_HEAD3: begin
				tx_valid			<= #1 1'b1;
				tx_data				<= #1 8'h43; // "C"
				if (tx_ready) begin
					state_tx		<= #1 TX_HEAD4;
				end
			end
			// Pass freq_state
			TX_HEAD4: begin
				tx_valid			<= #1 1'b1;
				tx_data				<= #1 freq_state;
				if (tx_ready) begin
					state_tx		<= #1 TX_HEAD5;
				end
			end
			// Pass width
			TX_HEAD5: begin
				tx_valid			<= #1 1'b1;
				tx_data				<= #1 width;
				if (tx_ready) begin
					state_tx		<= #1 TX_STREAM;
				end
			end
			// Stream samples from outfifo, get next sample (send_sample_stream) if tx_ready
			TX_STREAM: begin
				send_sample_stream 		<= #1 1'b0;
				if (outfifo_vld == 1 && !reset_w) begin
					tx_valid			<= #1 1'b1;
					tx_data				<= #1 sample_stream;
					if (tx_ready) begin
						send_sample_stream	<= #1 1'b1;
					end
				end
				else begin
					tx_valid			<= #1 1'b0;
					state_tx			<= #1 TX_TAIL1;
				end
			end
			// Mark end of stream with 8'7F (TAIL1) and 8'h80 (TAIL2) and 8'h0A (TAIL3: line feed)
			TX_TAIL1: begin
				tx_valid			<= #1 1'b1;
				tx_data				<= #1 8'b01111111;
				if (tx_ready) begin
					state_tx		<= #1 TX_TAIL2;
				end
			end
			TX_TAIL2: begin
				tx_valid			<= #1 1'b1;
				tx_data				<= #1 8'b10000000;
				if (tx_ready) begin
					state_tx		<= #1 TX_TAIL3;
				end
			end
			TX_TAIL3: begin
				tx_valid			<= #1 1'b1;
				tx_data				<= #1 ASCII_LF;
				if (tx_ready) begin
					state_tx		<= #1 TX_IDLE;
					reset			<= #1 1'b1;		// apply reset for one cycle to empty fifos
				end
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

	//-------------------------------------COMP CONTROL-------------------------------------
	//
	// Handles incoming COMP data when triggered by force_trigger or exceeded threshold.
	// Passes samples to infifo synchronously to clk_comp until bram is full or sample_count 
	// is reached.
	// Forwarding of last sampled data is not guaranteed, as infifo may not be filled in the
	// last cycles.
	// Also resets sample_count when it has reached 0:
	// 		if (max_samples_comp == 0): sample_count = 18'd262.143 (MAXIMUM)
	//		otherwise				 : sample_count = max_samples_comp (<16'd65.535)

	reg [15:0] max_samples_comp = DEFAULT_MAXSMP;
	reg [4:0] width_comp 		= DEFAULT_WIDTH;
	reg trigger_comp 			= DEFAULT_TRIG;
	reg sim_switch_comp			= 1'b0;
	wire force_single_comp;
	
	reg [17:0] sample_count = 18'b0;
	
	localparam SAMPLE_WAIT 	= 3'b001;
	localparam SAMPLE_RUN 	= 3'b010;
	localparam SAMPLE_RST 	= 3'b100;
	reg [2:0] state_sample 	= SAMPLE_WAIT;

	reg previous_comp = 0;
	reg [21:0] cycle_counter = 0;

	// assign comp_in_synced = comp_in;
	xpm_cdc_single #( // version 2020.2
		.DEST_SYNC_FF	(2),	// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),	// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.SIM_ASSERT_CHK	(0),	// DECIMAL; 0=disable simulation messages, 1=enable simulation messages 
		.SRC_INPUT_REG	(0)		// DECIMAL; 0=do not register input, 1=register input
	) u_cdc_comp_in ( 
		.dest_out	(comp_in_synced),	// 1-bit output: src_in synchronized to the destination clock domain. This output is registered. 
		.dest_clk	(clk_comp),			// 1-bit input: Clock signal for the destination clock domain. 
		.src_clk	(),					// 1-bit input: optional; required when SRC_INPUT_REG = 1 
		.src_in		(comp_in)			// 1-bit input: Input signal to be synchronized to dest_clk domain.
	);

	always@(posedge clk_comp) begin
		sample_in_vld	<= 1'b0;

		if (sim_switch_comp)
			previous_comp	<= sim_comp_in;
		else
			previous_comp	<= comp_in_synced;
		
		case (state_sample)
			// Wait state: trigger on force signal or when threshold is exceeded
			SAMPLE_WAIT: begin
				if (force_single_comp || 
					trigger_in_comp && trigger_comp) begin
						cycle_counter	<= 1;
						state_sample	<= SAMPLE_RUN;
				end
			end
			// Run state: write samples to infifo and keep triggered until sample_count is reached or bram is full
			SAMPLE_RUN: begin
				cycle_counter 	<= cycle_counter + 1;
				if (sim_switch_comp && (sim_comp_in != previous_comp) ||
					!sim_switch_comp && (comp_in_synced != previous_comp)) begin
						sample_in		<= cycle_counter;
						sample_in_vld	<= 1'b1;
						cycle_counter 	<= 1;
						sample_count	<= sample_count - 1;
				end
				if (sample_count == 0 || bram_full) begin
					state_sample	<= SAMPLE_RST;
				end
			end
			// Reset state: wait for applied reset in clk_comp domain (e.g. triggered in state_tx == TAIL_3)
			// 				optional TODO: for increased robustness deny sampling in case of reset in SAMPLE_RUN state
			SAMPLE_RST: begin
				if (reset_w_comp) begin
					state_sample	<= SAMPLE_WAIT;
				end
			end
		endcase

		// reset sample_count, performed when sample_count equals 0 or config is updated
		if (sample_count == 0 || config_comp_changed) begin
			if (max_samples_comp == 0)
				sample_count <= {18{1'b1}};
			else
				sample_count <= max_samples_comp;
		end
	end

	//--------------------------------SIGNAL SYNCHRONIZATION--------------------------------
	//
	// Signals for configuration and commands received via serial communication or buttons 
	// are transferred to the comp clock domain.
	// trigger_out signal from the synchronous to the comp clock domain is transferred to the
	// system clock domain.
	
	// config
	localparam CONFIG_WIDTH = 16+5+1+1;
	wire [CONFIG_WIDTH-1:0] config_w = {max_samples, width, trigger, sim_switch};
	wire [CONFIG_WIDTH-1:0] config_comp_w;
	wire config_comp_vld;
	wire config_rcv;
	reg config_comp_changed;
	
	xpm_cdc_handshake #( // version 2020.2
		.DEST_EXT_HSK	(0),			// DECIMAL; 0=internal handshake, 1=external handshake 
		.DEST_SYNC_FF	(2),			// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),			// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.SIM_ASSERT_CHK	(0),			// DECIMAL; 0=disable simulation messages, 1=enable simulation messages 
		.SRC_SYNC_FF	(2),			// DECIMAL; range: 2-10 
		.WIDTH			(CONFIG_WIDTH)	// DECIMAL; range: 1-1024
	) u_cdc_config ( 
		.dest_out	(config_comp_w),	// WIDTH-bit output: Input bus (src_in) synchronized to destination clock domain.  This output is registered. 
		.dest_req	(config_comp_vld),	// 1-bit output: Assertion of this signal indicates that new dest_out data has been  received and is ready to be used or captured by the destination logic. When  DEST_EXT_HSK = 1, this signal will deassert once the source handshake  acknowledges that the destination clock domain has received the transferred data.  When DEST_EXT_HSK = 0, this signal asserts for one clock period when dest_out bus  is valid. This output is registered. 
		.src_rcv	(config_rcv),		// 1-bit output: Acknowledgement from destination logic that src_in has been  received. This signal will be deasserted once destination handshake has fully  completed, thus completing a full data transfer. This output is registered. 
		.dest_ack	(),					// 1-bit input: optional; required when DEST_EXT_HSK = 1 
		.dest_clk	(clk_comp),			// 1-bit input: Destination clock. 
		.src_clk	(clk),				// 1-bit input: Source clock. 
		.src_in		(config_w),			// WIDTH-bit input: Input bus that will be synchronized to the destination clock  domain. 
		.src_send	(config_rdy)		// 1-bit input: Assertion of this signal allows the src_in bus to be synchronized to  the destination clock domain. This signal should only be asserted when src_rcv is  deasserted, indicating that the previous data transfer is complete. This signal  should only be deasserted once src_rcv is asserted, acknowledging that the src_in  has been received by the destination logic.
	);

	always @(posedge clk_comp) begin
		config_comp_changed		<= 1'b0;
		if (config_comp_vld) begin
			config_comp_changed		<= 1'b1;
			sim_switch_comp			<= config_comp_w[0];
			trigger_comp			<= config_comp_w[1];
			width_comp				<= config_comp_w[6:2];
			max_samples_comp		<= config_comp_w[22:7];
		end
	end

	// force_single (no pulse stretching -> manually ensure that clk_comp > 2*clk for proper sampling)
	xpm_cdc_pulse #( // version 2020.2
		.DEST_SYNC_FF	(2),   	// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),   	// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.REG_OUTPUT		(0),    // DECIMAL; 0=disable registered output, 1=enable registered output 
		.RST_USED		(0),	// DECIMAL; 0=no reset, 1=implement reset 
		.SIM_ASSERT_CHK	(0)  	// DECIMAL; 0=disable simulation messages, 1=enable simulation messages
	) u_cdc_force_single ( 
		.dest_pulse	(force_single_comp),	// 1-bit output: Outputs a pulse the size of one dest_clk period when a pulse  transfer is correctly initiated on src_pulse input. This output is combinatorial unless REG_OUTPUT is set to 1.
		.dest_clk	(clk_comp),     		// 1-bit input: Destination clock. 
		.dest_rst	(),     				// 1-bit input: optional; required when RST_USED = 1 
		.src_clk	(clk),      			// 1-bit input: Source clock. 
		.src_pulse	(force_single),			// 1-bit input: Rising edge of this signal initiates a pulse transfer to the  destination clock domain. The minimum gap between each pulse transfer must be at the minimum 2*(larger(src_clk period, dest_clk period)). This is measured  between the falling edge of a src_pulse to the rising edge of the next  src_pulse.
		.src_rst	()   					// 1-bit input: optional; required when RST_USED = 1
	);

	//trigger_in
	xpm_cdc_single #( // version 2020.2
		.DEST_SYNC_FF	(2),	// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),	// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.SIM_ASSERT_CHK	(0),	// DECIMAL; 0=disable simulation messages, 1=enable simulation messages 
		.SRC_INPUT_REG	(0)		// DECIMAL; 0=do not register input, 1=register input
	) u_cdc_trigger_out ( 
		.dest_out	(trigger_in_comp),	// 1-bit output: src_in synchronized to the destination clock domain. This output is registered. 
		.dest_clk	(clk_comp),			// 1-bit input: Clock signal for the destination clock domain. 
		.src_clk	(),					// 1-bit input: optional; required when SRC_INPUT_REG = 1 
		.src_in		(trigger_in)		// 1-bit input: Input signal to be synchronized to dest_clk domain.
	);

	
	//-------------------------------------FIFO CHAIN-------------------------------------
	//
	// Input is buffered and aggregated into the infifo, pushed into bram, and pulled and 
	// seperated via the outfifo for data transfer over the serial line.
	// Advantages:  - increased sampling time
	//				- clock domain crossing
	//				- adjustable sampling frequency and sample width during runtime
	// Optional TODOs: - shutdown for power saving


	reg [MAX_COUNT_WIDTH-1:0] sample_in = 0;
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
	wire outfifo_rdy = ~outfifo_full & ~reset_w_comp & ~bram_rd_rst_busy;

	reg send_sample_stream = 0;

	// Collect 'width'-sized samples until FIFO_WIDTH is reached and
	// forward the data to the BRAM.
	fifo_aggregate #(
		.MAX_INPUT_WIDTH    ( MAX_COUNT_WIDTH   ),
		.OUTPUT_WIDTH_BYTES ( FIFO_WIDTH_BYTES  ))
	u_infifo (
		.clk               	( clk_comp         	),
		.rst               	( reset_w_comp 		),
		.input_width       	( width_comp		),
		.wr_en             	( sample_in_vld     ),
		.data_in           	( sample_in    		),
		.data_out          	( infifo_data 		),
		.full              	( infifo_vld    	)
	);


	// Store collected samples in BRAM.
	xpm_fifo_async #( // version 2020.2
		.CDC_SYNC_STAGES		(2),       		// DECIMAL
		.DOUT_RESET_VALUE		("0"),    		// String
		.ECC_MODE				("no_ecc"),		// String
		.FIFO_MEMORY_TYPE		("block"), 		// String
		.FIFO_READ_LATENCY		(0),     		// DECIMAL
		.FIFO_WRITE_DEPTH		(8192),   		// DECIMAL
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
		.rst					(reset_w_comp),   // 1-bit input: Reset: Must be synchronous to wr_clk. The clock(s) can be  unstable at the time of applying reset, but reset must be released only  after the clock(s) is/are stable.
		.sleep					(1'b0),         // 1-bit input: Dynamic power saving: If sleep is High, the memory/fifo  block is in power saving mode.
		.wr_clk					(clk_comp),     // 1-bit input: Write clock: Used for write operation. wr_clk must be a  free running clock.
		.wr_en					(infifo_vld)    // 1-bit input: Write Enable: If the FIFO is not full, asserting this  signal causes data (on din) to be written to the FIFO. Must be held  active-low when rst or wr_rst_busy is active high.
	);

	// Pull collected samples and output as bytes for streaming as serial data.
	fifo_x2byte #(
		.INPUT_WIDTH_BYTES ( FIFO_WIDTH_BYTES	),
		.FIFO_DEPTH_INPUT  ( 2 	                ))
	u_outfifo (
		.clk     		( clk                 	),
		.rst     		( reset_w				),
		.rd_en   		( send_sample_stream	),
		.wr_en   		( bram_vld       		),
		.data_in 		( bram_data    			),
		.data_out		( sample_stream       	),
		.full    		( outfifo_full         	),
		.empty   		( outfifo_empty        	)
	);

	
	//--------------------------------------SIMULATION--------------------------------------
	//
	// Simulation of a serial receiver and hence consumption of sent data (code changes may 
	// be required) and comp samples (usage with sim_switch signal)

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
	localparam SIM_FLIP_COUNT = 127;
	reg [7:0] sim_cycle_counter = 0;
	reg [7:0] sim_num_cycles_to_flip = SIM_FLIP_COUNT;	// number of cycles after which simulated input is flipped
	reg sim_comp_in = 1'b0;								// simulated comparator signal
	always @(posedge clk_comp) begin
		sim_cycle_counter	<= sim_cycle_counter + 1;
		// reset
		if (force_single_comp || reset_w_comp) begin
			sim_num_cycles_to_flip 	<= SIM_FLIP_COUNT;
			sim_comp_in 			<= 1'b0;
		end
		// flip sim_comp_in and change sim_num_cycles_to_flip
		else begin
			if (sim_cycle_counter == sim_num_cycles_to_flip) begin
				sim_comp_in 			<= ~sim_comp_in;
				sim_num_cycles_to_flip	<= sim_num_cycles_to_flip + 2;
				sim_cycle_counter		<= 1;
			end
		end
	end


endmodule
