`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.02.2023 16:40:56
// Design Name: 
// Module Name: piezo_driver
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


module piezo_driver(
    input wire clk,
    input wire [21:0] start_cfg,
    input wire start_cfg_rdy,
    output wire start_cfg_rcv,
    output wire fin,
    output wire piezodriver_lo,
    output wire piezodriver_hi
    );
    
    parameter DLY = 5;                      // turn-on delay from rising/falling edge to output. Time per step: 1/clk
    
    reg out0 = 0;
    reg out1 = 0;
    reg clk_piezo = 0;
    reg [3:0] dly0 = DLY;
    reg [3:0] dly1 = DLY;
   
    reg start_400 = 0;
    reg fin_400 = 0;
    reg [11:0] numpulses;
    reg [11:0] pulse_counter = 0;
    reg [8:0] counter_compare_value = 9'd200; 
    reg [8:0] clk_counter = 0;
    
    wire [21:0] start_cfg_400;
    wire start_cfg_400_vld;
		
    assign piezodriver_lo = out0;
    assign piezodriver_hi = out1;

    localparam IDLE         = 5'b00001;
    localparam BUSY         = 5'b00010;
    localparam BUSYPULSE    = 5'b00100;
    localparam OUT0         = 5'b00010;
    localparam OUT0_WAIT    = 5'b00100;
    localparam OUT1         = 5'b01000;
    localparam OUT1_WAIT    = 5'b10000;
    reg [2:0] state = IDLE;
    reg [4:0] state_out = IDLE;

    // clock and state control
    always @(posedge clk_400) begin
        case (state)
            IDLE : begin
                clk_piezo       <= 0;
                clk_counter     <= 0;
                pulse_counter   <= 0;
                fin_400         <= 1;

                if (start_400) begin
                    state       <= BUSY;
                    fin_400     <= 0;
                end
            end
            BUSY : begin
                clk_counter <= clk_counter + 1;

                if (clk_counter == counter_compare_value) begin
                    state       <= BUSYPULSE;
                end
            end
            BUSYPULSE : begin
                    pulse_counter   <= pulse_counter + 1;
                    clk_counter     <= 0;

                    if (pulse_counter != numpulses) begin
                        state   <= BUSY;
                    end
                    else begin
                        state   <= IDLE;
                    end
            end
        endcase
    end

    // MOSFET output control
    always @(posedge clk_400) begin
        case (state_out)
            IDLE : begin
                out0 <= 0;
                out1 <= 0;
                dly0 <= DLY;
                dly1 <= DLY;
                if (state == BUSY)
                    state_out <= OUT1_WAIT;
            end
            OUT1_WAIT : begin
                dly0 <= DLY;
                out0 <= 0;

                dly1 <= dly1 - 1;
                out1 <= 0;
                if (dly1 == 0)
                    state_out <= OUT1;
            end
            OUT1 : begin
                out1 <= 1;
                if (state == BUSYPULSE)
                    state_out <= OUT0_WAIT;
            end
            OUT0_WAIT : begin
                dly1 <= DLY;
                out1 <= 0; 

                dly0 <= dly0 - 1;
                out0 <= 0;
                if (dly0 == 0)
                    state_out <= OUT0;
            end
            OUT0 : begin
                out0 <= 1;
                if (state == BUSYPULSE)
                    state_out <= OUT1_WAIT;
            end
        endcase

        if (state == IDLE) begin
            state_out <= IDLE;
        end
    end

    
    // config update
	xpm_cdc_handshake #( // version 2020.2
		.DEST_EXT_HSK	(0),			// DECIMAL; 0=internal handshake, 1=external handshake 
		.DEST_SYNC_FF	(3),			// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),			// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.SIM_ASSERT_CHK	(0),			// DECIMAL; 0=disable simulation messages, 1=enable simulation messages 
		.SRC_SYNC_FF	(3),			// DECIMAL; range: 2-10 
		.WIDTH			(22)	        // DECIMAL; range: 1-1024
    ) u_cdc_start_cfg ( 
		.dest_out	(start_cfg_400),	// WIDTH-bit output: Input bus (src_in) synchronized to destination clock domain.  This output is registered. 
		.dest_req	(start_cfg_400_vld),// 1-bit output: Assertion of this signal indicates that new dest_out data has been  received and is ready to be used or captured by the destination logic. When  DEST_EXT_HSK = 1, this signal will deassert once the source handshake  acknowledges that the destination clock domain has received the transferred data.  When DEST_EXT_HSK = 0, this signal asserts for one clock period when dest_out bus  is valid. This output is registered. 
		.src_rcv	(start_cfg_rcv),    // 1-bit output: Acknowledgement from destination logic that src_in has been  received. This signal will be deasserted once destination handshake has fully  completed, thus completing a full data transfer. This output is registered. 
		.dest_ack	(),					// 1-bit input: optional; required when DEST_EXT_HSK = 1 
		.dest_clk	(clk_400),			// 1-bit input: Destination clock. 
		.src_clk	(clk),				// 1-bit input: Source clock. 
		.src_in		(start_cfg),		// WIDTH-bit input: Input bus that will be synchronized to the destination clock  domain. 
		.src_send	(start_cfg_rdy)		// 1-bit input: Assertion of this signal allows the src_in bus to be synchronized to  the destination clock domain. This signal should only be asserted when src_rcv is  deasserted, indicating that the previous data transfer is complete. This signal  should only be deasserted once src_rcv is asserted, acknowledging that the src_in  has been received by the destination logic.
	);

    reg start_cfg_changed = 0;
	always @(posedge clk_400) begin
		if (start_cfg_400_vld) begin
            start_cfg_changed   <= 1;
		end

        case (state)
            IDLE : begin
                if (start_cfg_400_vld || start_cfg_changed) begin
                    start_cfg_changed       <= 0;
                    start_400               <= start_cfg_400[0];
                    numpulses			    <= (start_cfg_400[12:1] << 1) - 1;
                    counter_compare_value	<= start_cfg_400[21:13] - 2;
                end
            end 
            BUSY, BUSYPULSE : begin
                start_400 <= 0;
            end 
        endcase
	end

	// fin (no pulse stretching -> fin is correctly sampled because it is only unset if the comm_protocol FSM continues after the detection of fin)
	xpm_cdc_pulse #( // version 2020.2
		.DEST_SYNC_FF	(3),   	// DECIMAL; range: 2-10 
		.INIT_SYNC_FF	(0),   	// DECIMAL; 0=disable simulation init values, 1=enable simulation init values 
		.REG_OUTPUT		(0),    // DECIMAL; 0=disable registered output, 1=enable registered output 
		.RST_USED		(0),	// DECIMAL; 0=no reset, 1=implement reset 
		.SIM_ASSERT_CHK	(0)  	// DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    ) u_cdc_fin ( 
		.dest_pulse	(fin),	        // 1-bit output: Outputs a pulse the size of one dest_clk period when a pulse  transfer is correctly initiated on src_pulse input. This output is combinatorial unless REG_OUTPUT is set to 1.
		.dest_clk	(clk),      	// 1-bit input: Destination clock. 
		.dest_rst	(),     		// 1-bit input: optional; required when RST_USED = 1 
		.src_clk	(clk_400),     	// 1-bit input: Source clock. 
		.src_pulse	(fin_400),		// 1-bit input: Rising edge of this signal initiates a pulse transfer to the  destination clock domain. The minimum gap between each pulse transfer must be at the minimum 2*(larger(src_clk period, dest_clk period)). This is measured  between the falling edge of a src_pulse to the rising edge of the next  src_pulse.
		.src_rst	()   			// 1-bit input: optional; required when RST_USED = 1
	);
    
    wire            clkin_buf;
    wire            clk_feedback_buf;
    wire            clk_feedback_unbuf;
    wire            clk_400_unbuf;
    wire            clk_400_buf;
    //-------------------------------------------------------------------------------------------
    assign clkin_buf = clk;
    BUFG BUFG_FB    (.I (clk_feedback_unbuf), .O (clk_feedback_buf));
    BUFG BUFG_CLK0  (.I (clk_400_unbuf), .O (clk_400_buf));
    assign clk_400 = clk_400_buf;

    MMCME2_BASE #(   // Xilinx HDL Language Template, version 2021.2
    .BANDWIDTH("OPTIMIZED"),        // OPTIMIZED, HIGH, LOW
    .CLKFBOUT_MULT_F    (62.5),     // Multiply value for all CLKOUT (2.000-64.000).
    .CLKFBOUT_PHASE     (0.0),      // Phase offset in degrees of CLKFB, (-360.000-360.000).
    .CLKIN1_PERIOD      (83.333),   // Input clock period in ns to ps resolution (i.e. 33.333 is 30 MHz).
    .CLKOUT0_DIVIDE_F   (3.000),
    .CLKOUT0_DUTY_CYCLE (0.5),
    .CLKOUT0_PHASE      (0.0),
    .CLKOUT4_CASCADE("FALSE"),      // Cascade CLKOUT4 counter with CLKOUT6 (FALSE, TRUE)
    .DIVCLK_DIVIDE      (1),        // Master division value, (1-56)
    .REF_JITTER1        (0.010),    // Reference input jitter in UI, (0.000-0.999).
    .STARTUP_WAIT       ("FALSE")   // Delay DONE until PLL Locks, ("TRUE"/"FALSE")
    ) mmcme2_piezo_inst (
    .CLKOUT0            (clk_400_unbuf),        // 1-bit output: CLKOUT0
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


endmodule