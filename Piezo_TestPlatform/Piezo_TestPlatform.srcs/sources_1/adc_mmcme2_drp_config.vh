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
localparam S1_CLKOUT4_DIVIDE    = 128;
localparam S1_CLKOUT4_PHASE     = 0;
localparam S1_CLKOUT4_DUTY      = 50000;

localparam S1_CLKOUT6_DIVIDE    = 24;
localparam S1_CLKOUT6_PHASE     = 0;
localparam S1_CLKOUT6_DUTY      = 50000;

//********************
// State  2 Parameters 
//********************
localparam S2_CLKFBOUT_MULT     = 64;
localparam S2_CLKFBOUT_PHASE    = 0;
localparam S2_CLKFBOUT_FRAC     = 0;
localparam S2_CLKFBOUT_FRAC_EN  = 1;
localparam S2_BANDWIDTH         = "OPTIMIZED";
localparam S2_DIVCLK_DIVIDE     = 1;
localparam S2_CLKOUT4_DIVIDE    = 128;
localparam S2_CLKOUT4_PHASE     = 0;
localparam S2_CLKOUT4_DUTY      = 50000;
localparam S2_CLKOUT6_DIVIDE    = 12;
localparam S2_CLKOUT6_PHASE     = 0;
localparam S2_CLKOUT6_DUTY      = 50000;

//********************
// State  3 Parameters 
//********************
localparam S3_CLKFBOUT_MULT     = 64;
localparam S3_CLKFBOUT_PHASE    = 0;
localparam S3_CLKFBOUT_FRAC     = 0;
localparam S3_CLKFBOUT_FRAC_EN  = 1;
localparam S3_BANDWIDTH         = "OPTIMIZED";
localparam S3_DIVCLK_DIVIDE     = 1;
localparam S3_CLKOUT4_DIVIDE    = 128;
localparam S3_CLKOUT4_PHASE     = 0;
localparam S3_CLKOUT4_DUTY      = 50000;
localparam S3_CLKOUT6_DIVIDE    = 8;
localparam S3_CLKOUT6_PHASE     = 0;
localparam S3_CLKOUT6_DUTY      = 50000;

//********************
// State  4 Parameters 
//********************
localparam S4_CLKFBOUT_MULT     = 64;
localparam S4_CLKFBOUT_PHASE    = 0;
localparam S4_CLKFBOUT_FRAC     = 0;
localparam S4_CLKFBOUT_FRAC_EN  = 1;
localparam S4_BANDWIDTH         = "OPTIMIZED";
localparam S4_DIVCLK_DIVIDE     = 1;
localparam S4_CLKOUT4_DIVIDE    = 128;
localparam S4_CLKOUT4_PHASE     = 0;
localparam S4_CLKOUT4_DUTY      = 50000;
localparam S4_CLKOUT6_DIVIDE    = 6;
localparam S4_CLKOUT6_PHASE     = 0;
localparam S4_CLKOUT6_DUTY      = 50000;

//********************
// State  5 Parameters 
//********************
localparam S5_CLKFBOUT_MULT     = 63;
localparam S5_CLKFBOUT_PHASE    = 0;
localparam S5_CLKFBOUT_FRAC     = 750;
localparam S5_CLKFBOUT_FRAC_EN  = 1;
localparam S5_BANDWIDTH         = "OPTIMIZED";
localparam S5_DIVCLK_DIVIDE     = 1;
localparam S5_CLKOUT4_DIVIDE    = 102;
localparam S5_CLKOUT4_PHASE     = 0;
localparam S5_CLKOUT4_DUTY      = 50000;
localparam S5_CLKOUT6_DIVIDE    = 6;
localparam S5_CLKOUT6_PHASE     = 0;
localparam S5_CLKOUT6_DUTY      = 50000;

//********************
// State  6 Parameters 
//********************
localparam S6_CLKFBOUT_MULT     = 64;
localparam S6_CLKFBOUT_PHASE    = 0;
localparam S6_CLKFBOUT_FRAC     = 0;
localparam S6_CLKFBOUT_FRAC_EN  = 1;
localparam S6_BANDWIDTH         = "OPTIMIZED";
localparam S6_DIVCLK_DIVIDE     = 1;
localparam S6_CLKOUT4_DIVIDE    = 128;
localparam S6_CLKOUT4_PHASE     = 0;
localparam S6_CLKOUT4_DUTY      = 50000;
localparam S6_CLKOUT6_DIVIDE    = 4;
localparam S6_CLKOUT6_PHASE     = 0;
localparam S6_CLKOUT6_DUTY      = 50000;

//********************
// State  7 Parameters 
//********************
localparam S7_CLKFBOUT_MULT     = 63;
localparam S7_CLKFBOUT_PHASE    = 0;
localparam S7_CLKFBOUT_FRAC     = 0;
localparam S7_CLKFBOUT_FRAC_EN  = 1;
localparam S7_BANDWIDTH         = "OPTIMIZED";
localparam S7_DIVCLK_DIVIDE     = 1;
localparam S7_CLKOUT4_DIVIDE    = 108;
localparam S7_CLKOUT4_PHASE     = 0;
localparam S7_CLKOUT4_DUTY      = 50000;
localparam S7_CLKOUT6_DIVIDE    = 4;
localparam S7_CLKOUT6_PHASE     = 0;
localparam S7_CLKOUT6_DUTY      = 50000;

//********************
// State  8 Parameters 
//********************
localparam S8_CLKFBOUT_MULT     = 63;
localparam S8_CLKFBOUT_PHASE    = 0;
localparam S8_CLKFBOUT_FRAC     = 500;
localparam S8_CLKFBOUT_FRAC_EN  = 1;
localparam S8_BANDWIDTH         = "OPTIMIZED";
localparam S8_DIVCLK_DIVIDE     = 1;
localparam S8_CLKOUT4_DIVIDE    = 127;
localparam S8_CLKOUT4_PHASE     = 0;
localparam S8_CLKOUT4_DUTY      = 50000;
localparam S8_CLKOUT6_DIVIDE    = 3;
localparam S8_CLKOUT6_PHASE     = 0;
localparam S8_CLKOUT6_DUTY      = 50000;

//********************
// State  9 Parameters 
//********************
localparam S9_CLKFBOUT_MULT     = 63;
localparam S9_CLKFBOUT_PHASE    = 0;
localparam S9_CLKFBOUT_FRAC     = 750;
localparam S9_CLKFBOUT_FRAC_EN  = 1;
localparam S9_BANDWIDTH         = "OPTIMIZED";
localparam S9_DIVCLK_DIVIDE     = 1;
localparam S9_CLKOUT4_DIVIDE    = 85;
localparam S9_CLKOUT4_PHASE     = 0;
localparam S9_CLKOUT4_DUTY      = 50000;
localparam S9_CLKOUT6_DIVIDE    = 4;
localparam S9_CLKOUT6_PHASE     = 0;
localparam S9_CLKOUT6_DUTY      = 50000;

//********************
// State 10 Parameters 
//********************
localparam S10_CLKFBOUT_MULT    = 63;
localparam S10_CLKFBOUT_PHASE   = 0;
localparam S10_CLKFBOUT_FRAC    = 750;
localparam S10_CLKFBOUT_FRAC_EN = 1;
localparam S10_BANDWIDTH        = "OPTIMIZED";
localparam S10_DIVCLK_DIVIDE    = 1;
localparam S10_CLKOUT4_DIVIDE   = 102;
localparam S10_CLKOUT4_PHASE    = 0;
localparam S10_CLKOUT4_DUTY     = 50000;
localparam S10_CLKOUT6_DIVIDE   = 3;
localparam S10_CLKOUT6_PHASE    = 0;
localparam S10_CLKOUT6_DUTY     = 50000;

//********************
// State 11 Parameters 
//********************
localparam S11_CLKFBOUT_MULT    = 61;
localparam S11_CLKFBOUT_PHASE   = 0;
localparam S11_CLKFBOUT_FRAC    = 875;
localparam S11_CLKFBOUT_FRAC_EN = 1;
localparam S11_BANDWIDTH        = "OPTIMIZED";
localparam S11_DIVCLK_DIVIDE    = 1;
localparam S11_CLKOUT4_DIVIDE   = 90;
localparam S11_CLKOUT4_PHASE    = 0;
localparam S11_CLKOUT4_DUTY     = 50000;
localparam S11_CLKOUT6_DIVIDE   = 3;
localparam S11_CLKOUT6_PHASE    = 0;
localparam S11_CLKOUT6_DUTY     = 50000;

//********************
// State 12 Parameters 
//********************
localparam S12_CLKFBOUT_MULT    = 63;
localparam S12_CLKFBOUT_PHASE   = 0;
localparam S12_CLKFBOUT_FRAC    = 750;
localparam S12_CLKFBOUT_FRAC_EN = 1;
localparam S12_BANDWIDTH        = "OPTIMIZED";
localparam S12_DIVCLK_DIVIDE    = 1;
localparam S12_CLKOUT4_DIVIDE   = 85;
localparam S12_CLKOUT4_PHASE    = 0;
localparam S12_CLKOUT4_DUTY     = 50000;
localparam S12_CLKOUT6_DIVIDE   = 3;
localparam S12_CLKOUT6_PHASE    = 0;
localparam S12_CLKOUT6_DUTY     = 50000;

//********************
// State 13 Parameters 
//********************
localparam S13_CLKFBOUT_MULT    = 63;
localparam S13_CLKFBOUT_PHASE   = 0;
localparam S13_CLKFBOUT_FRAC    = 375;
localparam S13_CLKFBOUT_FRAC_EN = 1;
localparam S13_BANDWIDTH        = "OPTIMIZED";
localparam S13_DIVCLK_DIVIDE    = 1;
localparam S13_CLKOUT4_DIVIDE   = 117;
localparam S13_CLKOUT4_PHASE    = 0;
localparam S13_CLKOUT4_DUTY     = 50000;
localparam S13_CLKOUT6_DIVIDE   = 2;
localparam S13_CLKOUT6_PHASE    = 0;
localparam S13_CLKOUT6_DUTY     = 50000;

//********************
// State 14 Parameters 
//********************
localparam S14_CLKFBOUT_MULT    = 63;
localparam S14_CLKFBOUT_PHASE   = 0;
localparam S14_CLKFBOUT_FRAC    = 0;
localparam S14_CLKFBOUT_FRAC_EN = 1;
localparam S14_BANDWIDTH        = "OPTIMIZED";
localparam S14_DIVCLK_DIVIDE    = 1;
localparam S14_CLKOUT4_DIVIDE   = 108;
localparam S14_CLKOUT4_PHASE    = 0;
localparam S14_CLKOUT4_DUTY     = 50000;
localparam S14_CLKOUT6_DIVIDE   = 2;
localparam S14_CLKOUT6_PHASE    = 0;
localparam S14_CLKOUT6_DUTY     = 50000;

//********************
// State 15 Parameters 
//********************
localparam S15_CLKFBOUT_MULT    = 63;
localparam S15_CLKFBOUT_PHASE   = 0;
localparam S15_CLKFBOUT_FRAC    = 750;
localparam S15_CLKFBOUT_FRAC_EN = 1;
localparam S15_BANDWIDTH        = "OPTIMIZED";
localparam S15_DIVCLK_DIVIDE    = 1;
localparam S15_CLKOUT4_DIVIDE   = 102;
localparam S15_CLKOUT4_PHASE    = 0;
localparam S15_CLKOUT4_DUTY     = 50000;
localparam S15_CLKOUT6_DIVIDE   = 2;
localparam S15_CLKOUT6_PHASE    = 0;
localparam S15_CLKOUT6_DUTY     = 50000;

//********************
// State 16 Parameters 
//********************
localparam S16_CLKFBOUT_MULT    = 64;
localparam S16_CLKFBOUT_PHASE   = 0;
localparam S16_CLKFBOUT_FRAC    = 0;
localparam S16_CLKFBOUT_FRAC_EN = 1;
localparam S16_BANDWIDTH        = "OPTIMIZED";
localparam S16_DIVCLK_DIVIDE    = 1;
localparam S16_CLKOUT4_DIVIDE   = 96;
localparam S16_CLKOUT4_PHASE    = 0;
localparam S16_CLKOUT4_DUTY     = 50000;
localparam S16_CLKOUT6_DIVIDE   = 2;
localparam S16_CLKOUT6_PHASE    = 0;
localparam S16_CLKOUT6_DUTY     = 50000;

//********************
// State 17 Parameters 
//********************
localparam S17_CLKFBOUT_MULT    = 63;
localparam S17_CLKFBOUT_PHASE   = 0;
localparam S17_CLKFBOUT_FRAC    = 750;
localparam S17_CLKFBOUT_FRAC_EN = 1;
localparam S17_BANDWIDTH        = "OPTIMIZED";
localparam S17_DIVCLK_DIVIDE    = 1;
localparam S17_CLKOUT4_DIVIDE   = 90;
localparam S17_CLKOUT4_PHASE    = 0;
localparam S17_CLKOUT4_DUTY     = 50000;
localparam S17_CLKOUT6_DIVIDE   = 2;
localparam S17_CLKOUT6_PHASE    = 0;
localparam S17_CLKOUT6_DUTY     = 50000;

//********************
// State 18 Parameters 
//********************
localparam S18_CLKFBOUT_MULT    = 63;
localparam S18_CLKFBOUT_PHASE   = 0;
localparam S18_CLKFBOUT_FRAC    = 0;
localparam S18_CLKFBOUT_FRAC_EN = 1;
localparam S18_BANDWIDTH        = "OPTIMIZED";
localparam S18_DIVCLK_DIVIDE    = 1;
localparam S18_CLKOUT4_DIVIDE   = 84;
localparam S18_CLKOUT4_PHASE    = 0;
localparam S18_CLKOUT4_DUTY     = 50000;
localparam S18_CLKOUT6_DIVIDE   = 2;
localparam S18_CLKOUT6_PHASE    = 0;
localparam S18_CLKOUT6_DUTY     = 50000;

//********************
// State 19 Parameters 
//********************
localparam S19_CLKFBOUT_MULT    = 59;
localparam S19_CLKFBOUT_PHASE   = 0;
localparam S19_CLKFBOUT_FRAC    = 375;
localparam S19_CLKFBOUT_FRAC_EN = 1;
localparam S19_BANDWIDTH        = "OPTIMIZED";
localparam S19_DIVCLK_DIVIDE    = 1;
localparam S19_CLKOUT4_DIVIDE   = 75;
localparam S19_CLKOUT4_PHASE    = 0;
localparam S19_CLKOUT4_DUTY     = 50000;
localparam S19_CLKOUT6_DIVIDE   = 2;
localparam S19_CLKOUT6_PHASE    = 0;
localparam S19_CLKOUT6_DUTY     = 50000;

//********************
// State 20 Parameters 
//********************
localparam S20_CLKFBOUT_MULT    = 63;
localparam S20_CLKFBOUT_PHASE   = 0;
localparam S20_CLKFBOUT_FRAC    = 750;
localparam S20_CLKFBOUT_FRAC_EN = 1;
localparam S20_BANDWIDTH        = "OPTIMIZED";
localparam S20_DIVCLK_DIVIDE    = 1;
localparam S20_CLKOUT4_DIVIDE   = 51;
localparam S20_CLKOUT4_PHASE    = 0;
localparam S20_CLKOUT4_DUTY     = 50000;
localparam S20_CLKOUT6_DIVIDE   = 3;
localparam S20_CLKOUT6_PHASE    = 0;
localparam S20_CLKOUT6_DUTY     = 50000;

//********************
// State 21 Parameters 
//********************
localparam S21_CLKFBOUT_MULT    = 63;
localparam S21_CLKFBOUT_PHASE   = 0;
localparam S21_CLKFBOUT_FRAC    = 0;
localparam S21_CLKFBOUT_FRAC_EN = 1;
localparam S21_BANDWIDTH        = "OPTIMIZED";
localparam S21_DIVCLK_DIVIDE    = 1;
localparam S21_CLKOUT4_DIVIDE   = 72;
localparam S21_CLKOUT4_PHASE    = 0;
localparam S21_CLKOUT4_DUTY     = 50000;
localparam S21_CLKOUT6_DIVIDE   = 2;
localparam S21_CLKOUT6_PHASE    = 0;
localparam S21_CLKOUT6_DUTY     = 50000;

//********************
// State 22 Parameters 
//********************
localparam S22_CLKFBOUT_MULT    = 60;
localparam S22_CLKFBOUT_PHASE   = 0;
localparam S22_CLKFBOUT_FRAC    = 500;
localparam S22_CLKFBOUT_FRAC_EN = 1;
localparam S22_BANDWIDTH        = "OPTIMIZED";
localparam S22_DIVCLK_DIVIDE    = 1;
localparam S22_CLKOUT4_DIVIDE   = 66;
localparam S22_CLKOUT4_PHASE    = 0;
localparam S22_CLKOUT4_DUTY     = 50000;
localparam S22_CLKOUT6_DIVIDE   = 2;
localparam S22_CLKOUT6_PHASE    = 0;
localparam S22_CLKOUT6_DUTY     = 50000;

//********************
// State 23 Parameters 
//********************
localparam S23_CLKFBOUT_MULT    = 60;
localparam S23_CLKFBOUT_PHASE   = 0;
localparam S23_CLKFBOUT_FRAC    = 375;
localparam S23_CLKFBOUT_FRAC_EN = 1;
localparam S23_BANDWIDTH        = "OPTIMIZED";
localparam S23_DIVCLK_DIVIDE    = 1;
localparam S23_CLKOUT4_DIVIDE   = 126;
localparam S23_CLKOUT4_PHASE    = 0;
localparam S23_CLKOUT4_DUTY     = 50000;
localparam S23_CLKOUT6_DIVIDE   = 1;
localparam S23_CLKOUT6_PHASE    = 0;
localparam S23_CLKOUT6_DUTY     = 50000;

//********************
// State 24 Parameters 
//********************
localparam S24_CLKFBOUT_MULT    = 64;
localparam S24_CLKFBOUT_PHASE   = 0;
localparam S24_CLKFBOUT_FRAC    = 0;
localparam S24_CLKFBOUT_FRAC_EN = 1;
localparam S24_BANDWIDTH        = "OPTIMIZED";
localparam S24_DIVCLK_DIVIDE    = 1;
localparam S24_CLKOUT4_DIVIDE   = 128;
localparam S24_CLKOUT4_PHASE    = 0;
localparam S24_CLKOUT4_DUTY     = 50000;
localparam S24_CLKOUT6_DIVIDE   = 1;
localparam S24_CLKOUT6_PHASE    = 0;
localparam S24_CLKOUT6_DUTY     = 50000;

//********************
// State 25 Parameters 
//********************
localparam S25_CLKFBOUT_MULT    = 62;
localparam S25_CLKFBOUT_PHASE   = 0;
localparam S25_CLKFBOUT_FRAC    = 500;
localparam S25_CLKFBOUT_FRAC_EN = 1;
localparam S25_BANDWIDTH        = "OPTIMIZED";
localparam S25_DIVCLK_DIVIDE    = 1;
localparam S25_CLKOUT4_DIVIDE   = 120;
localparam S25_CLKOUT4_PHASE    = 0;
localparam S25_CLKOUT4_DUTY     = 50000;
localparam S25_CLKOUT6_DIVIDE   = 1;
localparam S25_CLKOUT6_PHASE    = 0;
localparam S25_CLKOUT6_DUTY     = 50000;

//********************
// State 26 Parameters 
//********************
localparam S26_CLKFBOUT_MULT    = 63;
localparam S26_CLKFBOUT_PHASE   = 0;
localparam S26_CLKFBOUT_FRAC    = 375;
localparam S26_CLKFBOUT_FRAC_EN = 1;
localparam S26_BANDWIDTH        = "OPTIMIZED";
localparam S26_DIVCLK_DIVIDE    = 1;
localparam S26_CLKOUT4_DIVIDE   = 117;
localparam S26_CLKOUT4_PHASE    = 0;
localparam S26_CLKOUT4_DUTY     = 50000;
localparam S26_CLKOUT6_DIVIDE   = 1;
localparam S26_CLKOUT6_PHASE    = 0;
localparam S26_CLKOUT6_DUTY     = 50000;

//********************
// State 27 Parameters 
//********************
localparam S27_CLKFBOUT_MULT    = 63;
localparam S27_CLKFBOUT_PHASE   = 0;
localparam S27_CLKFBOUT_FRAC    = 0;
localparam S27_CLKFBOUT_FRAC_EN = 1;
localparam S27_BANDWIDTH        = "OPTIMIZED";
localparam S27_DIVCLK_DIVIDE    = 1;
localparam S27_CLKOUT4_DIVIDE   = 112;
localparam S27_CLKOUT4_PHASE    = 0;
localparam S27_CLKOUT4_DUTY     = 50000;
localparam S27_CLKOUT6_DIVIDE   = 1;
localparam S27_CLKOUT6_PHASE    = 0;
localparam S27_CLKOUT6_DUTY     = 50000;

//********************
// State 28 Parameters 
//********************
localparam S28_CLKFBOUT_MULT    = 63;
localparam S28_CLKFBOUT_PHASE   = 0;
localparam S28_CLKFBOUT_FRAC    = 0;
localparam S28_CLKFBOUT_FRAC_EN = 1;
localparam S28_BANDWIDTH        = "OPTIMIZED";
localparam S28_DIVCLK_DIVIDE    = 1;
localparam S28_CLKOUT4_DIVIDE   = 108;
localparam S28_CLKOUT4_PHASE    = 0;
localparam S28_CLKOUT4_DUTY     = 50000;
localparam S28_CLKOUT6_DIVIDE   = 1;
localparam S28_CLKOUT6_PHASE    = 0;
localparam S28_CLKOUT6_DUTY     = 50000;

//********************
// State 29 Parameters 
//********************
localparam S29_CLKFBOUT_MULT    = 61;
localparam S29_CLKFBOUT_PHASE   = 0;
localparam S29_CLKFBOUT_FRAC    = 625;
localparam S29_CLKFBOUT_FRAC_EN = 1;
localparam S29_BANDWIDTH        = "OPTIMIZED";
localparam S29_DIVCLK_DIVIDE    = 1;
localparam S29_CLKOUT4_DIVIDE   = 102;
localparam S29_CLKOUT4_PHASE    = 0;
localparam S29_CLKOUT4_DUTY     = 50000;
localparam S29_CLKOUT6_DIVIDE   = 1;
localparam S29_CLKOUT6_PHASE    = 0;
localparam S29_CLKOUT6_DUTY     = 50000;

//********************
// State 30 Parameters 
//********************
localparam S30_CLKFBOUT_MULT    = 63;
localparam S30_CLKFBOUT_PHASE   = 0;
localparam S30_CLKFBOUT_FRAC    = 750;
localparam S30_CLKFBOUT_FRAC_EN = 1;
localparam S30_BANDWIDTH        = "OPTIMIZED";
localparam S30_DIVCLK_DIVIDE    = 1;
localparam S30_CLKOUT4_DIVIDE   = 102;
localparam S30_CLKOUT4_PHASE    = 0;
localparam S30_CLKOUT4_DUTY     = 50000;
localparam S30_CLKOUT6_DIVIDE   = 1;
localparam S30_CLKOUT6_PHASE    = 0;
localparam S30_CLKOUT6_DUTY     = 50000;

//********************
// State 31 Parameters 
//********************
localparam S31_CLKFBOUT_MULT    = 62;
localparam S31_CLKFBOUT_PHASE   = 0;
localparam S31_CLKFBOUT_FRAC    = 0;
localparam S31_CLKFBOUT_FRAC_EN = 1;
localparam S31_BANDWIDTH        = "OPTIMIZED";
localparam S31_DIVCLK_DIVIDE    = 1;
localparam S31_CLKOUT4_DIVIDE   = 96;
localparam S31_CLKOUT4_PHASE    = 0;
localparam S31_CLKOUT4_DUTY     = 50000;
localparam S31_CLKOUT6_DIVIDE   = 1;
localparam S31_CLKOUT6_PHASE    = 0;
localparam S31_CLKOUT6_DUTY     = 50000;

//********************
// State 32 Parameters 
//********************
localparam S32_CLKFBOUT_MULT    = 64;
localparam S32_CLKFBOUT_PHASE   = 0;
localparam S32_CLKFBOUT_FRAC    = 0;
localparam S32_CLKFBOUT_FRAC_EN = 1;
localparam S32_BANDWIDTH        = "OPTIMIZED";
localparam S32_DIVCLK_DIVIDE    = 1;
localparam S32_CLKOUT4_DIVIDE   = 96;
localparam S32_CLKOUT4_PHASE    = 0;
localparam S32_CLKOUT4_DUTY     = 50000;
localparam S32_CLKOUT6_DIVIDE   = 1;
localparam S32_CLKOUT6_PHASE    = 0;
localparam S32_CLKOUT6_DUTY     = 50000;

//********************
// State 33 Parameters 
//********************
localparam S33_CLKFBOUT_MULT    = 63;
localparam S33_CLKFBOUT_PHASE   = 0;
localparam S33_CLKFBOUT_FRAC    = 250;
localparam S33_CLKFBOUT_FRAC_EN = 1;
localparam S33_BANDWIDTH        = "OPTIMIZED";
localparam S33_DIVCLK_DIVIDE    = 1;
localparam S33_CLKOUT4_DIVIDE   = 92;
localparam S33_CLKOUT4_PHASE    = 0;
localparam S33_CLKOUT4_DUTY     = 50000;
localparam S33_CLKOUT6_DIVIDE   = 1;
localparam S33_CLKOUT6_PHASE    = 0;
localparam S33_CLKOUT6_DUTY     = 50000;

//********************
// State 34 Parameters 
//********************
localparam S34_CLKFBOUT_MULT    = 63;
localparam S34_CLKFBOUT_PHASE   = 0;
localparam S34_CLKFBOUT_FRAC    = 750;
localparam S34_CLKFBOUT_FRAC_EN = 1;
localparam S34_BANDWIDTH        = "OPTIMIZED";
localparam S34_DIVCLK_DIVIDE    = 1;
localparam S34_CLKOUT4_DIVIDE   = 90;
localparam S34_CLKOUT4_PHASE    = 0;
localparam S34_CLKOUT4_DUTY     = 50000;
localparam S34_CLKOUT6_DIVIDE   = 1;
localparam S34_CLKOUT6_PHASE    = 0;
localparam S34_CLKOUT6_DUTY     = 50000;

//********************
// State 35 Parameters 
//********************
localparam S35_CLKFBOUT_MULT    = 61;
localparam S35_CLKFBOUT_PHASE   = 0;
localparam S35_CLKFBOUT_FRAC    = 250;
localparam S35_CLKFBOUT_FRAC_EN = 1;
localparam S35_BANDWIDTH        = "OPTIMIZED";
localparam S35_DIVCLK_DIVIDE    = 1;
localparam S35_CLKOUT4_DIVIDE   = 84;
localparam S35_CLKOUT4_PHASE    = 0;
localparam S35_CLKOUT4_DUTY     = 50000;
localparam S35_CLKOUT6_DIVIDE   = 1;
localparam S35_CLKOUT6_PHASE    = 0;
localparam S35_CLKOUT6_DUTY     = 50000;

//********************
// State 36 Parameters 
//********************
localparam S36_CLKFBOUT_MULT    = 63;
localparam S36_CLKFBOUT_PHASE   = 0;
localparam S36_CLKFBOUT_FRAC    = 750;
localparam S36_CLKFBOUT_FRAC_EN = 1;
localparam S36_BANDWIDTH        = "OPTIMIZED";
localparam S36_DIVCLK_DIVIDE    = 1;
localparam S36_CLKOUT4_DIVIDE   = 85;
localparam S36_CLKOUT4_PHASE    = 0;
localparam S36_CLKOUT4_DUTY     = 50000;
localparam S36_CLKOUT6_DIVIDE   = 1;
localparam S36_CLKOUT6_PHASE    = 0;
localparam S36_CLKOUT6_DUTY     = 50000;

//********************
// State 37 Parameters 
//********************
localparam S37_CLKFBOUT_MULT    = 60;
localparam S37_CLKFBOUT_PHASE   = 0;
localparam S37_CLKFBOUT_FRAC    = 125;
localparam S37_CLKFBOUT_FRAC_EN = 1;
localparam S37_BANDWIDTH        = "OPTIMIZED";
localparam S37_DIVCLK_DIVIDE    = 1;
localparam S37_CLKOUT4_DIVIDE   = 78;
localparam S37_CLKOUT4_PHASE    = 0;
localparam S37_CLKOUT4_DUTY     = 50000;
localparam S37_CLKOUT6_DIVIDE   = 1;
localparam S37_CLKOUT6_PHASE    = 0;
localparam S37_CLKOUT6_DUTY     = 50000;

//********************
// State 38 Parameters 
//********************
localparam S38_CLKFBOUT_MULT    = 61;
localparam S38_CLKFBOUT_PHASE   = 0;
localparam S38_CLKFBOUT_FRAC    = 750;
localparam S38_CLKFBOUT_FRAC_EN = 1;
localparam S38_BANDWIDTH        = "OPTIMIZED";
localparam S38_DIVCLK_DIVIDE    = 1;
localparam S38_CLKOUT4_DIVIDE   = 78;
localparam S38_CLKOUT4_PHASE    = 0;
localparam S38_CLKOUT4_DUTY     = 50000;
localparam S38_CLKOUT6_DIVIDE   = 1;
localparam S38_CLKOUT6_PHASE    = 0;
localparam S38_CLKOUT6_DUTY     = 50000;

//********************
// State 39 Parameters 
//********************
localparam S39_CLKFBOUT_MULT    = 63;
localparam S39_CLKFBOUT_PHASE   = 0;
localparam S39_CLKFBOUT_FRAC    = 375;
localparam S39_CLKFBOUT_FRAC_EN = 1;
localparam S39_BANDWIDTH        = "OPTIMIZED";
localparam S39_DIVCLK_DIVIDE    = 1;
localparam S39_CLKOUT4_DIVIDE   = 78;
localparam S39_CLKOUT4_PHASE    = 0;
localparam S39_CLKOUT4_DUTY     = 50000;
localparam S39_CLKOUT6_DIVIDE   = 1;
localparam S39_CLKOUT6_PHASE    = 0;
localparam S39_CLKOUT6_DUTY     = 50000;

//********************
// State 40 Parameters 
//********************
localparam S40_CLKFBOUT_MULT    = 62;
localparam S40_CLKFBOUT_PHASE   = 0;
localparam S40_CLKFBOUT_FRAC    = 500;
localparam S40_CLKFBOUT_FRAC_EN = 1;
localparam S40_BANDWIDTH        = "OPTIMIZED";
localparam S40_DIVCLK_DIVIDE    = 1;
localparam S40_CLKOUT4_DIVIDE   = 75;
localparam S40_CLKOUT4_PHASE    = 0;
localparam S40_CLKOUT4_DUTY     = 50000;
localparam S40_CLKOUT6_DIVIDE   = 1;
localparam S40_CLKOUT6_PHASE    = 0;
localparam S40_CLKOUT6_DUTY     = 50000;



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
localparam [37:0] S1_CLKOUT4             = mmcm_casc_count_calc(S1_CLKOUT4_DIVIDE, S1_CLKOUT4_PHASE, S1_CLKOUT4_DUTY);
localparam [37:0] S1_CLKOUT6             = mmcm_count_calc(S1_CLKOUT6_DIVIDE, S1_CLKOUT6_PHASE, S1_CLKOUT6_DUTY);

//**********************
// State  2 Calculations
//**********************
localparam [37:0] S2_CLKFBOUT            = mmcm_count_calc(S2_CLKFBOUT_MULT, S2_CLKFBOUT_PHASE, 50000);
localparam [37:0] S2_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S2_CLKFBOUT_MULT, S2_CLKFBOUT_PHASE, 50000, S2_CLKFBOUT_FRAC);
localparam [9:0]  S2_DIGITAL_FILT        = mmcm_filter_lookup(S2_CLKFBOUT_MULT, S2_BANDWIDTH);
localparam [39:0] S2_LOCK                = mmcm_lock_lookup(S2_CLKFBOUT_MULT);
localparam [37:0] S2_DIVCLK              = mmcm_count_calc(S2_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S2_CLKOUT4             = mmcm_casc_count_calc(S2_CLKOUT4_DIVIDE, S2_CLKOUT4_PHASE, S2_CLKOUT4_DUTY);
localparam [37:0] S2_CLKOUT6             = mmcm_count_calc(S2_CLKOUT6_DIVIDE, S2_CLKOUT6_PHASE, S2_CLKOUT6_DUTY);

//**********************
// State  3 Calculations
//**********************
localparam [37:0] S3_CLKFBOUT            = mmcm_count_calc(S3_CLKFBOUT_MULT, S3_CLKFBOUT_PHASE, 50000);
localparam [37:0] S3_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S3_CLKFBOUT_MULT, S3_CLKFBOUT_PHASE, 50000, S3_CLKFBOUT_FRAC);
localparam [9:0]  S3_DIGITAL_FILT        = mmcm_filter_lookup(S3_CLKFBOUT_MULT, S3_BANDWIDTH);
localparam [39:0] S3_LOCK                = mmcm_lock_lookup(S3_CLKFBOUT_MULT);
localparam [37:0] S3_DIVCLK              = mmcm_count_calc(S3_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S3_CLKOUT4             = mmcm_casc_count_calc(S3_CLKOUT4_DIVIDE, S3_CLKOUT4_PHASE, S3_CLKOUT4_DUTY);
localparam [37:0] S3_CLKOUT6             = mmcm_count_calc(S3_CLKOUT6_DIVIDE, S3_CLKOUT6_PHASE, S3_CLKOUT6_DUTY);

//**********************
// State  4 Calculations
//**********************
localparam [37:0] S4_CLKFBOUT            = mmcm_count_calc(S4_CLKFBOUT_MULT, S4_CLKFBOUT_PHASE, 50000);
localparam [37:0] S4_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S4_CLKFBOUT_MULT, S4_CLKFBOUT_PHASE, 50000, S4_CLKFBOUT_FRAC);
localparam [9:0]  S4_DIGITAL_FILT        = mmcm_filter_lookup(S4_CLKFBOUT_MULT, S4_BANDWIDTH);
localparam [39:0] S4_LOCK                = mmcm_lock_lookup(S4_CLKFBOUT_MULT);
localparam [37:0] S4_DIVCLK              = mmcm_count_calc(S4_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S4_CLKOUT4             = mmcm_casc_count_calc(S4_CLKOUT4_DIVIDE, S4_CLKOUT4_PHASE, S4_CLKOUT4_DUTY);
localparam [37:0] S4_CLKOUT6             = mmcm_count_calc(S4_CLKOUT6_DIVIDE, S4_CLKOUT6_PHASE, S4_CLKOUT6_DUTY);

//**********************
// State  5 Calculations
//**********************
localparam [37:0] S5_CLKFBOUT            = mmcm_count_calc(S5_CLKFBOUT_MULT, S5_CLKFBOUT_PHASE, 50000);
localparam [37:0] S5_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S5_CLKFBOUT_MULT, S5_CLKFBOUT_PHASE, 50000, S5_CLKFBOUT_FRAC);
localparam [9:0]  S5_DIGITAL_FILT        = mmcm_filter_lookup(S5_CLKFBOUT_MULT, S5_BANDWIDTH);
localparam [39:0] S5_LOCK                = mmcm_lock_lookup(S5_CLKFBOUT_MULT);
localparam [37:0] S5_DIVCLK              = mmcm_count_calc(S5_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S5_CLKOUT4             = mmcm_casc_count_calc(S5_CLKOUT4_DIVIDE, S5_CLKOUT4_PHASE, S5_CLKOUT4_DUTY);
localparam [37:0] S5_CLKOUT6             = mmcm_count_calc(S5_CLKOUT6_DIVIDE, S5_CLKOUT6_PHASE, S5_CLKOUT6_DUTY);

//**********************
// State  6 Calculations
//**********************
localparam [37:0] S6_CLKFBOUT            = mmcm_count_calc(S6_CLKFBOUT_MULT, S6_CLKFBOUT_PHASE, 50000);
localparam [37:0] S6_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S6_CLKFBOUT_MULT, S6_CLKFBOUT_PHASE, 50000, S6_CLKFBOUT_FRAC);
localparam [9:0]  S6_DIGITAL_FILT        = mmcm_filter_lookup(S6_CLKFBOUT_MULT, S6_BANDWIDTH);
localparam [39:0] S6_LOCK                = mmcm_lock_lookup(S6_CLKFBOUT_MULT);
localparam [37:0] S6_DIVCLK              = mmcm_count_calc(S6_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S6_CLKOUT4             = mmcm_casc_count_calc(S6_CLKOUT4_DIVIDE, S6_CLKOUT4_PHASE, S6_CLKOUT4_DUTY);
localparam [37:0] S6_CLKOUT6             = mmcm_count_calc(S6_CLKOUT6_DIVIDE, S6_CLKOUT6_PHASE, S6_CLKOUT6_DUTY);

//**********************
// State  7 Calculations
//**********************
localparam [37:0] S7_CLKFBOUT            = mmcm_count_calc(S7_CLKFBOUT_MULT, S7_CLKFBOUT_PHASE, 50000);
localparam [37:0] S7_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S7_CLKFBOUT_MULT, S7_CLKFBOUT_PHASE, 50000, S7_CLKFBOUT_FRAC);
localparam [9:0]  S7_DIGITAL_FILT        = mmcm_filter_lookup(S7_CLKFBOUT_MULT, S7_BANDWIDTH);
localparam [39:0] S7_LOCK                = mmcm_lock_lookup(S7_CLKFBOUT_MULT);
localparam [37:0] S7_DIVCLK              = mmcm_count_calc(S7_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S7_CLKOUT4             = mmcm_casc_count_calc(S7_CLKOUT4_DIVIDE, S7_CLKOUT4_PHASE, S7_CLKOUT4_DUTY);
localparam [37:0] S7_CLKOUT6             = mmcm_count_calc(S7_CLKOUT6_DIVIDE, S7_CLKOUT6_PHASE, S7_CLKOUT6_DUTY);

//**********************
// State  8 Calculations
//**********************
localparam [37:0] S8_CLKFBOUT            = mmcm_count_calc(S8_CLKFBOUT_MULT, S8_CLKFBOUT_PHASE, 50000);
localparam [37:0] S8_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S8_CLKFBOUT_MULT, S8_CLKFBOUT_PHASE, 50000, S8_CLKFBOUT_FRAC);
localparam [9:0]  S8_DIGITAL_FILT        = mmcm_filter_lookup(S8_CLKFBOUT_MULT, S8_BANDWIDTH);
localparam [39:0] S8_LOCK                = mmcm_lock_lookup(S8_CLKFBOUT_MULT);
localparam [37:0] S8_DIVCLK              = mmcm_count_calc(S8_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S8_CLKOUT4             = mmcm_casc_count_calc(S8_CLKOUT4_DIVIDE, S8_CLKOUT4_PHASE, S8_CLKOUT4_DUTY);
localparam [37:0] S8_CLKOUT6             = mmcm_count_calc(S8_CLKOUT6_DIVIDE, S8_CLKOUT6_PHASE, S8_CLKOUT6_DUTY);

//**********************
// State  9 Calculations
//**********************
localparam [37:0] S9_CLKFBOUT            = mmcm_count_calc(S9_CLKFBOUT_MULT, S9_CLKFBOUT_PHASE, 50000);
localparam [37:0] S9_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S9_CLKFBOUT_MULT, S9_CLKFBOUT_PHASE, 50000, S9_CLKFBOUT_FRAC);
localparam [9:0]  S9_DIGITAL_FILT        = mmcm_filter_lookup(S9_CLKFBOUT_MULT, S9_BANDWIDTH);
localparam [39:0] S9_LOCK                = mmcm_lock_lookup(S9_CLKFBOUT_MULT);
localparam [37:0] S9_DIVCLK              = mmcm_count_calc(S9_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S9_CLKOUT4             = mmcm_casc_count_calc(S9_CLKOUT4_DIVIDE, S9_CLKOUT4_PHASE, S9_CLKOUT4_DUTY);
localparam [37:0] S9_CLKOUT6             = mmcm_count_calc(S9_CLKOUT6_DIVIDE, S9_CLKOUT6_PHASE, S9_CLKOUT6_DUTY);

//**********************
// State 10 Calculations
//**********************
localparam [37:0] S10_CLKFBOUT            = mmcm_count_calc(S10_CLKFBOUT_MULT, S10_CLKFBOUT_PHASE, 50000);
localparam [37:0] S10_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S10_CLKFBOUT_MULT, S10_CLKFBOUT_PHASE, 50000, S10_CLKFBOUT_FRAC);
localparam [9:0]  S10_DIGITAL_FILT        = mmcm_filter_lookup(S10_CLKFBOUT_MULT, S10_BANDWIDTH);
localparam [39:0] S10_LOCK                = mmcm_lock_lookup(S10_CLKFBOUT_MULT);
localparam [37:0] S10_DIVCLK              = mmcm_count_calc(S10_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S10_CLKOUT4             = mmcm_casc_count_calc(S10_CLKOUT4_DIVIDE, S10_CLKOUT4_PHASE, S10_CLKOUT4_DUTY);
localparam [37:0] S10_CLKOUT6             = mmcm_count_calc(S10_CLKOUT6_DIVIDE, S10_CLKOUT6_PHASE, S10_CLKOUT6_DUTY);

//**********************
// State 11 Calculations
//**********************
localparam [37:0] S11_CLKFBOUT            = mmcm_count_calc(S11_CLKFBOUT_MULT, S11_CLKFBOUT_PHASE, 50000);
localparam [37:0] S11_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S11_CLKFBOUT_MULT, S11_CLKFBOUT_PHASE, 50000, S11_CLKFBOUT_FRAC);
localparam [9:0]  S11_DIGITAL_FILT        = mmcm_filter_lookup(S11_CLKFBOUT_MULT, S11_BANDWIDTH);
localparam [39:0] S11_LOCK                = mmcm_lock_lookup(S11_CLKFBOUT_MULT);
localparam [37:0] S11_DIVCLK              = mmcm_count_calc(S11_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S11_CLKOUT4             = mmcm_casc_count_calc(S11_CLKOUT4_DIVIDE, S11_CLKOUT4_PHASE, S11_CLKOUT4_DUTY);
localparam [37:0] S11_CLKOUT6             = mmcm_count_calc(S11_CLKOUT6_DIVIDE, S11_CLKOUT6_PHASE, S11_CLKOUT6_DUTY);

//**********************
// State 12 Calculations
//**********************
localparam [37:0] S12_CLKFBOUT            = mmcm_count_calc(S12_CLKFBOUT_MULT, S12_CLKFBOUT_PHASE, 50000);
localparam [37:0] S12_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S12_CLKFBOUT_MULT, S12_CLKFBOUT_PHASE, 50000, S12_CLKFBOUT_FRAC);
localparam [9:0]  S12_DIGITAL_FILT        = mmcm_filter_lookup(S12_CLKFBOUT_MULT, S12_BANDWIDTH);
localparam [39:0] S12_LOCK                = mmcm_lock_lookup(S12_CLKFBOUT_MULT);
localparam [37:0] S12_DIVCLK              = mmcm_count_calc(S12_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S12_CLKOUT4             = mmcm_casc_count_calc(S12_CLKOUT4_DIVIDE, S12_CLKOUT4_PHASE, S12_CLKOUT4_DUTY);
localparam [37:0] S12_CLKOUT6             = mmcm_count_calc(S12_CLKOUT6_DIVIDE, S12_CLKOUT6_PHASE, S12_CLKOUT6_DUTY);

//**********************
// State 13 Calculations
//**********************
localparam [37:0] S13_CLKFBOUT            = mmcm_count_calc(S13_CLKFBOUT_MULT, S13_CLKFBOUT_PHASE, 50000);
localparam [37:0] S13_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S13_CLKFBOUT_MULT, S13_CLKFBOUT_PHASE, 50000, S13_CLKFBOUT_FRAC);
localparam [9:0]  S13_DIGITAL_FILT        = mmcm_filter_lookup(S13_CLKFBOUT_MULT, S13_BANDWIDTH);
localparam [39:0] S13_LOCK                = mmcm_lock_lookup(S13_CLKFBOUT_MULT);
localparam [37:0] S13_DIVCLK              = mmcm_count_calc(S13_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S13_CLKOUT4             = mmcm_casc_count_calc(S13_CLKOUT4_DIVIDE, S13_CLKOUT4_PHASE, S13_CLKOUT4_DUTY);
localparam [37:0] S13_CLKOUT6             = mmcm_count_calc(S13_CLKOUT6_DIVIDE, S13_CLKOUT6_PHASE, S13_CLKOUT6_DUTY);

//**********************
// State 14 Calculations
//**********************
localparam [37:0] S14_CLKFBOUT            = mmcm_count_calc(S14_CLKFBOUT_MULT, S14_CLKFBOUT_PHASE, 50000);
localparam [37:0] S14_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S14_CLKFBOUT_MULT, S14_CLKFBOUT_PHASE, 50000, S14_CLKFBOUT_FRAC);
localparam [9:0]  S14_DIGITAL_FILT        = mmcm_filter_lookup(S14_CLKFBOUT_MULT, S14_BANDWIDTH);
localparam [39:0] S14_LOCK                = mmcm_lock_lookup(S14_CLKFBOUT_MULT);
localparam [37:0] S14_DIVCLK              = mmcm_count_calc(S14_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S14_CLKOUT4             = mmcm_casc_count_calc(S14_CLKOUT4_DIVIDE, S14_CLKOUT4_PHASE, S14_CLKOUT4_DUTY);
localparam [37:0] S14_CLKOUT6             = mmcm_count_calc(S14_CLKOUT6_DIVIDE, S14_CLKOUT6_PHASE, S14_CLKOUT6_DUTY);

//**********************
// State 15 Calculations
//**********************
localparam [37:0] S15_CLKFBOUT            = mmcm_count_calc(S15_CLKFBOUT_MULT, S15_CLKFBOUT_PHASE, 50000);
localparam [37:0] S15_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S15_CLKFBOUT_MULT, S15_CLKFBOUT_PHASE, 50000, S15_CLKFBOUT_FRAC);
localparam [9:0]  S15_DIGITAL_FILT        = mmcm_filter_lookup(S15_CLKFBOUT_MULT, S15_BANDWIDTH);
localparam [39:0] S15_LOCK                = mmcm_lock_lookup(S15_CLKFBOUT_MULT);
localparam [37:0] S15_DIVCLK              = mmcm_count_calc(S15_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S15_CLKOUT4             = mmcm_casc_count_calc(S15_CLKOUT4_DIVIDE, S15_CLKOUT4_PHASE, S15_CLKOUT4_DUTY);
localparam [37:0] S15_CLKOUT6             = mmcm_count_calc(S15_CLKOUT6_DIVIDE, S15_CLKOUT6_PHASE, S15_CLKOUT6_DUTY);

//**********************
// State 16 Calculations
//**********************
localparam [37:0] S16_CLKFBOUT            = mmcm_count_calc(S16_CLKFBOUT_MULT, S16_CLKFBOUT_PHASE, 50000);
localparam [37:0] S16_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S16_CLKFBOUT_MULT, S16_CLKFBOUT_PHASE, 50000, S16_CLKFBOUT_FRAC);
localparam [9:0]  S16_DIGITAL_FILT        = mmcm_filter_lookup(S16_CLKFBOUT_MULT, S16_BANDWIDTH);
localparam [39:0] S16_LOCK                = mmcm_lock_lookup(S16_CLKFBOUT_MULT);
localparam [37:0] S16_DIVCLK              = mmcm_count_calc(S16_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S16_CLKOUT4             = mmcm_casc_count_calc(S16_CLKOUT4_DIVIDE, S16_CLKOUT4_PHASE, S16_CLKOUT4_DUTY);
localparam [37:0] S16_CLKOUT6             = mmcm_count_calc(S16_CLKOUT6_DIVIDE, S16_CLKOUT6_PHASE, S16_CLKOUT6_DUTY);

//**********************
// State 17 Calculations
//**********************
localparam [37:0] S17_CLKFBOUT            = mmcm_count_calc(S17_CLKFBOUT_MULT, S17_CLKFBOUT_PHASE, 50000);
localparam [37:0] S17_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S17_CLKFBOUT_MULT, S17_CLKFBOUT_PHASE, 50000, S17_CLKFBOUT_FRAC);
localparam [9:0]  S17_DIGITAL_FILT        = mmcm_filter_lookup(S17_CLKFBOUT_MULT, S17_BANDWIDTH);
localparam [39:0] S17_LOCK                = mmcm_lock_lookup(S17_CLKFBOUT_MULT);
localparam [37:0] S17_DIVCLK              = mmcm_count_calc(S17_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S17_CLKOUT4             = mmcm_casc_count_calc(S17_CLKOUT4_DIVIDE, S17_CLKOUT4_PHASE, S17_CLKOUT4_DUTY);
localparam [37:0] S17_CLKOUT6             = mmcm_count_calc(S17_CLKOUT6_DIVIDE, S17_CLKOUT6_PHASE, S17_CLKOUT6_DUTY);

//**********************
// State 18 Calculations
//**********************
localparam [37:0] S18_CLKFBOUT            = mmcm_count_calc(S18_CLKFBOUT_MULT, S18_CLKFBOUT_PHASE, 50000);
localparam [37:0] S18_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S18_CLKFBOUT_MULT, S18_CLKFBOUT_PHASE, 50000, S18_CLKFBOUT_FRAC);
localparam [9:0]  S18_DIGITAL_FILT        = mmcm_filter_lookup(S18_CLKFBOUT_MULT, S18_BANDWIDTH);
localparam [39:0] S18_LOCK                = mmcm_lock_lookup(S18_CLKFBOUT_MULT);
localparam [37:0] S18_DIVCLK              = mmcm_count_calc(S18_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S18_CLKOUT4             = mmcm_casc_count_calc(S18_CLKOUT4_DIVIDE, S18_CLKOUT4_PHASE, S18_CLKOUT4_DUTY);
localparam [37:0] S18_CLKOUT6             = mmcm_count_calc(S18_CLKOUT6_DIVIDE, S18_CLKOUT6_PHASE, S18_CLKOUT6_DUTY);

//**********************
// State 19 Calculations
//**********************
localparam [37:0] S19_CLKFBOUT            = mmcm_count_calc(S19_CLKFBOUT_MULT, S19_CLKFBOUT_PHASE, 50000);
localparam [37:0] S19_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S19_CLKFBOUT_MULT, S19_CLKFBOUT_PHASE, 50000, S19_CLKFBOUT_FRAC);
localparam [9:0]  S19_DIGITAL_FILT        = mmcm_filter_lookup(S19_CLKFBOUT_MULT, S19_BANDWIDTH);
localparam [39:0] S19_LOCK                = mmcm_lock_lookup(S19_CLKFBOUT_MULT);
localparam [37:0] S19_DIVCLK              = mmcm_count_calc(S19_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S19_CLKOUT4             = mmcm_casc_count_calc(S19_CLKOUT4_DIVIDE, S19_CLKOUT4_PHASE, S19_CLKOUT4_DUTY);
localparam [37:0] S19_CLKOUT6             = mmcm_count_calc(S19_CLKOUT6_DIVIDE, S19_CLKOUT6_PHASE, S19_CLKOUT6_DUTY);

//**********************
// State 20 Calculations
//**********************
localparam [37:0] S20_CLKFBOUT            = mmcm_count_calc(S20_CLKFBOUT_MULT, S20_CLKFBOUT_PHASE, 50000);
localparam [37:0] S20_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S20_CLKFBOUT_MULT, S20_CLKFBOUT_PHASE, 50000, S20_CLKFBOUT_FRAC);
localparam [9:0]  S20_DIGITAL_FILT        = mmcm_filter_lookup(S20_CLKFBOUT_MULT, S20_BANDWIDTH);
localparam [39:0] S20_LOCK                = mmcm_lock_lookup(S20_CLKFBOUT_MULT);
localparam [37:0] S20_DIVCLK              = mmcm_count_calc(S20_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S20_CLKOUT4             = mmcm_casc_count_calc(S20_CLKOUT4_DIVIDE, S20_CLKOUT4_PHASE, S20_CLKOUT4_DUTY);
localparam [37:0] S20_CLKOUT6             = mmcm_count_calc(S20_CLKOUT6_DIVIDE, S20_CLKOUT6_PHASE, S20_CLKOUT6_DUTY);

//**********************
// State 21 Calculations
//**********************
localparam [37:0] S21_CLKFBOUT            = mmcm_count_calc(S21_CLKFBOUT_MULT, S21_CLKFBOUT_PHASE, 50000);
localparam [37:0] S21_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S21_CLKFBOUT_MULT, S21_CLKFBOUT_PHASE, 50000, S21_CLKFBOUT_FRAC);
localparam [9:0]  S21_DIGITAL_FILT        = mmcm_filter_lookup(S21_CLKFBOUT_MULT, S21_BANDWIDTH);
localparam [39:0] S21_LOCK                = mmcm_lock_lookup(S21_CLKFBOUT_MULT);
localparam [37:0] S21_DIVCLK              = mmcm_count_calc(S21_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S21_CLKOUT4             = mmcm_casc_count_calc(S21_CLKOUT4_DIVIDE, S21_CLKOUT4_PHASE, S21_CLKOUT4_DUTY);
localparam [37:0] S21_CLKOUT6             = mmcm_count_calc(S21_CLKOUT6_DIVIDE, S21_CLKOUT6_PHASE, S21_CLKOUT6_DUTY);

//**********************
// State 22 Calculations
//**********************
localparam [37:0] S22_CLKFBOUT            = mmcm_count_calc(S22_CLKFBOUT_MULT, S22_CLKFBOUT_PHASE, 50000);
localparam [37:0] S22_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S22_CLKFBOUT_MULT, S22_CLKFBOUT_PHASE, 50000, S22_CLKFBOUT_FRAC);
localparam [9:0]  S22_DIGITAL_FILT        = mmcm_filter_lookup(S22_CLKFBOUT_MULT, S22_BANDWIDTH);
localparam [39:0] S22_LOCK                = mmcm_lock_lookup(S22_CLKFBOUT_MULT);
localparam [37:0] S22_DIVCLK              = mmcm_count_calc(S22_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S22_CLKOUT4             = mmcm_casc_count_calc(S22_CLKOUT4_DIVIDE, S22_CLKOUT4_PHASE, S22_CLKOUT4_DUTY);
localparam [37:0] S22_CLKOUT6             = mmcm_count_calc(S22_CLKOUT6_DIVIDE, S22_CLKOUT6_PHASE, S22_CLKOUT6_DUTY);

//**********************
// State 23 Calculations
//**********************
localparam [37:0] S23_CLKFBOUT            = mmcm_count_calc(S23_CLKFBOUT_MULT, S23_CLKFBOUT_PHASE, 50000);
localparam [37:0] S23_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S23_CLKFBOUT_MULT, S23_CLKFBOUT_PHASE, 50000, S23_CLKFBOUT_FRAC);
localparam [9:0]  S23_DIGITAL_FILT        = mmcm_filter_lookup(S23_CLKFBOUT_MULT, S23_BANDWIDTH);
localparam [39:0] S23_LOCK                = mmcm_lock_lookup(S23_CLKFBOUT_MULT);
localparam [37:0] S23_DIVCLK              = mmcm_count_calc(S23_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S23_CLKOUT4             = mmcm_casc_count_calc(S23_CLKOUT4_DIVIDE, S23_CLKOUT4_PHASE, S23_CLKOUT4_DUTY);
localparam [37:0] S23_CLKOUT6             = mmcm_count_calc(S23_CLKOUT6_DIVIDE, S23_CLKOUT6_PHASE, S23_CLKOUT6_DUTY);

//**********************
// State 24 Calculations
//**********************
localparam [37:0] S24_CLKFBOUT            = mmcm_count_calc(S24_CLKFBOUT_MULT, S24_CLKFBOUT_PHASE, 50000);
localparam [37:0] S24_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S24_CLKFBOUT_MULT, S24_CLKFBOUT_PHASE, 50000, S24_CLKFBOUT_FRAC);
localparam [9:0]  S24_DIGITAL_FILT        = mmcm_filter_lookup(S24_CLKFBOUT_MULT, S24_BANDWIDTH);
localparam [39:0] S24_LOCK                = mmcm_lock_lookup(S24_CLKFBOUT_MULT);
localparam [37:0] S24_DIVCLK              = mmcm_count_calc(S24_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S24_CLKOUT4             = mmcm_casc_count_calc(S24_CLKOUT4_DIVIDE, S24_CLKOUT4_PHASE, S24_CLKOUT4_DUTY);
localparam [37:0] S24_CLKOUT6             = mmcm_count_calc(S24_CLKOUT6_DIVIDE, S24_CLKOUT6_PHASE, S24_CLKOUT6_DUTY);

//**********************
// State 25 Calculations
//**********************
localparam [37:0] S25_CLKFBOUT            = mmcm_count_calc(S25_CLKFBOUT_MULT, S25_CLKFBOUT_PHASE, 50000);
localparam [37:0] S25_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S25_CLKFBOUT_MULT, S25_CLKFBOUT_PHASE, 50000, S25_CLKFBOUT_FRAC);
localparam [9:0]  S25_DIGITAL_FILT        = mmcm_filter_lookup(S25_CLKFBOUT_MULT, S25_BANDWIDTH);
localparam [39:0] S25_LOCK                = mmcm_lock_lookup(S25_CLKFBOUT_MULT);
localparam [37:0] S25_DIVCLK              = mmcm_count_calc(S25_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S25_CLKOUT4             = mmcm_casc_count_calc(S25_CLKOUT4_DIVIDE, S25_CLKOUT4_PHASE, S25_CLKOUT4_DUTY);
localparam [37:0] S25_CLKOUT6             = mmcm_count_calc(S25_CLKOUT6_DIVIDE, S25_CLKOUT6_PHASE, S25_CLKOUT6_DUTY);

//**********************
// State 26 Calculations
//**********************
localparam [37:0] S26_CLKFBOUT            = mmcm_count_calc(S26_CLKFBOUT_MULT, S26_CLKFBOUT_PHASE, 50000);
localparam [37:0] S26_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S26_CLKFBOUT_MULT, S26_CLKFBOUT_PHASE, 50000, S26_CLKFBOUT_FRAC);
localparam [9:0]  S26_DIGITAL_FILT        = mmcm_filter_lookup(S26_CLKFBOUT_MULT, S26_BANDWIDTH);
localparam [39:0] S26_LOCK                = mmcm_lock_lookup(S26_CLKFBOUT_MULT);
localparam [37:0] S26_DIVCLK              = mmcm_count_calc(S26_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S26_CLKOUT4             = mmcm_casc_count_calc(S26_CLKOUT4_DIVIDE, S26_CLKOUT4_PHASE, S26_CLKOUT4_DUTY);
localparam [37:0] S26_CLKOUT6             = mmcm_count_calc(S26_CLKOUT6_DIVIDE, S26_CLKOUT6_PHASE, S26_CLKOUT6_DUTY);

//**********************
// State 27 Calculations
//**********************
localparam [37:0] S27_CLKFBOUT            = mmcm_count_calc(S27_CLKFBOUT_MULT, S27_CLKFBOUT_PHASE, 50000);
localparam [37:0] S27_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S27_CLKFBOUT_MULT, S27_CLKFBOUT_PHASE, 50000, S27_CLKFBOUT_FRAC);
localparam [9:0]  S27_DIGITAL_FILT        = mmcm_filter_lookup(S27_CLKFBOUT_MULT, S27_BANDWIDTH);
localparam [39:0] S27_LOCK                = mmcm_lock_lookup(S27_CLKFBOUT_MULT);
localparam [37:0] S27_DIVCLK              = mmcm_count_calc(S27_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S27_CLKOUT4             = mmcm_casc_count_calc(S27_CLKOUT4_DIVIDE, S27_CLKOUT4_PHASE, S27_CLKOUT4_DUTY);
localparam [37:0] S27_CLKOUT6             = mmcm_count_calc(S27_CLKOUT6_DIVIDE, S27_CLKOUT6_PHASE, S27_CLKOUT6_DUTY);

//**********************
// State 28 Calculations
//**********************
localparam [37:0] S28_CLKFBOUT            = mmcm_count_calc(S28_CLKFBOUT_MULT, S28_CLKFBOUT_PHASE, 50000);
localparam [37:0] S28_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S28_CLKFBOUT_MULT, S28_CLKFBOUT_PHASE, 50000, S28_CLKFBOUT_FRAC);
localparam [9:0]  S28_DIGITAL_FILT        = mmcm_filter_lookup(S28_CLKFBOUT_MULT, S28_BANDWIDTH);
localparam [39:0] S28_LOCK                = mmcm_lock_lookup(S28_CLKFBOUT_MULT);
localparam [37:0] S28_DIVCLK              = mmcm_count_calc(S28_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S28_CLKOUT4             = mmcm_casc_count_calc(S28_CLKOUT4_DIVIDE, S28_CLKOUT4_PHASE, S28_CLKOUT4_DUTY);
localparam [37:0] S28_CLKOUT6             = mmcm_count_calc(S28_CLKOUT6_DIVIDE, S28_CLKOUT6_PHASE, S28_CLKOUT6_DUTY);

//**********************
// State 29 Calculations
//**********************
localparam [37:0] S29_CLKFBOUT            = mmcm_count_calc(S29_CLKFBOUT_MULT, S29_CLKFBOUT_PHASE, 50000);
localparam [37:0] S29_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S29_CLKFBOUT_MULT, S29_CLKFBOUT_PHASE, 50000, S29_CLKFBOUT_FRAC);
localparam [9:0]  S29_DIGITAL_FILT        = mmcm_filter_lookup(S29_CLKFBOUT_MULT, S29_BANDWIDTH);
localparam [39:0] S29_LOCK                = mmcm_lock_lookup(S29_CLKFBOUT_MULT);
localparam [37:0] S29_DIVCLK              = mmcm_count_calc(S29_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S29_CLKOUT4             = mmcm_casc_count_calc(S29_CLKOUT4_DIVIDE, S29_CLKOUT4_PHASE, S29_CLKOUT4_DUTY);
localparam [37:0] S29_CLKOUT6             = mmcm_count_calc(S29_CLKOUT6_DIVIDE, S29_CLKOUT6_PHASE, S29_CLKOUT6_DUTY);

//**********************
// State 30 Calculations
//**********************
localparam [37:0] S30_CLKFBOUT            = mmcm_count_calc(S30_CLKFBOUT_MULT, S30_CLKFBOUT_PHASE, 50000);
localparam [37:0] S30_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S30_CLKFBOUT_MULT, S30_CLKFBOUT_PHASE, 50000, S30_CLKFBOUT_FRAC);
localparam [9:0]  S30_DIGITAL_FILT        = mmcm_filter_lookup(S30_CLKFBOUT_MULT, S30_BANDWIDTH);
localparam [39:0] S30_LOCK                = mmcm_lock_lookup(S30_CLKFBOUT_MULT);
localparam [37:0] S30_DIVCLK              = mmcm_count_calc(S30_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S30_CLKOUT4             = mmcm_casc_count_calc(S30_CLKOUT4_DIVIDE, S30_CLKOUT4_PHASE, S30_CLKOUT4_DUTY);
localparam [37:0] S30_CLKOUT6             = mmcm_count_calc(S30_CLKOUT6_DIVIDE, S30_CLKOUT6_PHASE, S30_CLKOUT6_DUTY);

//**********************
// State 31 Calculations
//**********************
localparam [37:0] S31_CLKFBOUT            = mmcm_count_calc(S31_CLKFBOUT_MULT, S31_CLKFBOUT_PHASE, 50000);
localparam [37:0] S31_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S31_CLKFBOUT_MULT, S31_CLKFBOUT_PHASE, 50000, S31_CLKFBOUT_FRAC);
localparam [9:0]  S31_DIGITAL_FILT        = mmcm_filter_lookup(S31_CLKFBOUT_MULT, S31_BANDWIDTH);
localparam [39:0] S31_LOCK                = mmcm_lock_lookup(S31_CLKFBOUT_MULT);
localparam [37:0] S31_DIVCLK              = mmcm_count_calc(S31_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S31_CLKOUT4             = mmcm_casc_count_calc(S31_CLKOUT4_DIVIDE, S31_CLKOUT4_PHASE, S31_CLKOUT4_DUTY);
localparam [37:0] S31_CLKOUT6             = mmcm_count_calc(S31_CLKOUT6_DIVIDE, S31_CLKOUT6_PHASE, S31_CLKOUT6_DUTY);

//**********************
// State 32 Calculations
//**********************
localparam [37:0] S32_CLKFBOUT            = mmcm_count_calc(S32_CLKFBOUT_MULT, S32_CLKFBOUT_PHASE, 50000);
localparam [37:0] S32_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S32_CLKFBOUT_MULT, S32_CLKFBOUT_PHASE, 50000, S32_CLKFBOUT_FRAC);
localparam [9:0]  S32_DIGITAL_FILT        = mmcm_filter_lookup(S32_CLKFBOUT_MULT, S32_BANDWIDTH);
localparam [39:0] S32_LOCK                = mmcm_lock_lookup(S32_CLKFBOUT_MULT);
localparam [37:0] S32_DIVCLK              = mmcm_count_calc(S32_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S32_CLKOUT4             = mmcm_casc_count_calc(S32_CLKOUT4_DIVIDE, S32_CLKOUT4_PHASE, S32_CLKOUT4_DUTY);
localparam [37:0] S32_CLKOUT6             = mmcm_count_calc(S32_CLKOUT6_DIVIDE, S32_CLKOUT6_PHASE, S32_CLKOUT6_DUTY);

//**********************
// State 33 Calculations
//**********************
localparam [37:0] S33_CLKFBOUT            = mmcm_count_calc(S33_CLKFBOUT_MULT, S33_CLKFBOUT_PHASE, 50000);
localparam [37:0] S33_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S33_CLKFBOUT_MULT, S33_CLKFBOUT_PHASE, 50000, S33_CLKFBOUT_FRAC);
localparam [9:0]  S33_DIGITAL_FILT        = mmcm_filter_lookup(S33_CLKFBOUT_MULT, S33_BANDWIDTH);
localparam [39:0] S33_LOCK                = mmcm_lock_lookup(S33_CLKFBOUT_MULT);
localparam [37:0] S33_DIVCLK              = mmcm_count_calc(S33_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S33_CLKOUT4             = mmcm_casc_count_calc(S33_CLKOUT4_DIVIDE, S33_CLKOUT4_PHASE, S33_CLKOUT4_DUTY);
localparam [37:0] S33_CLKOUT6             = mmcm_count_calc(S33_CLKOUT6_DIVIDE, S33_CLKOUT6_PHASE, S33_CLKOUT6_DUTY);

//**********************
// State 34 Calculations
//**********************
localparam [37:0] S34_CLKFBOUT            = mmcm_count_calc(S34_CLKFBOUT_MULT, S34_CLKFBOUT_PHASE, 50000);
localparam [37:0] S34_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S34_CLKFBOUT_MULT, S34_CLKFBOUT_PHASE, 50000, S34_CLKFBOUT_FRAC);
localparam [9:0]  S34_DIGITAL_FILT        = mmcm_filter_lookup(S34_CLKFBOUT_MULT, S34_BANDWIDTH);
localparam [39:0] S34_LOCK                = mmcm_lock_lookup(S34_CLKFBOUT_MULT);
localparam [37:0] S34_DIVCLK              = mmcm_count_calc(S34_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S34_CLKOUT4             = mmcm_casc_count_calc(S34_CLKOUT4_DIVIDE, S34_CLKOUT4_PHASE, S34_CLKOUT4_DUTY);
localparam [37:0] S34_CLKOUT6             = mmcm_count_calc(S34_CLKOUT6_DIVIDE, S34_CLKOUT6_PHASE, S34_CLKOUT6_DUTY);

//**********************
// State 35 Calculations
//**********************
localparam [37:0] S35_CLKFBOUT            = mmcm_count_calc(S35_CLKFBOUT_MULT, S35_CLKFBOUT_PHASE, 50000);
localparam [37:0] S35_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S35_CLKFBOUT_MULT, S35_CLKFBOUT_PHASE, 50000, S35_CLKFBOUT_FRAC);
localparam [9:0]  S35_DIGITAL_FILT        = mmcm_filter_lookup(S35_CLKFBOUT_MULT, S35_BANDWIDTH);
localparam [39:0] S35_LOCK                = mmcm_lock_lookup(S35_CLKFBOUT_MULT);
localparam [37:0] S35_DIVCLK              = mmcm_count_calc(S35_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S35_CLKOUT4             = mmcm_casc_count_calc(S35_CLKOUT4_DIVIDE, S35_CLKOUT4_PHASE, S35_CLKOUT4_DUTY);
localparam [37:0] S35_CLKOUT6             = mmcm_count_calc(S35_CLKOUT6_DIVIDE, S35_CLKOUT6_PHASE, S35_CLKOUT6_DUTY);

//**********************
// State 36 Calculations
//**********************
localparam [37:0] S36_CLKFBOUT            = mmcm_count_calc(S36_CLKFBOUT_MULT, S36_CLKFBOUT_PHASE, 50000);
localparam [37:0] S36_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S36_CLKFBOUT_MULT, S36_CLKFBOUT_PHASE, 50000, S36_CLKFBOUT_FRAC);
localparam [9:0]  S36_DIGITAL_FILT        = mmcm_filter_lookup(S36_CLKFBOUT_MULT, S36_BANDWIDTH);
localparam [39:0] S36_LOCK                = mmcm_lock_lookup(S36_CLKFBOUT_MULT);
localparam [37:0] S36_DIVCLK              = mmcm_count_calc(S36_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S36_CLKOUT4             = mmcm_casc_count_calc(S36_CLKOUT4_DIVIDE, S36_CLKOUT4_PHASE, S36_CLKOUT4_DUTY);
localparam [37:0] S36_CLKOUT6             = mmcm_count_calc(S36_CLKOUT6_DIVIDE, S36_CLKOUT6_PHASE, S36_CLKOUT6_DUTY);

//**********************
// State 37 Calculations
//**********************
localparam [37:0] S37_CLKFBOUT            = mmcm_count_calc(S37_CLKFBOUT_MULT, S37_CLKFBOUT_PHASE, 50000);
localparam [37:0] S37_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S37_CLKFBOUT_MULT, S37_CLKFBOUT_PHASE, 50000, S37_CLKFBOUT_FRAC);
localparam [9:0]  S37_DIGITAL_FILT        = mmcm_filter_lookup(S37_CLKFBOUT_MULT, S37_BANDWIDTH);
localparam [39:0] S37_LOCK                = mmcm_lock_lookup(S37_CLKFBOUT_MULT);
localparam [37:0] S37_DIVCLK              = mmcm_count_calc(S37_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S37_CLKOUT4             = mmcm_casc_count_calc(S37_CLKOUT4_DIVIDE, S37_CLKOUT4_PHASE, S37_CLKOUT4_DUTY);
localparam [37:0] S37_CLKOUT6             = mmcm_count_calc(S37_CLKOUT6_DIVIDE, S37_CLKOUT6_PHASE, S37_CLKOUT6_DUTY);

//**********************
// State 38 Calculations
//**********************
localparam [37:0] S38_CLKFBOUT            = mmcm_count_calc(S38_CLKFBOUT_MULT, S38_CLKFBOUT_PHASE, 50000);
localparam [37:0] S38_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S38_CLKFBOUT_MULT, S38_CLKFBOUT_PHASE, 50000, S38_CLKFBOUT_FRAC);
localparam [9:0]  S38_DIGITAL_FILT        = mmcm_filter_lookup(S38_CLKFBOUT_MULT, S38_BANDWIDTH);
localparam [39:0] S38_LOCK                = mmcm_lock_lookup(S38_CLKFBOUT_MULT);
localparam [37:0] S38_DIVCLK              = mmcm_count_calc(S38_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S38_CLKOUT4             = mmcm_casc_count_calc(S38_CLKOUT4_DIVIDE, S38_CLKOUT4_PHASE, S38_CLKOUT4_DUTY);
localparam [37:0] S38_CLKOUT6             = mmcm_count_calc(S38_CLKOUT6_DIVIDE, S38_CLKOUT6_PHASE, S38_CLKOUT6_DUTY);

//**********************
// State 39 Calculations
//**********************
localparam [37:0] S39_CLKFBOUT            = mmcm_count_calc(S39_CLKFBOUT_MULT, S39_CLKFBOUT_PHASE, 50000);
localparam [37:0] S39_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S39_CLKFBOUT_MULT, S39_CLKFBOUT_PHASE, 50000, S39_CLKFBOUT_FRAC);
localparam [9:0]  S39_DIGITAL_FILT        = mmcm_filter_lookup(S39_CLKFBOUT_MULT, S39_BANDWIDTH);
localparam [39:0] S39_LOCK                = mmcm_lock_lookup(S39_CLKFBOUT_MULT);
localparam [37:0] S39_DIVCLK              = mmcm_count_calc(S39_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S39_CLKOUT4             = mmcm_casc_count_calc(S39_CLKOUT4_DIVIDE, S39_CLKOUT4_PHASE, S39_CLKOUT4_DUTY);
localparam [37:0] S39_CLKOUT6             = mmcm_count_calc(S39_CLKOUT6_DIVIDE, S39_CLKOUT6_PHASE, S39_CLKOUT6_DUTY);

//**********************
// State 40 Calculations
//**********************
localparam [37:0] S40_CLKFBOUT            = mmcm_count_calc(S40_CLKFBOUT_MULT, S40_CLKFBOUT_PHASE, 50000);
localparam [37:0] S40_CLKFBOUT_FRAC_CALC  = mmcm_frac_count_calc(S40_CLKFBOUT_MULT, S40_CLKFBOUT_PHASE, 50000, S40_CLKFBOUT_FRAC);
localparam [9:0]  S40_DIGITAL_FILT        = mmcm_filter_lookup(S40_CLKFBOUT_MULT, S40_BANDWIDTH);
localparam [39:0] S40_LOCK                = mmcm_lock_lookup(S40_CLKFBOUT_MULT);
localparam [37:0] S40_DIVCLK              = mmcm_count_calc(S40_DIVCLK_DIVIDE, 0, 50000);
localparam [37:0] S40_CLKOUT4             = mmcm_casc_count_calc(S40_CLKOUT4_DIVIDE, S40_CLKOUT4_PHASE, S40_CLKOUT4_DUTY);
localparam [37:0] S40_CLKOUT6             = mmcm_count_calc(S40_CLKOUT6_DIVIDE, S40_CLKOUT6_PHASE, S40_CLKOUT6_DUTY);




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

		// Store CLKOUT4 divide and phase
		init_rom[1]  = {7'h10, 16'h1000, S1_CLKOUT4[15:0]};
		init_rom[2]  = {7'h11, 16'hFC00, S1_CLKOUT4[31:16]};

		// Store CLKOUT6 divide and phase
		init_rom[3] = {7'h12, 16'h1000, S1_CLKOUT6[15:0]};
		init_rom[4] = (S1_CLKFBOUT_FRAC_EN == 0) ?
                  {7'h13, 16'hC000, S1_CLKOUT6[31:16]}:
                  {7'h13, 16'hC000, S1_CLKOUT6[31:30], S1_CLKFBOUT_FRAC_CALC[35:32],S1_CLKOUT6[25:16]};

		// Store the feedback divide and phase
		init_rom[5]	= (S1_CLKFBOUT_FRAC_EN == 0) ?
				  {7'h14, 16'h1000, S1_CLKFBOUT[15:0]}:
				  {7'h14, 16'h1000, S1_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[6] 	= (S1_CLKFBOUT_FRAC_EN == 0) ?
				  {7'h15, 16'h8000, S1_CLKFBOUT[31:16]}:
				  {7'h15, 16'h8000, S1_CLKFBOUT_FRAC_CALC[31:16]};

		// Store the lock settings
		init_rom[7] = {7'h18, 16'hFC00, {6'h00, S1_LOCK[29:20]}};
		init_rom[8] = {7'h19, 16'h8000, {1'b0, S1_LOCK[34:30], S1_LOCK[9:0]}};
		init_rom[9] = {7'h1A, 16'h8000, {1'b0, S1_LOCK[39:35], S1_LOCK[19:10]}};

		// Store the filter settings
		init_rom[10] = {7'h4E, 16'h66FF, S1_DIGITAL_FILT[9], 2'h0, S1_DIGITAL_FILT[8:7], 2'h0, S1_DIGITAL_FILT[6], 8'h00 };
		init_rom[11] = {7'h4F, 16'h666F, S1_DIGITAL_FILT[5], 2'h0, S1_DIGITAL_FILT[4:3], 2'h0, S1_DIGITAL_FILT[2:1], 2'h0, S1_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 2 Initialization
		//***********************************************************************
		init_rom[12]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[13] 	= {7'h10, 16'h1000, S2_CLKOUT4[15:0]};
		init_rom[14] 	= {7'h11, 16'hFC00, S2_CLKOUT4[31:16]};
		init_rom[15] 	= {7'h12, 16'h1000, S2_CLKOUT6[15:0]};
		init_rom[16] 	= (S2_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S2_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S2_CLKOUT6[31:30], S2_CLKFBOUT_FRAC_CALC[35:32],S2_CLKOUT6[25:16]};
		init_rom[17]	= (S2_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S2_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S2_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[18] 	= (S2_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S2_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S2_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[19] 	= {7'h18, 16'hFC00, {6'h00, S2_LOCK[29:20]}};
		init_rom[20] 	= {7'h19, 16'h8000, {1'b0, S2_LOCK[34:30], S2_LOCK[9:0]}};
		init_rom[21] 	= {7'h1A, 16'h8000, {1'b0, S2_LOCK[39:35], S2_LOCK[19:10]}};
		init_rom[22] 	= {7'h4E, 16'h66FF, S2_DIGITAL_FILT[9], 2'h0, S2_DIGITAL_FILT[8:7], 2'h0, S2_DIGITAL_FILT[6], 8'h00 };
		init_rom[23] 	= {7'h4F, 16'h666F, S2_DIGITAL_FILT[5], 2'h0, S2_DIGITAL_FILT[4:3], 2'h0, S2_DIGITAL_FILT[2:1], 2'h0, S2_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 3 Initialization
		//***********************************************************************
		init_rom[24]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[25] 	= {7'h10, 16'h1000, S3_CLKOUT4[15:0]};
		init_rom[26] 	= {7'h11, 16'hFC00, S3_CLKOUT4[31:16]};
		init_rom[27] 	= {7'h12, 16'h1000, S3_CLKOUT6[15:0]};
		init_rom[28] 	= (S3_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S3_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S3_CLKOUT6[31:30], S3_CLKFBOUT_FRAC_CALC[35:32],S3_CLKOUT6[25:16]};
		init_rom[29]	= (S3_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S3_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S3_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[30] 	= (S3_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S3_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S3_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[31] 	= {7'h18, 16'hFC00, {6'h00, S3_LOCK[29:20]}};
		init_rom[32] 	= {7'h19, 16'h8000, {1'b0, S3_LOCK[34:30], S3_LOCK[9:0]}};
		init_rom[33] 	= {7'h1A, 16'h8000, {1'b0, S3_LOCK[39:35], S3_LOCK[19:10]}};
		init_rom[34] 	= {7'h4E, 16'h66FF, S3_DIGITAL_FILT[9], 2'h0, S3_DIGITAL_FILT[8:7], 2'h0, S3_DIGITAL_FILT[6], 8'h00 };
		init_rom[35] 	= {7'h4F, 16'h666F, S3_DIGITAL_FILT[5], 2'h0, S3_DIGITAL_FILT[4:3], 2'h0, S3_DIGITAL_FILT[2:1], 2'h0, S3_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 4 Initialization
		//***********************************************************************
		init_rom[36]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[37] 	= {7'h10, 16'h1000, S4_CLKOUT4[15:0]};
		init_rom[38] 	= {7'h11, 16'hFC00, S4_CLKOUT4[31:16]};
		init_rom[39] 	= {7'h12, 16'h1000, S4_CLKOUT6[15:0]};
		init_rom[40] 	= (S4_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S4_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S4_CLKOUT6[31:30], S4_CLKFBOUT_FRAC_CALC[35:32],S4_CLKOUT6[25:16]};
		init_rom[41]	= (S4_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S4_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S4_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[42] 	= (S4_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S4_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S4_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[43] 	= {7'h18, 16'hFC00, {6'h00, S4_LOCK[29:20]}};
		init_rom[44] 	= {7'h19, 16'h8000, {1'b0, S4_LOCK[34:30], S4_LOCK[9:0]}};
		init_rom[45] 	= {7'h1A, 16'h8000, {1'b0, S4_LOCK[39:35], S4_LOCK[19:10]}};
		init_rom[46] 	= {7'h4E, 16'h66FF, S4_DIGITAL_FILT[9], 2'h0, S4_DIGITAL_FILT[8:7], 2'h0, S4_DIGITAL_FILT[6], 8'h00 };
		init_rom[47] 	= {7'h4F, 16'h666F, S4_DIGITAL_FILT[5], 2'h0, S4_DIGITAL_FILT[4:3], 2'h0, S4_DIGITAL_FILT[2:1], 2'h0, S4_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 5 Initialization
		//***********************************************************************
		init_rom[48]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[49] 	= {7'h10, 16'h1000, S5_CLKOUT4[15:0]};
		init_rom[50] 	= {7'h11, 16'hFC00, S5_CLKOUT4[31:16]};
		init_rom[51] 	= {7'h12, 16'h1000, S5_CLKOUT6[15:0]};
		init_rom[52] 	= (S5_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S5_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S5_CLKOUT6[31:30], S5_CLKFBOUT_FRAC_CALC[35:32],S5_CLKOUT6[25:16]};
		init_rom[53]	= (S5_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S5_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S5_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[54] 	= (S5_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S5_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S5_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[55] 	= {7'h18, 16'hFC00, {6'h00, S5_LOCK[29:20]}};
		init_rom[56] 	= {7'h19, 16'h8000, {1'b0, S5_LOCK[34:30], S5_LOCK[9:0]}};
		init_rom[57] 	= {7'h1A, 16'h8000, {1'b0, S5_LOCK[39:35], S5_LOCK[19:10]}};
		init_rom[58] 	= {7'h4E, 16'h66FF, S5_DIGITAL_FILT[9], 2'h0, S5_DIGITAL_FILT[8:7], 2'h0, S5_DIGITAL_FILT[6], 8'h00 };
		init_rom[59] 	= {7'h4F, 16'h666F, S5_DIGITAL_FILT[5], 2'h0, S5_DIGITAL_FILT[4:3], 2'h0, S5_DIGITAL_FILT[2:1], 2'h0, S5_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 6 Initialization
		//***********************************************************************
		init_rom[60]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[61] 	= {7'h10, 16'h1000, S6_CLKOUT4[15:0]};
		init_rom[62] 	= {7'h11, 16'hFC00, S6_CLKOUT4[31:16]};
		init_rom[63] 	= {7'h12, 16'h1000, S6_CLKOUT6[15:0]};
		init_rom[64] 	= (S6_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S6_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S6_CLKOUT6[31:30], S6_CLKFBOUT_FRAC_CALC[35:32],S6_CLKOUT6[25:16]};
		init_rom[65]	= (S6_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S6_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S6_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[66] 	= (S6_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S6_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S6_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[67] 	= {7'h18, 16'hFC00, {6'h00, S6_LOCK[29:20]}};
		init_rom[68] 	= {7'h19, 16'h8000, {1'b0, S6_LOCK[34:30], S6_LOCK[9:0]}};
		init_rom[69] 	= {7'h1A, 16'h8000, {1'b0, S6_LOCK[39:35], S6_LOCK[19:10]}};
		init_rom[70] 	= {7'h4E, 16'h66FF, S6_DIGITAL_FILT[9], 2'h0, S6_DIGITAL_FILT[8:7], 2'h0, S6_DIGITAL_FILT[6], 8'h00 };
		init_rom[71] 	= {7'h4F, 16'h666F, S6_DIGITAL_FILT[5], 2'h0, S6_DIGITAL_FILT[4:3], 2'h0, S6_DIGITAL_FILT[2:1], 2'h0, S6_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 7 Initialization
		//***********************************************************************
		init_rom[72]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[73] 	= {7'h10, 16'h1000, S7_CLKOUT4[15:0]};
		init_rom[74] 	= {7'h11, 16'hFC00, S7_CLKOUT4[31:16]};
		init_rom[75] 	= {7'h12, 16'h1000, S7_CLKOUT6[15:0]};
		init_rom[76] 	= (S7_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S7_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S7_CLKOUT6[31:30], S7_CLKFBOUT_FRAC_CALC[35:32],S7_CLKOUT6[25:16]};
		init_rom[77]	= (S7_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S7_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S7_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[78] 	= (S7_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S7_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S7_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[79] 	= {7'h18, 16'hFC00, {6'h00, S7_LOCK[29:20]}};
		init_rom[80] 	= {7'h19, 16'h8000, {1'b0, S7_LOCK[34:30], S7_LOCK[9:0]}};
		init_rom[81] 	= {7'h1A, 16'h8000, {1'b0, S7_LOCK[39:35], S7_LOCK[19:10]}};
		init_rom[82] 	= {7'h4E, 16'h66FF, S7_DIGITAL_FILT[9], 2'h0, S7_DIGITAL_FILT[8:7], 2'h0, S7_DIGITAL_FILT[6], 8'h00 };
		init_rom[83] 	= {7'h4F, 16'h666F, S7_DIGITAL_FILT[5], 2'h0, S7_DIGITAL_FILT[4:3], 2'h0, S7_DIGITAL_FILT[2:1], 2'h0, S7_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 8 Initialization
		//***********************************************************************
		init_rom[84]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[85] 	= {7'h10, 16'h1000, S8_CLKOUT4[15:0]};
		init_rom[86] 	= {7'h11, 16'hFC00, S8_CLKOUT4[31:16]};
		init_rom[87] 	= {7'h12, 16'h1000, S8_CLKOUT6[15:0]};
		init_rom[88] 	= (S8_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S8_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S8_CLKOUT6[31:30], S8_CLKFBOUT_FRAC_CALC[35:32],S8_CLKOUT6[25:16]};
		init_rom[89]	= (S8_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S8_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S8_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[90] 	= (S8_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S8_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S8_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[91] 	= {7'h18, 16'hFC00, {6'h00, S8_LOCK[29:20]}};
		init_rom[92] 	= {7'h19, 16'h8000, {1'b0, S8_LOCK[34:30], S8_LOCK[9:0]}};
		init_rom[93] 	= {7'h1A, 16'h8000, {1'b0, S8_LOCK[39:35], S8_LOCK[19:10]}};
		init_rom[94] 	= {7'h4E, 16'h66FF, S8_DIGITAL_FILT[9], 2'h0, S8_DIGITAL_FILT[8:7], 2'h0, S8_DIGITAL_FILT[6], 8'h00 };
		init_rom[95] 	= {7'h4F, 16'h666F, S8_DIGITAL_FILT[5], 2'h0, S8_DIGITAL_FILT[4:3], 2'h0, S8_DIGITAL_FILT[2:1], 2'h0, S8_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 9 Initialization
		//***********************************************************************
		init_rom[96]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[97] 	= {7'h10, 16'h1000, S9_CLKOUT4[15:0]};
		init_rom[98] 	= {7'h11, 16'hFC00, S9_CLKOUT4[31:16]};
		init_rom[99] 	= {7'h12, 16'h1000, S9_CLKOUT6[15:0]};
		init_rom[100] 	= (S9_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S9_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S9_CLKOUT6[31:30], S9_CLKFBOUT_FRAC_CALC[35:32],S9_CLKOUT6[25:16]};
		init_rom[101]	= (S9_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S9_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S9_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[102] 	= (S9_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S9_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S9_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[103] 	= {7'h18, 16'hFC00, {6'h00, S9_LOCK[29:20]}};
		init_rom[104] 	= {7'h19, 16'h8000, {1'b0, S9_LOCK[34:30], S9_LOCK[9:0]}};
		init_rom[105] 	= {7'h1A, 16'h8000, {1'b0, S9_LOCK[39:35], S9_LOCK[19:10]}};
		init_rom[106] 	= {7'h4E, 16'h66FF, S9_DIGITAL_FILT[9], 2'h0, S9_DIGITAL_FILT[8:7], 2'h0, S9_DIGITAL_FILT[6], 8'h00 };
		init_rom[107] 	= {7'h4F, 16'h666F, S9_DIGITAL_FILT[5], 2'h0, S9_DIGITAL_FILT[4:3], 2'h0, S9_DIGITAL_FILT[2:1], 2'h0, S9_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 10 Initialization
		//***********************************************************************
		init_rom[108]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[109] 	= {7'h10, 16'h1000, S10_CLKOUT4[15:0]};
		init_rom[110] 	= {7'h11, 16'hFC00, S10_CLKOUT4[31:16]};
		init_rom[111] 	= {7'h12, 16'h1000, S10_CLKOUT6[15:0]};
		init_rom[112] 	= (S10_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S10_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S10_CLKOUT6[31:30], S10_CLKFBOUT_FRAC_CALC[35:32],S10_CLKOUT6[25:16]};
		init_rom[113]	= (S10_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S10_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S10_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[114] 	= (S10_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S10_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S10_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[115] 	= {7'h18, 16'hFC00, {6'h00, S10_LOCK[29:20]}};
		init_rom[116] 	= {7'h19, 16'h8000, {1'b0, S10_LOCK[34:30], S10_LOCK[9:0]}};
		init_rom[117] 	= {7'h1A, 16'h8000, {1'b0, S10_LOCK[39:35], S10_LOCK[19:10]}};
		init_rom[118] 	= {7'h4E, 16'h66FF, S10_DIGITAL_FILT[9], 2'h0, S10_DIGITAL_FILT[8:7], 2'h0, S10_DIGITAL_FILT[6], 8'h00 };
		init_rom[119] 	= {7'h4F, 16'h666F, S10_DIGITAL_FILT[5], 2'h0, S10_DIGITAL_FILT[4:3], 2'h0, S10_DIGITAL_FILT[2:1], 2'h0, S10_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 11 Initialization
		//***********************************************************************
		init_rom[120]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[121] 	= {7'h10, 16'h1000, S11_CLKOUT4[15:0]};
		init_rom[122] 	= {7'h11, 16'hFC00, S11_CLKOUT4[31:16]};
		init_rom[123] 	= {7'h12, 16'h1000, S11_CLKOUT6[15:0]};
		init_rom[124] 	= (S11_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S11_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S11_CLKOUT6[31:30], S11_CLKFBOUT_FRAC_CALC[35:32],S11_CLKOUT6[25:16]};
		init_rom[125]		= (S11_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S11_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S11_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[126] 	= (S11_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S11_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S11_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[127] 	= {7'h18, 16'hFC00, {6'h00, S11_LOCK[29:20]}};
		init_rom[128] 	= {7'h19, 16'h8000, {1'b0, S11_LOCK[34:30], S11_LOCK[9:0]}};
		init_rom[129] 	= {7'h1A, 16'h8000, {1'b0, S11_LOCK[39:35], S11_LOCK[19:10]}};
		init_rom[130] 	= {7'h4E, 16'h66FF, S11_DIGITAL_FILT[9], 2'h0, S11_DIGITAL_FILT[8:7], 2'h0, S11_DIGITAL_FILT[6], 8'h00 };
		init_rom[131] 	= {7'h4F, 16'h666F, S11_DIGITAL_FILT[5], 2'h0, S11_DIGITAL_FILT[4:3], 2'h0, S11_DIGITAL_FILT[2:1], 2'h0, S11_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 12 Initialization
		//***********************************************************************
		init_rom[132]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[133] 	= {7'h10, 16'h1000, S12_CLKOUT4[15:0]};
		init_rom[134] 	= {7'h11, 16'hFC00, S12_CLKOUT4[31:16]};
		init_rom[135] 	= {7'h12, 16'h1000, S12_CLKOUT6[15:0]};
		init_rom[136] 	= (S12_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S12_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S12_CLKOUT6[31:30], S12_CLKFBOUT_FRAC_CALC[35:32],S12_CLKOUT6[25:16]};
		init_rom[137]	= (S12_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S12_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S12_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[138] 	= (S12_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S12_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S12_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[139] 	= {7'h18, 16'hFC00, {6'h00, S12_LOCK[29:20]}};
		init_rom[140] 	= {7'h19, 16'h8000, {1'b0, S12_LOCK[34:30], S12_LOCK[9:0]}};
		init_rom[141] 	= {7'h1A, 16'h8000, {1'b0, S12_LOCK[39:35], S12_LOCK[19:10]}};
		init_rom[142] 	= {7'h4E, 16'h66FF, S12_DIGITAL_FILT[9], 2'h0, S12_DIGITAL_FILT[8:7], 2'h0, S12_DIGITAL_FILT[6], 8'h00 };
		init_rom[143] 	= {7'h4F, 16'h666F, S12_DIGITAL_FILT[5], 2'h0, S12_DIGITAL_FILT[4:3], 2'h0, S12_DIGITAL_FILT[2:1], 2'h0, S12_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 13 Initialization
		//***********************************************************************
		init_rom[144]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[145] 	= {7'h10, 16'h1000, S13_CLKOUT4[15:0]};
		init_rom[146] 	= {7'h11, 16'hFC00, S13_CLKOUT4[31:16]};
		init_rom[147] 	= {7'h12, 16'h1000, S13_CLKOUT6[15:0]};
		init_rom[148] 	= (S13_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S13_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S13_CLKOUT6[31:30], S13_CLKFBOUT_FRAC_CALC[35:32],S13_CLKOUT6[25:16]};
		init_rom[149]	= (S13_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S13_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S13_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[150] 	= (S13_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S13_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S13_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[151] 	= {7'h18, 16'hFC00, {6'h00, S13_LOCK[29:20]}};
		init_rom[152] 	= {7'h19, 16'h8000, {1'b0, S13_LOCK[34:30], S13_LOCK[9:0]}};
		init_rom[153] 	= {7'h1A, 16'h8000, {1'b0, S13_LOCK[39:35], S13_LOCK[19:10]}};
		init_rom[154] 	= {7'h4E, 16'h66FF, S13_DIGITAL_FILT[9], 2'h0, S13_DIGITAL_FILT[8:7], 2'h0, S13_DIGITAL_FILT[6], 8'h00 };
		init_rom[155] 	= {7'h4F, 16'h666F, S13_DIGITAL_FILT[5], 2'h0, S13_DIGITAL_FILT[4:3], 2'h0, S13_DIGITAL_FILT[2:1], 2'h0, S13_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 14 Initialization
		//***********************************************************************
		init_rom[156]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[157] 	= {7'h10, 16'h1000, S14_CLKOUT4[15:0]};
		init_rom[158] 	= {7'h11, 16'hFC00, S14_CLKOUT4[31:16]};
		init_rom[159] 	= {7'h12, 16'h1000, S14_CLKOUT6[15:0]};
		init_rom[160] 	= (S14_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S14_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S14_CLKOUT6[31:30], S14_CLKFBOUT_FRAC_CALC[35:32],S14_CLKOUT6[25:16]};
		init_rom[161]	= (S14_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S14_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S14_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[162] 	= (S14_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S14_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S14_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[163] 	= {7'h18, 16'hFC00, {6'h00, S14_LOCK[29:20]}};
		init_rom[164] 	= {7'h19, 16'h8000, {1'b0, S14_LOCK[34:30], S14_LOCK[9:0]}};
		init_rom[165] 	= {7'h1A, 16'h8000, {1'b0, S14_LOCK[39:35], S14_LOCK[19:10]}};
		init_rom[166] 	= {7'h4E, 16'h66FF, S14_DIGITAL_FILT[9], 2'h0, S14_DIGITAL_FILT[8:7], 2'h0, S14_DIGITAL_FILT[6], 8'h00 };
		init_rom[167] 	= {7'h4F, 16'h666F, S14_DIGITAL_FILT[5], 2'h0, S14_DIGITAL_FILT[4:3], 2'h0, S14_DIGITAL_FILT[2:1], 2'h0, S14_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 15 Initialization
		//***********************************************************************
		init_rom[168]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[169] 	= {7'h10, 16'h1000, S15_CLKOUT4[15:0]};
		init_rom[170] 	= {7'h11, 16'hFC00, S15_CLKOUT4[31:16]};
		init_rom[171] 	= {7'h12, 16'h1000, S15_CLKOUT6[15:0]};
		init_rom[172] 	= (S15_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S15_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S15_CLKOUT6[31:30], S15_CLKFBOUT_FRAC_CALC[35:32],S15_CLKOUT6[25:16]};
		init_rom[173]	= (S15_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S15_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S15_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[174] 	= (S15_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S15_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S15_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[175] 	= {7'h18, 16'hFC00, {6'h00, S15_LOCK[29:20]}};
		init_rom[176] 	= {7'h19, 16'h8000, {1'b0, S15_LOCK[34:30], S15_LOCK[9:0]}};
		init_rom[177] 	= {7'h1A, 16'h8000, {1'b0, S15_LOCK[39:35], S15_LOCK[19:10]}};
		init_rom[178] 	= {7'h4E, 16'h66FF, S15_DIGITAL_FILT[9], 2'h0, S15_DIGITAL_FILT[8:7], 2'h0, S15_DIGITAL_FILT[6], 8'h00 };
		init_rom[179] 	= {7'h4F, 16'h666F, S15_DIGITAL_FILT[5], 2'h0, S15_DIGITAL_FILT[4:3], 2'h0, S15_DIGITAL_FILT[2:1], 2'h0, S15_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 16 Initialization
		//***********************************************************************
		init_rom[180]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[181] 	= {7'h10, 16'h1000, S16_CLKOUT4[15:0]};
		init_rom[182] 	= {7'h11, 16'hFC00, S16_CLKOUT4[31:16]};
		init_rom[183] 	= {7'h12, 16'h1000, S16_CLKOUT6[15:0]};
		init_rom[184] 	= (S16_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S16_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S16_CLKOUT6[31:30], S16_CLKFBOUT_FRAC_CALC[35:32],S16_CLKOUT6[25:16]};
		init_rom[185]	= (S16_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S16_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S16_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[186] 	= (S16_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S16_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S16_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[187] 	= {7'h18, 16'hFC00, {6'h00, S16_LOCK[29:20]}};
		init_rom[188] 	= {7'h19, 16'h8000, {1'b0, S16_LOCK[34:30], S16_LOCK[9:0]}};
		init_rom[189] 	= {7'h1A, 16'h8000, {1'b0, S16_LOCK[39:35], S16_LOCK[19:10]}};
		init_rom[190] 	= {7'h4E, 16'h66FF, S16_DIGITAL_FILT[9], 2'h0, S16_DIGITAL_FILT[8:7], 2'h0, S16_DIGITAL_FILT[6], 8'h00 };
		init_rom[191] 	= {7'h4F, 16'h666F, S16_DIGITAL_FILT[5], 2'h0, S16_DIGITAL_FILT[4:3], 2'h0, S16_DIGITAL_FILT[2:1], 2'h0, S16_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 17 Initialization
		//***********************************************************************
		init_rom[192]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[193] 	= {7'h10, 16'h1000, S17_CLKOUT4[15:0]};
		init_rom[194] 	= {7'h11, 16'hFC00, S17_CLKOUT4[31:16]};
		init_rom[195] 	= {7'h12, 16'h1000, S17_CLKOUT6[15:0]};
		init_rom[196] 	= (S17_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S17_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S17_CLKOUT6[31:30], S17_CLKFBOUT_FRAC_CALC[35:32],S17_CLKOUT6[25:16]};
		init_rom[197]	= (S17_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S17_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S17_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[198] 	= (S17_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S17_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S17_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[199] 	= {7'h18, 16'hFC00, {6'h00, S17_LOCK[29:20]}};
		init_rom[200] 	= {7'h19, 16'h8000, {1'b0, S17_LOCK[34:30], S17_LOCK[9:0]}};
		init_rom[201] 	= {7'h1A, 16'h8000, {1'b0, S17_LOCK[39:35], S17_LOCK[19:10]}};
		init_rom[202] 	= {7'h4E, 16'h66FF, S17_DIGITAL_FILT[9], 2'h0, S17_DIGITAL_FILT[8:7], 2'h0, S17_DIGITAL_FILT[6], 8'h00 };
		init_rom[203] 	= {7'h4F, 16'h666F, S17_DIGITAL_FILT[5], 2'h0, S17_DIGITAL_FILT[4:3], 2'h0, S17_DIGITAL_FILT[2:1], 2'h0, S17_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 18 Initialization
		//***********************************************************************
		init_rom[204]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[205] 	= {7'h10, 16'h1000, S18_CLKOUT4[15:0]};
		init_rom[206] 	= {7'h11, 16'hFC00, S18_CLKOUT4[31:16]};
		init_rom[207] 	= {7'h12, 16'h1000, S18_CLKOUT6[15:0]};
		init_rom[208] 	= (S18_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S18_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S18_CLKOUT6[31:30], S18_CLKFBOUT_FRAC_CALC[35:32],S18_CLKOUT6[25:16]};
		init_rom[209]	= (S18_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S18_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S18_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[210] 	= (S18_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S18_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S18_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[211] 	= {7'h18, 16'hFC00, {6'h00, S18_LOCK[29:20]}};
		init_rom[212] 	= {7'h19, 16'h8000, {1'b0, S18_LOCK[34:30], S18_LOCK[9:0]}};
		init_rom[213] 	= {7'h1A, 16'h8000, {1'b0, S18_LOCK[39:35], S18_LOCK[19:10]}};
		init_rom[214] 	= {7'h4E, 16'h66FF, S18_DIGITAL_FILT[9], 2'h0, S18_DIGITAL_FILT[8:7], 2'h0, S18_DIGITAL_FILT[6], 8'h00 };
		init_rom[215] 	= {7'h4F, 16'h666F, S18_DIGITAL_FILT[5], 2'h0, S18_DIGITAL_FILT[4:3], 2'h0, S18_DIGITAL_FILT[2:1], 2'h0, S18_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 19 Initialization
		//***********************************************************************
		init_rom[216]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[217] 	= {7'h10, 16'h1000, S19_CLKOUT4[15:0]};
		init_rom[218] 	= {7'h11, 16'hFC00, S19_CLKOUT4[31:16]};
		init_rom[219] 	= {7'h12, 16'h1000, S19_CLKOUT6[15:0]};
		init_rom[220] 	= (S19_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S19_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S19_CLKOUT6[31:30], S19_CLKFBOUT_FRAC_CALC[35:32],S19_CLKOUT6[25:16]};
		init_rom[221]	= (S19_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S19_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S19_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[222] 	= (S19_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S19_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S19_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[223] 	= {7'h18, 16'hFC00, {6'h00, S19_LOCK[29:20]}};
		init_rom[224] 	= {7'h19, 16'h8000, {1'b0, S19_LOCK[34:30], S19_LOCK[9:0]}};
		init_rom[225] 	= {7'h1A, 16'h8000, {1'b0, S19_LOCK[39:35], S19_LOCK[19:10]}};
		init_rom[226] 	= {7'h4E, 16'h66FF, S19_DIGITAL_FILT[9], 2'h0, S19_DIGITAL_FILT[8:7], 2'h0, S19_DIGITAL_FILT[6], 8'h00 };
		init_rom[227] 	= {7'h4F, 16'h666F, S19_DIGITAL_FILT[5], 2'h0, S19_DIGITAL_FILT[4:3], 2'h0, S19_DIGITAL_FILT[2:1], 2'h0, S19_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 20 Initialization
		//***********************************************************************
		init_rom[228]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[229] 	= {7'h10, 16'h1000, S20_CLKOUT4[15:0]};
		init_rom[230] 	= {7'h11, 16'hFC00, S20_CLKOUT4[31:16]};
		init_rom[231] 	= {7'h12, 16'h1000, S20_CLKOUT6[15:0]};
		init_rom[232] 	= (S20_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S20_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S20_CLKOUT6[31:30], S20_CLKFBOUT_FRAC_CALC[35:32],S20_CLKOUT6[25:16]};
		init_rom[233]	= (S20_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S20_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S20_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[234] 	= (S20_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S20_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S20_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[235] 	= {7'h18, 16'hFC00, {6'h00, S20_LOCK[29:20]}};
		init_rom[236] 	= {7'h19, 16'h8000, {1'b0, S20_LOCK[34:30], S20_LOCK[9:0]}};
		init_rom[237] 	= {7'h1A, 16'h8000, {1'b0, S20_LOCK[39:35], S20_LOCK[19:10]}};
		init_rom[238] 	= {7'h4E, 16'h66FF, S20_DIGITAL_FILT[9], 2'h0, S20_DIGITAL_FILT[8:7], 2'h0, S20_DIGITAL_FILT[6], 8'h00 };
		init_rom[239] 	= {7'h4F, 16'h666F, S20_DIGITAL_FILT[5], 2'h0, S20_DIGITAL_FILT[4:3], 2'h0, S20_DIGITAL_FILT[2:1], 2'h0, S20_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 21 Initialization
		//***********************************************************************
		init_rom[240]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[241] 	= {7'h10, 16'h1000, S21_CLKOUT4[15:0]};
		init_rom[242] 	= {7'h11, 16'hFC00, S21_CLKOUT4[31:16]};
		init_rom[243] 	= {7'h12, 16'h1000, S21_CLKOUT6[15:0]};
		init_rom[244] 	= (S21_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S21_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S21_CLKOUT6[31:30], S21_CLKFBOUT_FRAC_CALC[35:32],S21_CLKOUT6[25:16]};
		init_rom[245]		= (S21_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S21_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S21_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[246] 	= (S21_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S21_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S21_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[247] 	= {7'h18, 16'hFC00, {6'h00, S21_LOCK[29:20]}};
		init_rom[248] 	= {7'h19, 16'h8000, {1'b0, S21_LOCK[34:30], S21_LOCK[9:0]}};
		init_rom[249] 	= {7'h1A, 16'h8000, {1'b0, S21_LOCK[39:35], S21_LOCK[19:10]}};
		init_rom[250] 	= {7'h4E, 16'h66FF, S21_DIGITAL_FILT[9], 2'h0, S21_DIGITAL_FILT[8:7], 2'h0, S21_DIGITAL_FILT[6], 8'h00 };
		init_rom[251] 	= {7'h4F, 16'h666F, S21_DIGITAL_FILT[5], 2'h0, S21_DIGITAL_FILT[4:3], 2'h0, S21_DIGITAL_FILT[2:1], 2'h0, S21_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 22 Initialization
		//***********************************************************************
		init_rom[252]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[253] 	= {7'h10, 16'h1000, S22_CLKOUT4[15:0]};
		init_rom[254] 	= {7'h11, 16'hFC00, S22_CLKOUT4[31:16]};
		init_rom[255] 	= {7'h12, 16'h1000, S22_CLKOUT6[15:0]};
		init_rom[256] 	= (S22_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S22_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S22_CLKOUT6[31:30], S22_CLKFBOUT_FRAC_CALC[35:32],S22_CLKOUT6[25:16]};
		init_rom[257]	= (S22_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S22_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S22_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[258] 	= (S22_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S22_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S22_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[259] 	= {7'h18, 16'hFC00, {6'h00, S22_LOCK[29:20]}};
		init_rom[260] 	= {7'h19, 16'h8000, {1'b0, S22_LOCK[34:30], S22_LOCK[9:0]}};
		init_rom[261] 	= {7'h1A, 16'h8000, {1'b0, S22_LOCK[39:35], S22_LOCK[19:10]}};
		init_rom[262] 	= {7'h4E, 16'h66FF, S22_DIGITAL_FILT[9], 2'h0, S22_DIGITAL_FILT[8:7], 2'h0, S22_DIGITAL_FILT[6], 8'h00 };
		init_rom[263] 	= {7'h4F, 16'h666F, S22_DIGITAL_FILT[5], 2'h0, S22_DIGITAL_FILT[4:3], 2'h0, S22_DIGITAL_FILT[2:1], 2'h0, S22_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 23 Initialization
		//***********************************************************************
		init_rom[264]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[265] 	= {7'h10, 16'h1000, S23_CLKOUT4[15:0]};
		init_rom[266] 	= {7'h11, 16'hFC00, S23_CLKOUT4[31:16]};
		init_rom[267] 	= {7'h12, 16'h1000, S23_CLKOUT6[15:0]};
		init_rom[268] 	= (S23_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S23_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S23_CLKOUT6[31:30], S23_CLKFBOUT_FRAC_CALC[35:32],S23_CLKOUT6[25:16]};
		init_rom[269]	= (S23_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S23_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S23_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[270] 	= (S23_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S23_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S23_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[271] 	= {7'h18, 16'hFC00, {6'h00, S23_LOCK[29:20]}};
		init_rom[272] 	= {7'h19, 16'h8000, {1'b0, S23_LOCK[34:30], S23_LOCK[9:0]}};
		init_rom[273] 	= {7'h1A, 16'h8000, {1'b0, S23_LOCK[39:35], S23_LOCK[19:10]}};
		init_rom[274] 	= {7'h4E, 16'h66FF, S23_DIGITAL_FILT[9], 2'h0, S23_DIGITAL_FILT[8:7], 2'h0, S23_DIGITAL_FILT[6], 8'h00 };
		init_rom[275] 	= {7'h4F, 16'h666F, S23_DIGITAL_FILT[5], 2'h0, S23_DIGITAL_FILT[4:3], 2'h0, S23_DIGITAL_FILT[2:1], 2'h0, S23_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 24 Initialization
		//***********************************************************************
		init_rom[276]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[277] 	= {7'h10, 16'h1000, S24_CLKOUT4[15:0]};
		init_rom[278] 	= {7'h11, 16'hFC00, S24_CLKOUT4[31:16]};
		init_rom[279] 	= {7'h12, 16'h1000, S24_CLKOUT6[15:0]};
		init_rom[280] 	= (S24_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S24_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S24_CLKOUT6[31:30], S24_CLKFBOUT_FRAC_CALC[35:32],S24_CLKOUT6[25:16]};
		init_rom[281]	= (S24_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S24_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S24_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[282] 	= (S24_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S24_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S24_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[283] 	= {7'h18, 16'hFC00, {6'h00, S24_LOCK[29:20]}};
		init_rom[284] 	= {7'h19, 16'h8000, {1'b0, S24_LOCK[34:30], S24_LOCK[9:0]}};
		init_rom[285] 	= {7'h1A, 16'h8000, {1'b0, S24_LOCK[39:35], S24_LOCK[19:10]}};
		init_rom[286] 	= {7'h4E, 16'h66FF, S24_DIGITAL_FILT[9], 2'h0, S24_DIGITAL_FILT[8:7], 2'h0, S24_DIGITAL_FILT[6], 8'h00 };
		init_rom[287] 	= {7'h4F, 16'h666F, S24_DIGITAL_FILT[5], 2'h0, S24_DIGITAL_FILT[4:3], 2'h0, S24_DIGITAL_FILT[2:1], 2'h0, S24_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 25 Initialization
		//***********************************************************************
		init_rom[288]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[289] 	= {7'h10, 16'h1000, S25_CLKOUT4[15:0]};
		init_rom[290] 	= {7'h11, 16'hFC00, S25_CLKOUT4[31:16]};
		init_rom[291] 	= {7'h12, 16'h1000, S25_CLKOUT6[15:0]};
		init_rom[292] 	= (S25_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S25_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S25_CLKOUT6[31:30], S25_CLKFBOUT_FRAC_CALC[35:32],S25_CLKOUT6[25:16]};
		init_rom[293]	= (S25_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S25_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S25_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[294] 	= (S25_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S25_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S25_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[295] 	= {7'h18, 16'hFC00, {6'h00, S25_LOCK[29:20]}};
		init_rom[296] 	= {7'h19, 16'h8000, {1'b0, S25_LOCK[34:30], S25_LOCK[9:0]}};
		init_rom[297] 	= {7'h1A, 16'h8000, {1'b0, S25_LOCK[39:35], S25_LOCK[19:10]}};
		init_rom[298] 	= {7'h4E, 16'h66FF, S25_DIGITAL_FILT[9], 2'h0, S25_DIGITAL_FILT[8:7], 2'h0, S25_DIGITAL_FILT[6], 8'h00 };
		init_rom[299] 	= {7'h4F, 16'h666F, S25_DIGITAL_FILT[5], 2'h0, S25_DIGITAL_FILT[4:3], 2'h0, S25_DIGITAL_FILT[2:1], 2'h0, S25_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 26 Initialization
		//***********************************************************************
		init_rom[300]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[301] 	= {7'h10, 16'h1000, S26_CLKOUT4[15:0]};
		init_rom[302] 	= {7'h11, 16'hFC00, S26_CLKOUT4[31:16]};
		init_rom[303] 	= {7'h12, 16'h1000, S26_CLKOUT6[15:0]};
		init_rom[304] 	= (S26_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S26_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S26_CLKOUT6[31:30], S26_CLKFBOUT_FRAC_CALC[35:32],S26_CLKOUT6[25:16]};
		init_rom[305]	= (S26_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S26_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S26_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[306] 	= (S26_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S26_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S26_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[307] 	= {7'h18, 16'hFC00, {6'h00, S26_LOCK[29:20]}};
		init_rom[308] 	= {7'h19, 16'h8000, {1'b0, S26_LOCK[34:30], S26_LOCK[9:0]}};
		init_rom[309] 	= {7'h1A, 16'h8000, {1'b0, S26_LOCK[39:35], S26_LOCK[19:10]}};
		init_rom[310] 	= {7'h4E, 16'h66FF, S26_DIGITAL_FILT[9], 2'h0, S26_DIGITAL_FILT[8:7], 2'h0, S26_DIGITAL_FILT[6], 8'h00 };
		init_rom[311] 	= {7'h4F, 16'h666F, S26_DIGITAL_FILT[5], 2'h0, S26_DIGITAL_FILT[4:3], 2'h0, S26_DIGITAL_FILT[2:1], 2'h0, S26_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 27 Initialization
		//***********************************************************************
		init_rom[312]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[313] 	= {7'h10, 16'h1000, S27_CLKOUT4[15:0]};
		init_rom[314] 	= {7'h11, 16'hFC00, S27_CLKOUT4[31:16]};
		init_rom[315] 	= {7'h12, 16'h1000, S27_CLKOUT6[15:0]};
		init_rom[316] 	= (S27_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S27_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S27_CLKOUT6[31:30], S27_CLKFBOUT_FRAC_CALC[35:32],S27_CLKOUT6[25:16]};
		init_rom[317]	= (S27_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S27_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S27_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[318] 	= (S27_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S27_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S27_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[319] 	= {7'h18, 16'hFC00, {6'h00, S27_LOCK[29:20]}};
		init_rom[320] 	= {7'h19, 16'h8000, {1'b0, S27_LOCK[34:30], S27_LOCK[9:0]}};
		init_rom[321] 	= {7'h1A, 16'h8000, {1'b0, S27_LOCK[39:35], S27_LOCK[19:10]}};
		init_rom[322] 	= {7'h4E, 16'h66FF, S27_DIGITAL_FILT[9], 2'h0, S27_DIGITAL_FILT[8:7], 2'h0, S27_DIGITAL_FILT[6], 8'h00 };
		init_rom[323] 	= {7'h4F, 16'h666F, S27_DIGITAL_FILT[5], 2'h0, S27_DIGITAL_FILT[4:3], 2'h0, S27_DIGITAL_FILT[2:1], 2'h0, S27_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 28 Initialization
		//***********************************************************************
		init_rom[324]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[325] 	= {7'h10, 16'h1000, S28_CLKOUT4[15:0]};
		init_rom[326] 	= {7'h11, 16'hFC00, S28_CLKOUT4[31:16]};
		init_rom[327] 	= {7'h12, 16'h1000, S28_CLKOUT6[15:0]};
		init_rom[328] 	= (S28_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S28_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S28_CLKOUT6[31:30], S28_CLKFBOUT_FRAC_CALC[35:32],S28_CLKOUT6[25:16]};
		init_rom[329]	= (S28_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S28_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S28_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[330] 	= (S28_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S28_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S28_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[331] 	= {7'h18, 16'hFC00, {6'h00, S28_LOCK[29:20]}};
		init_rom[332] 	= {7'h19, 16'h8000, {1'b0, S28_LOCK[34:30], S28_LOCK[9:0]}};
		init_rom[333] 	= {7'h1A, 16'h8000, {1'b0, S28_LOCK[39:35], S28_LOCK[19:10]}};
		init_rom[334] 	= {7'h4E, 16'h66FF, S28_DIGITAL_FILT[9], 2'h0, S28_DIGITAL_FILT[8:7], 2'h0, S28_DIGITAL_FILT[6], 8'h00 };
		init_rom[335] 	= {7'h4F, 16'h666F, S28_DIGITAL_FILT[5], 2'h0, S28_DIGITAL_FILT[4:3], 2'h0, S28_DIGITAL_FILT[2:1], 2'h0, S28_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 29 Initialization
		//***********************************************************************
		init_rom[336]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[337] 	= {7'h10, 16'h1000, S29_CLKOUT4[15:0]};
		init_rom[338] 	= {7'h11, 16'hFC00, S29_CLKOUT4[31:16]};
		init_rom[339] 	= {7'h12, 16'h1000, S29_CLKOUT6[15:0]};
		init_rom[340] 	= (S29_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S29_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S29_CLKOUT6[31:30], S29_CLKFBOUT_FRAC_CALC[35:32],S29_CLKOUT6[25:16]};
		init_rom[341]	= (S29_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S29_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S29_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[342] 	= (S29_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S29_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S29_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[343] 	= {7'h18, 16'hFC00, {6'h00, S29_LOCK[29:20]}};
		init_rom[344] 	= {7'h19, 16'h8000, {1'b0, S29_LOCK[34:30], S29_LOCK[9:0]}};
		init_rom[345] 	= {7'h1A, 16'h8000, {1'b0, S29_LOCK[39:35], S29_LOCK[19:10]}};
		init_rom[346] 	= {7'h4E, 16'h66FF, S29_DIGITAL_FILT[9], 2'h0, S29_DIGITAL_FILT[8:7], 2'h0, S29_DIGITAL_FILT[6], 8'h00 };
		init_rom[347] 	= {7'h4F, 16'h666F, S29_DIGITAL_FILT[5], 2'h0, S29_DIGITAL_FILT[4:3], 2'h0, S29_DIGITAL_FILT[2:1], 2'h0, S29_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 30 Initialization
		//***********************************************************************
		init_rom[348]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[349] 	= {7'h10, 16'h1000, S30_CLKOUT4[15:0]};
		init_rom[350] 	= {7'h11, 16'hFC00, S30_CLKOUT4[31:16]};
		init_rom[351] 	= {7'h12, 16'h1000, S30_CLKOUT6[15:0]};
		init_rom[352] 	= (S30_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S30_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S30_CLKOUT6[31:30], S30_CLKFBOUT_FRAC_CALC[35:32],S30_CLKOUT6[25:16]};
		init_rom[353]	= (S30_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S30_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S30_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[354] 	= (S30_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S30_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S30_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[355] 	= {7'h18, 16'hFC00, {6'h00, S30_LOCK[29:20]}};
		init_rom[356] 	= {7'h19, 16'h8000, {1'b0, S30_LOCK[34:30], S30_LOCK[9:0]}};
		init_rom[357] 	= {7'h1A, 16'h8000, {1'b0, S30_LOCK[39:35], S30_LOCK[19:10]}};
		init_rom[358] 	= {7'h4E, 16'h66FF, S30_DIGITAL_FILT[9], 2'h0, S30_DIGITAL_FILT[8:7], 2'h0, S30_DIGITAL_FILT[6], 8'h00 };
		init_rom[359] 	= {7'h4F, 16'h666F, S30_DIGITAL_FILT[5], 2'h0, S30_DIGITAL_FILT[4:3], 2'h0, S30_DIGITAL_FILT[2:1], 2'h0, S30_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 31 Initialization
		//***********************************************************************
		init_rom[360]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[361] 	= {7'h10, 16'h1000, S31_CLKOUT4[15:0]};
		init_rom[362] 	= {7'h11, 16'hFC00, S31_CLKOUT4[31:16]};
		init_rom[363] 	= {7'h12, 16'h1000, S31_CLKOUT6[15:0]};
		init_rom[364] 	= (S31_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S31_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S31_CLKOUT6[31:30], S31_CLKFBOUT_FRAC_CALC[35:32],S31_CLKOUT6[25:16]};
		init_rom[365]		= (S31_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S31_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S31_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[366] 	= (S31_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S31_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S31_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[367] 	= {7'h18, 16'hFC00, {6'h00, S31_LOCK[29:20]}};
		init_rom[368] 	= {7'h19, 16'h8000, {1'b0, S31_LOCK[34:30], S31_LOCK[9:0]}};
		init_rom[369] 	= {7'h1A, 16'h8000, {1'b0, S31_LOCK[39:35], S31_LOCK[19:10]}};
		init_rom[370] 	= {7'h4E, 16'h66FF, S31_DIGITAL_FILT[9], 2'h0, S31_DIGITAL_FILT[8:7], 2'h0, S31_DIGITAL_FILT[6], 8'h00 };
		init_rom[371] 	= {7'h4F, 16'h666F, S31_DIGITAL_FILT[5], 2'h0, S31_DIGITAL_FILT[4:3], 2'h0, S31_DIGITAL_FILT[2:1], 2'h0, S31_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 32 Initialization
		//***********************************************************************
		init_rom[372]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[373] 	= {7'h10, 16'h1000, S32_CLKOUT4[15:0]};
		init_rom[374] 	= {7'h11, 16'hFC00, S32_CLKOUT4[31:16]};
		init_rom[375] 	= {7'h12, 16'h1000, S32_CLKOUT6[15:0]};
		init_rom[376] 	= (S32_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S32_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S32_CLKOUT6[31:30], S32_CLKFBOUT_FRAC_CALC[35:32],S32_CLKOUT6[25:16]};
		init_rom[377]	= (S32_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S32_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S32_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[378] 	= (S32_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S32_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S32_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[379] 	= {7'h18, 16'hFC00, {6'h00, S32_LOCK[29:20]}};
		init_rom[380] 	= {7'h19, 16'h8000, {1'b0, S32_LOCK[34:30], S32_LOCK[9:0]}};
		init_rom[381] 	= {7'h1A, 16'h8000, {1'b0, S32_LOCK[39:35], S32_LOCK[19:10]}};
		init_rom[382] 	= {7'h4E, 16'h66FF, S32_DIGITAL_FILT[9], 2'h0, S32_DIGITAL_FILT[8:7], 2'h0, S32_DIGITAL_FILT[6], 8'h00 };
		init_rom[383] 	= {7'h4F, 16'h666F, S32_DIGITAL_FILT[5], 2'h0, S32_DIGITAL_FILT[4:3], 2'h0, S32_DIGITAL_FILT[2:1], 2'h0, S32_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 33 Initialization
		//***********************************************************************
		init_rom[384]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[385] 	= {7'h10, 16'h1000, S33_CLKOUT4[15:0]};
		init_rom[386] 	= {7'h11, 16'hFC00, S33_CLKOUT4[31:16]};
		init_rom[387] 	= {7'h12, 16'h1000, S33_CLKOUT6[15:0]};
		init_rom[388] 	= (S33_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S33_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S33_CLKOUT6[31:30], S33_CLKFBOUT_FRAC_CALC[35:32],S33_CLKOUT6[25:16]};
		init_rom[389]	= (S33_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S33_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S33_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[390] 	= (S33_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S33_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S33_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[391] 	= {7'h18, 16'hFC00, {6'h00, S33_LOCK[29:20]}};
		init_rom[392] 	= {7'h19, 16'h8000, {1'b0, S33_LOCK[34:30], S33_LOCK[9:0]}};
		init_rom[393] 	= {7'h1A, 16'h8000, {1'b0, S33_LOCK[39:35], S33_LOCK[19:10]}};
		init_rom[394] 	= {7'h4E, 16'h66FF, S33_DIGITAL_FILT[9], 2'h0, S33_DIGITAL_FILT[8:7], 2'h0, S33_DIGITAL_FILT[6], 8'h00 };
		init_rom[395] 	= {7'h4F, 16'h666F, S33_DIGITAL_FILT[5], 2'h0, S33_DIGITAL_FILT[4:3], 2'h0, S33_DIGITAL_FILT[2:1], 2'h0, S33_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 34 Initialization
		//***********************************************************************
		init_rom[396]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[397] 	= {7'h10, 16'h1000, S34_CLKOUT4[15:0]};
		init_rom[398] 	= {7'h11, 16'hFC00, S34_CLKOUT4[31:16]};
		init_rom[399] 	= {7'h12, 16'h1000, S34_CLKOUT6[15:0]};
		init_rom[400] 	= (S34_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S34_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S34_CLKOUT6[31:30], S34_CLKFBOUT_FRAC_CALC[35:32],S34_CLKOUT6[25:16]};
		init_rom[401]	= (S34_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S34_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S34_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[402] 	= (S34_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S34_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S34_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[403] 	= {7'h18, 16'hFC00, {6'h00, S34_LOCK[29:20]}};
		init_rom[404] 	= {7'h19, 16'h8000, {1'b0, S34_LOCK[34:30], S34_LOCK[9:0]}};
		init_rom[405] 	= {7'h1A, 16'h8000, {1'b0, S34_LOCK[39:35], S34_LOCK[19:10]}};
		init_rom[406] 	= {7'h4E, 16'h66FF, S34_DIGITAL_FILT[9], 2'h0, S34_DIGITAL_FILT[8:7], 2'h0, S34_DIGITAL_FILT[6], 8'h00 };
		init_rom[407] 	= {7'h4F, 16'h666F, S34_DIGITAL_FILT[5], 2'h0, S34_DIGITAL_FILT[4:3], 2'h0, S34_DIGITAL_FILT[2:1], 2'h0, S34_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 35 Initialization
		//***********************************************************************
		init_rom[408]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[409] 	= {7'h10, 16'h1000, S35_CLKOUT4[15:0]};
		init_rom[410] 	= {7'h11, 16'hFC00, S35_CLKOUT4[31:16]};
		init_rom[411] 	= {7'h12, 16'h1000, S35_CLKOUT6[15:0]};
		init_rom[412] 	= (S35_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S35_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S35_CLKOUT6[31:30], S35_CLKFBOUT_FRAC_CALC[35:32],S35_CLKOUT6[25:16]};
		init_rom[413]	= (S35_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S35_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S35_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[414] 	= (S35_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S35_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S35_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[415] 	= {7'h18, 16'hFC00, {6'h00, S35_LOCK[29:20]}};
		init_rom[416] 	= {7'h19, 16'h8000, {1'b0, S35_LOCK[34:30], S35_LOCK[9:0]}};
		init_rom[417] 	= {7'h1A, 16'h8000, {1'b0, S35_LOCK[39:35], S35_LOCK[19:10]}};
		init_rom[418] 	= {7'h4E, 16'h66FF, S35_DIGITAL_FILT[9], 2'h0, S35_DIGITAL_FILT[8:7], 2'h0, S35_DIGITAL_FILT[6], 8'h00 };
		init_rom[419] 	= {7'h4F, 16'h666F, S35_DIGITAL_FILT[5], 2'h0, S35_DIGITAL_FILT[4:3], 2'h0, S35_DIGITAL_FILT[2:1], 2'h0, S35_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 36 Initialization
		//***********************************************************************
		init_rom[420]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[421] 	= {7'h10, 16'h1000, S36_CLKOUT4[15:0]};
		init_rom[422] 	= {7'h11, 16'hFC00, S36_CLKOUT4[31:16]};
		init_rom[423] 	= {7'h12, 16'h1000, S36_CLKOUT6[15:0]};
		init_rom[424] 	= (S36_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S36_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S36_CLKOUT6[31:30], S36_CLKFBOUT_FRAC_CALC[35:32],S36_CLKOUT6[25:16]};
		init_rom[425]	= (S36_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S36_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S36_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[426] 	= (S36_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S36_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S36_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[427] 	= {7'h18, 16'hFC00, {6'h00, S36_LOCK[29:20]}};
		init_rom[428] 	= {7'h19, 16'h8000, {1'b0, S36_LOCK[34:30], S36_LOCK[9:0]}};
		init_rom[429] 	= {7'h1A, 16'h8000, {1'b0, S36_LOCK[39:35], S36_LOCK[19:10]}};
		init_rom[430] 	= {7'h4E, 16'h66FF, S36_DIGITAL_FILT[9], 2'h0, S36_DIGITAL_FILT[8:7], 2'h0, S36_DIGITAL_FILT[6], 8'h00 };
		init_rom[431] 	= {7'h4F, 16'h666F, S36_DIGITAL_FILT[5], 2'h0, S36_DIGITAL_FILT[4:3], 2'h0, S36_DIGITAL_FILT[2:1], 2'h0, S36_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 37 Initialization
		//***********************************************************************
		init_rom[432]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[433] 	= {7'h10, 16'h1000, S37_CLKOUT4[15:0]};
		init_rom[434] 	= {7'h11, 16'hFC00, S37_CLKOUT4[31:16]};
		init_rom[435] 	= {7'h12, 16'h1000, S37_CLKOUT6[15:0]};
		init_rom[436] 	= (S37_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S37_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S37_CLKOUT6[31:30], S37_CLKFBOUT_FRAC_CALC[35:32],S37_CLKOUT6[25:16]};
		init_rom[437]	= (S37_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S37_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S37_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[438] 	= (S37_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S37_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S37_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[439] 	= {7'h18, 16'hFC00, {6'h00, S37_LOCK[29:20]}};
		init_rom[440] 	= {7'h19, 16'h8000, {1'b0, S37_LOCK[34:30], S37_LOCK[9:0]}};
		init_rom[441] 	= {7'h1A, 16'h8000, {1'b0, S37_LOCK[39:35], S37_LOCK[19:10]}};
		init_rom[442] 	= {7'h4E, 16'h66FF, S37_DIGITAL_FILT[9], 2'h0, S37_DIGITAL_FILT[8:7], 2'h0, S37_DIGITAL_FILT[6], 8'h00 };
		init_rom[443] 	= {7'h4F, 16'h666F, S37_DIGITAL_FILT[5], 2'h0, S37_DIGITAL_FILT[4:3], 2'h0, S37_DIGITAL_FILT[2:1], 2'h0, S37_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 38 Initialization
		//***********************************************************************
		init_rom[444]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[445] 	= {7'h10, 16'h1000, S38_CLKOUT4[15:0]};
		init_rom[446] 	= {7'h11, 16'hFC00, S38_CLKOUT4[31:16]};
		init_rom[447] 	= {7'h12, 16'h1000, S38_CLKOUT6[15:0]};
		init_rom[448] 	= (S38_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S38_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S38_CLKOUT6[31:30], S38_CLKFBOUT_FRAC_CALC[35:32],S38_CLKOUT6[25:16]};
		init_rom[449]	= (S38_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S38_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S38_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[450] 	= (S38_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S38_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S38_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[451] 	= {7'h18, 16'hFC00, {6'h00, S38_LOCK[29:20]}};
		init_rom[452] 	= {7'h19, 16'h8000, {1'b0, S38_LOCK[34:30], S38_LOCK[9:0]}};
		init_rom[453] 	= {7'h1A, 16'h8000, {1'b0, S38_LOCK[39:35], S38_LOCK[19:10]}};
		init_rom[454] 	= {7'h4E, 16'h66FF, S38_DIGITAL_FILT[9], 2'h0, S38_DIGITAL_FILT[8:7], 2'h0, S38_DIGITAL_FILT[6], 8'h00 };
		init_rom[455] 	= {7'h4F, 16'h666F, S38_DIGITAL_FILT[5], 2'h0, S38_DIGITAL_FILT[4:3], 2'h0, S38_DIGITAL_FILT[2:1], 2'h0, S38_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 39 Initialization
		//***********************************************************************
		init_rom[456]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[457] 	= {7'h10, 16'h1000, S39_CLKOUT4[15:0]};
		init_rom[458] 	= {7'h11, 16'hFC00, S39_CLKOUT4[31:16]};
		init_rom[459] 	= {7'h12, 16'h1000, S39_CLKOUT6[15:0]};
		init_rom[460] 	= (S39_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S39_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S39_CLKOUT6[31:30], S39_CLKFBOUT_FRAC_CALC[35:32],S39_CLKOUT6[25:16]};
		init_rom[461]	= (S39_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S39_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S39_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[462] 	= (S39_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S39_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S39_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[463] 	= {7'h18, 16'hFC00, {6'h00, S39_LOCK[29:20]}};
		init_rom[464] 	= {7'h19, 16'h8000, {1'b0, S39_LOCK[34:30], S39_LOCK[9:0]}};
		init_rom[465] 	= {7'h1A, 16'h8000, {1'b0, S39_LOCK[39:35], S39_LOCK[19:10]}};
		init_rom[466] 	= {7'h4E, 16'h66FF, S39_DIGITAL_FILT[9], 2'h0, S39_DIGITAL_FILT[8:7], 2'h0, S39_DIGITAL_FILT[6], 8'h00 };
		init_rom[467] 	= {7'h4F, 16'h666F, S39_DIGITAL_FILT[5], 2'h0, S39_DIGITAL_FILT[4:3], 2'h0, S39_DIGITAL_FILT[2:1], 2'h0, S39_DIGITAL_FILT[0], 4'h0};
		//***********************************************************************
		// State 40 Initialization
		//***********************************************************************
		init_rom[468]	= {7'h28, 16'h0000, 16'hFFFF};
		init_rom[469] 	= {7'h10, 16'h1000, S40_CLKOUT4[15:0]};
		init_rom[470] 	= {7'h11, 16'hFC00, S40_CLKOUT4[31:16]};
		init_rom[471] 	= {7'h12, 16'h1000, S40_CLKOUT6[15:0]};
		init_rom[472] 	= (S40_CLKFBOUT_FRAC_EN == 0) ?
                  	 	  {7'h13, 16'hC000, S40_CLKOUT6[31:16]}:
                  		  {7'h13, 16'hC000, S40_CLKOUT6[31:30], S40_CLKFBOUT_FRAC_CALC[35:32],S40_CLKOUT6[25:16]};
		init_rom[473]	= (S40_CLKFBOUT_FRAC_EN == 0) ?
						  {7'h14, 16'h1000, S40_CLKFBOUT[15:0]}:
						  {7'h14, 16'h1000, S40_CLKFBOUT_FRAC_CALC[15:0]};
		init_rom[474] 	= (S40_CLKFBOUT_FRAC_EN == 0) ?
				  		  {7'h15, 16'h8000, S40_CLKFBOUT[31:16]}:
				  		  {7'h15, 16'h8000, S40_CLKFBOUT_FRAC_CALC[31:16]};
		init_rom[475] 	= {7'h18, 16'hFC00, {6'h00, S40_LOCK[29:20]}};
		init_rom[476] 	= {7'h19, 16'h8000, {1'b0, S40_LOCK[34:30], S40_LOCK[9:0]}};
		init_rom[477] 	= {7'h1A, 16'h8000, {1'b0, S40_LOCK[39:35], S40_LOCK[19:10]}};
		init_rom[478] 	= {7'h4E, 16'h66FF, S40_DIGITAL_FILT[9], 2'h0, S40_DIGITAL_FILT[8:7], 2'h0, S40_DIGITAL_FILT[6], 8'h00 };
		init_rom[479] 	= {7'h4F, 16'h666F, S40_DIGITAL_FILT[5], 2'h0, S40_DIGITAL_FILT[4:3], 2'h0, S40_DIGITAL_FILT[2:1], 2'h0, S40_DIGITAL_FILT[0], 4'h0};

        rom_init = init_rom[index];
	end
endfunction