//
// Defines the states and calculations for the mmcme2_drp state machine.
// 40 states for a frequency range of 0.25MHz (S1) to 10MHz (S40) in 0.25MHz steps.
//
// Formula: fOut = fVco / DivOut = fIn * (Mult/Div) / (DivOut4 * DivOut6) 
// with fIn = 12MHz
// Calculate manually or take values from Clocking Wizard
// Constraints (XC7S25): fVco_min = 600 MHz, fVco_max = 1200 MHz
// Maximize fVco for best jitter performance (with minimized Mult & Div)
// DivOut4 and DivOut6 accept values from 1-128 (integer only)
// Mult accepts values from 2.000 to 64.000 with decimal steps of 0.125 (with fIn=12MHz minimum allwowed option is '50.000')
// Div accepts values from 1 to 108 (with fIn=12MHz only allowed option is '1')

// NOTICE: S**_DIVCLK_DIVIDE (a.k.a. Div) never reconfigured, standard value '1' always used in order to minimize config rom size
// use the following lines in the rom initialization function for restoring the functionality and edit rom indices, ROM_SZ and STATE_COUNT_CONST accordingly:
//
//		// Store the input divider
//		rom[3] = {7'h16, 16'hC000, {2'h0, S1_DIVCLK[23:22], S1_DIVCLK[11:0]}};



//********************
// State  1 Parameters 
//********************

// These parameters have an effect on the feedback path. A change on
// these parameters will effect all of the clock outputs.
//
// The parameters are composed of:
//    _MULT: This can be from 2 to 64. It has an effect on the VCO
//          frequency which consequently, effects all of the clock
//          outputs.
//    _PHASE: This is the phase multiplied by 1000. For example if
//          a phase of 24.567 deg was desired the input value would be
//          24567. The range for the phase is from -360000 to 360000.
//    _FRAC: This can be from 0 to 875. This represents the fractional
//          divide multiplied by 1000.
//          M = _MULT + _FRAC / 1000
//          e.g. M=8.125
//               _MULT = 8
//               _FRAC = 125
//    _FRAC_EN: This indicates fractional divide has been enabled. If 1
//          then the fractional divide algorithm will be used to calculate
//          register settings. If 0 then default calculation to be used.
localparam S1_CLKFBOUT_MULT    = 64;
localparam S1_CLKFBOUT_PHASE   = 0;
localparam S1_CLKFBOUT_FRAC    = 0;
localparam S1_CLKFBOUT_FRAC_EN = 1;

// The bandwidth parameter effects the phase error and the jitter filter
// capability of the MMCM. For more information on this parameter see the
// Device user guide.
// Possible values are: "LOW", "LOW_SS", "HIGH" and "OPTIMIZED"
localparam S1_BANDWIDTH        = "OPTIMIZED";

// The divclk parameter allows the input clock to be divided before it
// reaches the phase and frequency comparator. This can be set between
// 1 and 128.
localparam S1_DIVCLK_DIVIDE    = 1;

// The following parameters describe the configuration that each clock
// output should have once the reconfiguration for state one has
// completed.
//
// The parameters are composed of:
//    _DIVIDE: This can be from 1 to 128
//    _PHASE: This is the phase multiplied by 1000. For example if
//          a phase of 24.567 deg was desired the input value would be
//          24567. The range for the phase is from -360000 to 360000.
//    _DUTY: This is the duty cycle multiplied by 100,000.  For example if
//          a duty cycle of .24567 was desired the input would be
//          24567.
localparam S1_CLKOUT0_DIVIDE    = 2;
localparam S1_CLKOUT0_PHASE     = 0;
localparam S1_CLKOUT0_DUTY      = 50000;
localparam S1_CLKOUT0_FRAC      = 0;
localparam S1_CLKOUT0_FRAC_EN   = 1;

//********************
// State  2 Parameters 
//********************
localparam S2_CLKFBOUT_MULT     = 62;
localparam S2_CLKFBOUT_PHASE    = 0;
localparam S2_CLKFBOUT_FRAC     = 500;
localparam S2_CLKFBOUT_FRAC_EN  = 1;
localparam S2_BANDWIDTH         = "OPTIMIZED";
localparam S2_DIVCLK_DIVIDE     = 1;
localparam S2_CLKOUT0_DIVIDE    = 2;
localparam S2_CLKOUT0_PHASE     = 0;
localparam S2_CLKOUT0_DUTY      = 50000;
localparam S2_CLKOUT0_FRAC      = 500;
localparam S2_CLKOUT0_FRAC_EN   = 1;

//********************
// State  3 Parameters 
//********************
localparam S3_CLKFBOUT_MULT     = 62;
localparam S3_CLKFBOUT_PHASE    = 0;
localparam S3_CLKFBOUT_FRAC     = 500;
localparam S3_CLKFBOUT_FRAC_EN  = 1;
localparam S3_BANDWIDTH         = "OPTIMIZED";
localparam S3_DIVCLK_DIVIDE     = 1;
localparam S3_CLKOUT0_DIVIDE    = 3;
localparam S3_CLKOUT0_PHASE     = 0;
localparam S3_CLKOUT0_DUTY      = 50000;
localparam S3_CLKOUT0_FRAC      = 750;
localparam S3_CLKOUT0_FRAC_EN   = 1;

//********************
// State  4 Parameters 
//********************
localparam S4_CLKFBOUT_MULT     = 62;
localparam S4_CLKFBOUT_PHASE    = 0;
localparam S4_CLKFBOUT_FRAC     = 500;
localparam S4_CLKFBOUT_FRAC_EN  = 1;
localparam S4_BANDWIDTH         = "OPTIMIZED";
localparam S4_DIVCLK_DIVIDE     = 1;
localparam S4_CLKOUT0_DIVIDE    = 7;
localparam S4_CLKOUT0_PHASE     = 0;
localparam S4_CLKOUT0_DUTY      = 50000;
localparam S4_CLKOUT0_FRAC      = 500;
localparam S4_CLKOUT0_FRAC_EN   = 1;

//********************
// State  5 Parameters 
//********************
localparam S5_CLKFBOUT_MULT     = 62;
localparam S5_CLKFBOUT_PHASE    = 0;
localparam S5_CLKFBOUT_FRAC     = 500;
localparam S5_CLKFBOUT_FRAC_EN  = 1;
localparam S5_BANDWIDTH         = "OPTIMIZED";
localparam S5_DIVCLK_DIVIDE     = 1;
localparam S5_CLKOUT0_DIVIDE    = 15;
localparam S5_CLKOUT0_PHASE     = 0;
localparam S5_CLKOUT0_DUTY      = 50000;
localparam S5_CLKOUT0_FRAC      = 0;
localparam S5_CLKOUT0_FRAC_EN   = 1;

//********************
// State  6 Parameters 
//********************
localparam S6_CLKFBOUT_MULT     = 62;
localparam S6_CLKFBOUT_PHASE    = 0;
localparam S6_CLKFBOUT_FRAC     = 500;
localparam S6_CLKFBOUT_FRAC_EN  = 1;
localparam S6_BANDWIDTH         = "OPTIMIZED";
localparam S6_DIVCLK_DIVIDE     = 1;
localparam S6_CLKOUT0_DIVIDE    = 30;
localparam S6_CLKOUT0_PHASE     = 0;
localparam S6_CLKOUT0_DUTY      = 50000;
localparam S6_CLKOUT0_FRAC      = 0;
localparam S6_CLKOUT0_FRAC_EN   = 1;



// Include the MMCM reconfiguration functions.  This contains the constant
// functions that are used in the calculations below.  This file is
// required.
`include "mmcme2_drp_func.h"
//**********************
// State  1 Calculations
//**********************
localparam [37:0] S1_CLKFBOUT            = mmcm_count_calc(S1_CLKFBOUT_MULT, S1_CLKFBOUT_PHASE, 50000);
localparam [37:0] S1_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S1_CLKFBOUT_MULT, S1_CLKFBOUT_PHASE, 50000, S1_CLKFBOUT_FRAC);
localparam [9:0]  S1_DIGITAL_FILT        = mmcm_filter_lookup(S1_CLKFBOUT_MULT, S1_BANDWIDTH);
localparam [39:0] S1_LOCK                = mmcm_lock_lookup(S1_CLKFBOUT_MULT);
localparam [37:0] S1_DIVCLK              = mmcm_count_calc(S1_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S1_CLKOUT0_FRAC_CALC   = mmcm_frac_count_calc(S1_CLKOUT0_DIVIDE, S1_CLKOUT0_PHASE, 50000, S1_CLKOUT0_FRAC);

//**********************
// State  2 Calculations
//**********************
localparam [37:0] S2_CLKFBOUT            = mmcm_count_calc(S2_CLKFBOUT_MULT, S2_CLKFBOUT_PHASE, 50000);
localparam [37:0] S2_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S2_CLKFBOUT_MULT, S2_CLKFBOUT_PHASE, 50000, S2_CLKFBOUT_FRAC);
localparam [9:0]  S2_DIGITAL_FILT        = mmcm_filter_lookup(S2_CLKFBOUT_MULT, S2_BANDWIDTH);
localparam [39:0] S2_LOCK                = mmcm_lock_lookup(S2_CLKFBOUT_MULT);
localparam [37:0] S2_DIVCLK              = mmcm_count_calc(S2_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S2_CLKOUT0_FRAC_CALC   = mmcm_frac_count_calc(S2_CLKOUT0_DIVIDE, S2_CLKOUT0_PHASE, 50000, S2_CLKOUT0_FRAC);

//**********************
// State  3 Calculations
//**********************
localparam [37:0] S3_CLKFBOUT            = mmcm_count_calc(S3_CLKFBOUT_MULT, S3_CLKFBOUT_PHASE, 50000);
localparam [37:0] S3_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S3_CLKFBOUT_MULT, S3_CLKFBOUT_PHASE, 50000, S3_CLKFBOUT_FRAC);
localparam [9:0]  S3_DIGITAL_FILT        = mmcm_filter_lookup(S3_CLKFBOUT_MULT, S3_BANDWIDTH);
localparam [39:0] S3_LOCK                = mmcm_lock_lookup(S3_CLKFBOUT_MULT);
localparam [37:0] S3_DIVCLK              = mmcm_count_calc(S3_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S3_CLKOUT0_FRAC_CALC   = mmcm_frac_count_calc(S3_CLKOUT0_DIVIDE, S3_CLKOUT0_PHASE, 50000, S3_CLKOUT0_FRAC);

//**********************
// State  4 Calculations
//**********************
localparam [37:0] S4_CLKFBOUT            = mmcm_count_calc(S4_CLKFBOUT_MULT, S4_CLKFBOUT_PHASE, 50000);
localparam [37:0] S4_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S4_CLKFBOUT_MULT, S4_CLKFBOUT_PHASE, 50000, S4_CLKFBOUT_FRAC);
localparam [9:0]  S4_DIGITAL_FILT        = mmcm_filter_lookup(S4_CLKFBOUT_MULT, S4_BANDWIDTH);
localparam [39:0] S4_LOCK                = mmcm_lock_lookup(S4_CLKFBOUT_MULT);
localparam [37:0] S4_DIVCLK              = mmcm_count_calc(S4_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S4_CLKOUT0_FRAC_CALC   = mmcm_frac_count_calc(S4_CLKOUT0_DIVIDE, S4_CLKOUT0_PHASE, 50000, S4_CLKOUT0_FRAC);

//**********************
// State  5 Calculations
//**********************
localparam [37:0] S5_CLKFBOUT            = mmcm_count_calc(S5_CLKFBOUT_MULT, S5_CLKFBOUT_PHASE, 50000);
localparam [37:0] S5_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S5_CLKFBOUT_MULT, S5_CLKFBOUT_PHASE, 50000, S5_CLKFBOUT_FRAC);
localparam [9:0]  S5_DIGITAL_FILT        = mmcm_filter_lookup(S5_CLKFBOUT_MULT, S5_BANDWIDTH);
localparam [39:0] S5_LOCK                = mmcm_lock_lookup(S5_CLKFBOUT_MULT);
localparam [37:0] S5_DIVCLK              = mmcm_count_calc(S5_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S5_CLKOUT0_FRAC_CALC   = mmcm_frac_count_calc(S5_CLKOUT0_DIVIDE, S5_CLKOUT0_PHASE, 50000, S5_CLKOUT0_FRAC);

//**********************
// State  6 Calculations
//**********************
localparam [37:0] S6_CLKFBOUT            = mmcm_count_calc(S6_CLKFBOUT_MULT, S6_CLKFBOUT_PHASE, 50000);
localparam [37:0] S6_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S6_CLKFBOUT_MULT, S6_CLKFBOUT_PHASE, 50000, S6_CLKFBOUT_FRAC);
localparam [9:0]  S6_DIGITAL_FILT        = mmcm_filter_lookup(S6_CLKFBOUT_MULT, S6_BANDWIDTH);
localparam [39:0] S6_LOCK                = mmcm_lock_lookup(S6_CLKFBOUT_MULT);
localparam [37:0] S6_DIVCLK              = mmcm_count_calc(S6_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S6_CLKOUT0_FRAC_CALC   = mmcm_frac_count_calc(S6_CLKOUT0_DIVIDE, S6_CLKOUT0_PHASE, 50000, S6_CLKOUT0_FRAC);





//****************************
// ROM INITIALIZATION FUNCTION
//****************************

// STATE_COUNT_CONST is used to reset the counters and should match the
//    number of registers necessary to reconfigure each state.
localparam STATE_COUNT_CONST = 12;
localparam ROM_SZ = 480;

function [38:0] rom_init;
    input integer index;
    //input index; // mandatory function input

    reg [38:0] init_rom [ROM_SZ-1:0];
    begin
		// rom entries contain (in order) the address, a bitmask, and a bitset
		//***********************************************************************
		// State 1 Initialization
		//***********************************************************************
		// Store the power bits
		init_rom[0] = {7'h28, 16'h0000, 16'hFFFF};

		// Store CLKOUT0 divide and phase
		init_rom[1]		= {7'h09, 16'h8000, S1_CLKOUT0_FRAC_CALC[31:16]};
		init_rom[2] 	= {7'h08, 16'h1000, S1_CLKOUT0_FRAC_CALC[15:0]};

		// Store the feedback divide and phase
		init_rom[3]	= (S1_CLKFBOUT_FRAC_EN == 0) ?
				  {7'h14, 16'h1000, S1_CLKFBOUT[15:0]}:
				  {7'h14, 16'h1000, S1_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[4] = (S1_CLKFBOUT_FRAC_EN == 0) ?
				  {7'h15, 16'h8000, S1_CLKFBOUT[31:16]}:
				  {7'h15, 16'h8000, S1_CLKFBOUT_FRAC_CALC[31:16]};

		// Store the lock settings
		init_rom[5] = {7'h18, 16'hFC00, {6'h00, S1_LOCK[29:20]}};
		init_rom[6] = {7'h19, 16'h8000, {1'b0, S1_LOCK[34:30], S1_LOCK[9:0]}};
		init_rom[7] = {7'h1A, 16'h8000, {1'b0, S1_LOCK[39:35], S1_LOCK[19:10]}};

		// Store the filter settings
		init_rom[8] = {7'h4E, 16'h66FF, S1_DIGITAL_FILT[9], 2'h0, S1_DIGITAL_FILT[8:7], 2'h0, S1_DIGITAL_FILT[6], 8'h00 };
		init_rom[9] = {7'h4F, 16'h666F, S1_DIGITAL_FILT[5], 2'h0, S1_DIGITAL_FILT[4:3], 2'h0, S1_DIGITAL_FILT[2:1], 2'h0, S1_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 2 Initialization
		//***********************************************************************
		init_rom[10]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[11]	= {7'h09, 16'h8000, S2_CLKOUT0_FRAC_CALC[31:16]};
		init_rom[12] 	= {7'h08, 16'h1000, S2_CLKOUT0_FRAC_CALC[15:0]};
		init_rom[13]	= (S2_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S2_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S2_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[14] 	= (S2_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S2_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S2_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[15] 	= {7'h18, 16'hFC00, {6'h00, S2_LOCK[29:20]}};
		init_rom[16] 	= {7'h19, 16'h8000, {1'b0, S2_LOCK[34:30], S2_LOCK[9:0]}};
		init_rom[17] 	= {7'h1A, 16'h8000, {1'b0, S2_LOCK[39:35], S2_LOCK[19:10]}};
		init_rom[18] 	= {7'h4E, 16'h66FF, S2_DIGITAL_FILT[9], 2'h0, S2_DIGITAL_FILT[8:7], 2'h0, S2_DIGITAL_FILT[6], 8'h00 };
		init_rom[19] 	= {7'h4F, 16'h666F, S2_DIGITAL_FILT[5], 2'h0, S2_DIGITAL_FILT[4:3], 2'h0, S2_DIGITAL_FILT[2:1], 2'h0, S2_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 3 Initialization
		//***********************************************************************
		init_rom[20]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[21]	= {7'h09, 16'h8000, S3_CLKOUT0_FRAC_CALC[31:16]};
		init_rom[22] 	= {7'h08, 16'h1000, S3_CLKOUT0_FRAC_CALC[15:0]};
		init_rom[23]	= (S3_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S3_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S3_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[24] 	= (S3_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S3_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S3_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[25] 	= {7'h18, 16'hFC00, {6'h00, S3_LOCK[29:20]}};
		init_rom[26] 	= {7'h19, 16'h8000, {1'b0, S3_LOCK[34:30], S3_LOCK[9:0]}};
		init_rom[27] 	= {7'h1A, 16'h8000, {1'b0, S3_LOCK[39:35], S3_LOCK[19:10]}};
		init_rom[28] 	= {7'h4E, 16'h66FF, S3_DIGITAL_FILT[9], 2'h0, S3_DIGITAL_FILT[8:7], 2'h0, S3_DIGITAL_FILT[6], 8'h00 };
		init_rom[29] 	= {7'h4F, 16'h666F, S3_DIGITAL_FILT[5], 2'h0, S3_DIGITAL_FILT[4:3], 2'h0, S3_DIGITAL_FILT[2:1], 2'h0, S3_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 4 Initialization
		//***********************************************************************
		init_rom[30]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[31]	= {7'h09, 16'h8000, S4_CLKOUT0_FRAC_CALC[31:16]};
		init_rom[32] 	= {7'h08, 16'h1000, S4_CLKOUT0_FRAC_CALC[15:0]};
		init_rom[33]	= (S4_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S4_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S4_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[34] 	= (S4_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S4_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S4_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[35] 	= {7'h18, 16'hFC00, {6'h00, S4_LOCK[29:20]}};
		init_rom[36] 	= {7'h19, 16'h8000, {1'b0, S4_LOCK[34:30], S4_LOCK[9:0]}};
		init_rom[37] 	= {7'h1A, 16'h8000, {1'b0, S4_LOCK[39:35], S4_LOCK[19:10]}};
		init_rom[38] 	= {7'h4E, 16'h66FF, S4_DIGITAL_FILT[9], 2'h0, S4_DIGITAL_FILT[8:7], 2'h0, S4_DIGITAL_FILT[6], 8'h00 };
		init_rom[39] 	= {7'h4F, 16'h666F, S4_DIGITAL_FILT[5], 2'h0, S4_DIGITAL_FILT[4:3], 2'h0, S4_DIGITAL_FILT[2:1], 2'h0, S4_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 5 Initialization
		//***********************************************************************
		init_rom[40]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[41]	= {7'h09, 16'h8000, S5_CLKOUT0_FRAC_CALC[31:16]};
		init_rom[42] 	= {7'h08, 16'h1000, S5_CLKOUT0_FRAC_CALC[15:0]};
		init_rom[43]	= (S5_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S5_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S5_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[44] 	= (S5_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S5_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S5_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[45] 	= {7'h18, 16'hFC00, {6'h00, S5_LOCK[29:20]}};
		init_rom[46] 	= {7'h19, 16'h8000, {1'b0, S5_LOCK[34:30], S5_LOCK[9:0]}};
		init_rom[47] 	= {7'h1A, 16'h8000, {1'b0, S5_LOCK[39:35], S5_LOCK[19:10]}};
		init_rom[48] 	= {7'h4E, 16'h66FF, S5_DIGITAL_FILT[9], 2'h0, S5_DIGITAL_FILT[8:7], 2'h0, S5_DIGITAL_FILT[6], 8'h00 };
		init_rom[49] 	= {7'h4F, 16'h666F, S5_DIGITAL_FILT[5], 2'h0, S5_DIGITAL_FILT[4:3], 2'h0, S5_DIGITAL_FILT[2:1], 2'h0, S5_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 6 Initialization
		//***********************************************************************
		init_rom[50]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[51]	= {7'h09, 16'h8000, S6_CLKOUT0_FRAC_CALC[31:16]};
		init_rom[52] 	= {7'h08, 16'h1000, S6_CLKOUT0_FRAC_CALC[15:0]};
		init_rom[53]	= (S6_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S6_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S6_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[54] 	= (S6_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S6_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S6_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[55] 	= {7'h18, 16'hFC00, {6'h00, S6_LOCK[29:20]}};
		init_rom[56] 	= {7'h19, 16'h8000, {1'b0, S6_LOCK[34:30], S6_LOCK[9:0]}};
		init_rom[57] 	= {7'h1A, 16'h8000, {1'b0, S6_LOCK[39:35], S6_LOCK[19:10]}};
		init_rom[58] 	= {7'h4E, 16'h66FF, S6_DIGITAL_FILT[9], 2'h0, S6_DIGITAL_FILT[8:7], 2'h0, S6_DIGITAL_FILT[6], 8'h00 };
		init_rom[59] 	= {7'h4F, 16'h666F, S6_DIGITAL_FILT[5], 2'h0, S6_DIGITAL_FILT[4:3], 2'h0, S6_DIGITAL_FILT[2:1], 2'h0, S6_DIGITAL_FILT[0], 4'h0};
		
        rom_init = init_rom[index];
	end
endfunction