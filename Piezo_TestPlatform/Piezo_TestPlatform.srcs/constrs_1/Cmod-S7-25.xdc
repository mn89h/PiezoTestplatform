## This file is a general .xdc for the Cmod S7-25 Rev. B
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

# 12 MHz System Clock
set_property -dict {PACKAGE_PIN M9 IOSTANDARD LVCMOS33} [get_ports sysclk_pin]
create_clock -period 83.330 -name sys_clk_pin -waveform {0.000 41.660} -add [get_ports sysclk_pin]

# Push Buttons
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports btn0_pin]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports btn1_pin]

# RGB LEDs
#set_property -dict { PACKAGE_PIN F1    IOSTANDARD LVCMOS33 } [get_ports { led0_b_pin }]; #IO_L10N_T1_34 Sch=led0_b
#set_property -dict { PACKAGE_PIN D3    IOSTANDARD LVCMOS33 } [get_ports { led0_g_pin }]; #IO_L9N_T1_DQS_34 Sch=led0_g
#set_property -dict { PACKAGE_PIN F2    IOSTANDARD LVCMOS33 } [get_ports { led0_r_pin }]; #IO_L10P_T1_34 Sch=led0_r

# 4 LEDs
set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports led1_pin]
set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports led2_pin]
set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports led3_pin]
set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports led4_pin]

## Pmod Header JA
#set_property -dict { PACKAGE_PIN J2    IOSTANDARD LVCMOS33 } [get_ports { ja[0] }]; #IO_L14P_T2_SRCC_34 Sch=ja[1]
#set_property -dict { PACKAGE_PIN H2    IOSTANDARD LVCMOS33 } [get_ports { ja[1] }]; #IO_L14N_T2_SRCC_34 Sch=ja[2]
#set_property -dict { PACKAGE_PIN H4    IOSTANDARD LVCMOS33 } [get_ports { ja[2] }]; #IO_L13P_T2_MRCC_34 Sch=ja[3]
#set_property -dict { PACKAGE_PIN F3    IOSTANDARD LVCMOS33 } [get_ports { ja[3] }]; #IO_L11N_T1_SRCC_34 Sch=ja[4]
#set_property -dict { PACKAGE_PIN H3    IOSTANDARD LVCMOS33 } [get_ports { ja[4] }]; #IO_L13N_T2_MRCC_34 Sch=ja[7]
#set_property -dict { PACKAGE_PIN H1    IOSTANDARD LVCMOS33 } [get_ports { ja[5] }]; #IO_L12P_T1_MRCC_34 Sch=ja[8]
#set_property -dict { PACKAGE_PIN G1    IOSTANDARD LVCMOS33 } [get_ports { ja[6] }]; #IO_L12N_T1_MRCC_34 Sch=ja[9]
#set_property -dict { PACKAGE_PIN F4    IOSTANDARD LVCMOS33 } [get_ports { ja[7] }]; #IO_L11P_T1_SRCC_34 Sch=ja[10]

## USB UART
## Note: Port names are from the perspoctive of the FPGA.
set_property -dict {PACKAGE_PIN L12 IOSTANDARD LVCMOS33} [get_ports uart_tx_pin]
set_property -dict {PACKAGE_PIN K15 IOSTANDARD LVCMOS33} [get_ports uart_rx_pin]

## Analog Inputs on PIO Pins 32 and 33
#set_property -dict { PACKAGE_PIN A13   IOSTANDARD LVDS     } [get_ports { vaux5_p }]; #IO_L12P_T1_MRCC_AD5P_15 Sch=ain_p[32]
#set_property -dict { PACKAGE_PIN A14   IOSTANDARD LVDS     } [get_ports { vaux5_n }]; #IO_L12N_T1_MRCC_AD5N_15 Sch=ain_n[32]
#set_property -dict { PACKAGE_PIN A11   IOSTANDARD LVDS     } [get_ports { vaux12_p }]; #IO_L11P_T1_SRCC_AD12P_15 Sch=ain_p[33]
#set_property -dict { PACKAGE_PIN A12   IOSTANDARD LVDS     } [get_ports { vaux12_n }]; #IO_L11N_T1_SRCC_AD12N_15 Sch=ain_n[33]

## Dedicated Digital I/O on the PIO Headers
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[9]}]
set_property -dict {PACKAGE_PIN M4 IOSTANDARD LVCMOS33} [get_ports adc_en_pin]
set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS33} [get_ports adc_clk_pin]
set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports comp_in_pin]
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports vga_en_pin]
set_property -dict {PACKAGE_PIN P3 IOSTANDARD LVCMOS33} [get_ports {vga_gain_pins[3]}]
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {vga_gain_pins[2]}]
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {vga_gain_pins[1]}]
set_property -dict {PACKAGE_PIN N1 IOSTANDARD LVCMOS33} [get_ports {vga_gain_pins[0]}]
set_property -dict {PACKAGE_PIN P14 IOSTANDARD LVCMOS33} [get_ports piezodriverb_lo_pin]
set_property -dict {PACKAGE_PIN P15 IOSTANDARD LVCMOS33} [get_ports piezodrivera_hi_pin]
set_property -dict {PACKAGE_PIN N13 IOSTANDARD LVCMOS33} [get_ports comp_en_pin]
#set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { pio19 }]; #IO_L10N_T1_D15_14 Sch=pio[19]
set_property -dict {PACKAGE_PIN N14 IOSTANDARD LVCMOS33} [get_ports extled3_pin]
set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports extled4_pin]
set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports extled5_pin]
set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports extled6_pin]
set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports extled1_pin]
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports extled2_pin]
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports extsw1_pin]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports extsw2_pin]
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports extsw3_pin]
set_property -dict {PACKAGE_PIN J11 IOSTANDARD LVCMOS33} [get_ports extsw4_pin]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[0]}]
set_property -dict {PACKAGE_PIN A2 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[1]}]
set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[2]}]
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[3]}]
set_property -dict {PACKAGE_PIN C1 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[4]}]
set_property -dict {PACKAGE_PIN B3 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[5]}]
set_property -dict {PACKAGE_PIN B4 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[6]}]
set_property -dict {PACKAGE_PIN A3 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[7]}]
set_property -dict {PACKAGE_PIN A4 IOSTANDARD LVCMOS33} [get_ports {adc_in_pins[8]}]

## Quad SPI Flash
## Note: QSPI clock can only be accessed through the STARTUPE2 primitive
#set_property -dict { PACKAGE_PIN L11   IOSTANDARD LVCMOS33 } [get_ports { qspi_cs }]; #IO_L6P_T0_FCS_B_14 Sch=qspi_cs
#set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[0] }]; #IO_L1P_T0_D00_MOSI_14 Sch=qspi_dq[0]
#set_property -dict { PACKAGE_PIN H15   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[1] }]; #IO_L1N_T0_D01_DIN_14 Sch=qspi_dq[1]
#set_property -dict { PACKAGE_PIN J12   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[2] }]; #IO_L2P_T0_D02_14 Sch=qspi_dq[2]
#set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { qspi_dq[3] }]; #IO_L2N_T0_D03_14 Sch=qspi_dq[3]


set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]

set_property PULLUP true [get_ports extsw1_pin]
set_property PULLUP true [get_ports extsw2_pin]
set_property PULLUP true [get_ports extsw3_pin]
set_property PULLUP true [get_ports extsw4_pin]

create_clock -period 333.320 -name VIRTUAL_clk_adc_unbuf -waveform {0.000 166.660}
set_input_delay -clock [get_clocks VIRTUAL_clk_adc_unbuf] -min -add_delay 2.000 [get_ports {adc_in_pins[*]}]
set_input_delay -clock [get_clocks VIRTUAL_clk_adc_unbuf] -max -add_delay 6.000 [get_ports {adc_in_pins[*]}]
set_input_delay -clock [get_clocks sys_clk_pin] -min -add_delay -0.500 [get_ports extsw1_pin]
set_input_delay -clock [get_clocks sys_clk_pin] -max -add_delay 0.000 [get_ports extsw1_pin]
set_input_delay -clock [get_clocks sys_clk_pin] -min -add_delay -0.500 [get_ports extsw3_pin]
set_input_delay -clock [get_clocks sys_clk_pin] -max -add_delay 0.000 [get_ports extsw3_pin]
set_input_delay -clock [get_clocks sys_clk_pin] -min -add_delay -0.500 [get_ports extsw4_pin]
set_input_delay -clock [get_clocks sys_clk_pin] -max -add_delay 0.000 [get_ports extsw4_pin]
set_input_delay -clock [get_clocks sys_clk_pin] -min -add_delay -0.500 [get_ports uart_rx_pin]
set_input_delay -clock [get_clocks sys_clk_pin] -max -add_delay 0.000 [get_ports uart_rx_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports {vga_gain_pins[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports {vga_gain_pins[*]}]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports adc_en_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports adc_en_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports extled1_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports extled1_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports extled2_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports extled2_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports extled3_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports extled3_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports extled4_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports extled4_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports extled5_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports extled5_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports extled6_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports extled6_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports led1_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports led1_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports led2_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports led2_pin]
create_clock -period 4.000 -name VIRTUAL_clk_250_unbuf -waveform {0.000 2.000}
set_output_delay -clock [get_clocks VIRTUAL_clk_250_unbuf] -min -add_delay -5.000 [get_ports piezodrivera_hi_pin]
set_output_delay -clock [get_clocks VIRTUAL_clk_250_unbuf] -max -add_delay 5.000 [get_ports piezodrivera_hi_pin]
set_output_delay -clock [get_clocks VIRTUAL_clk_250_unbuf] -min -add_delay -5.000 [get_ports piezodriverb_lo_pin]
set_output_delay -clock [get_clocks VIRTUAL_clk_250_unbuf] -max -add_delay 5.000 [get_ports piezodriverb_lo_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports uart_tx_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports uart_tx_pin]
set_false_path -to [get_ports {extled1_pin extled2_pin extled3_pin extled4_pin extled5_pin extled6_pin led1_pin led2_pin led3_pin led4_pin}]
set_false_path -from [get_ports {btn0_pin btn1_pin extsw1_pin extsw2_pin extsw3_pin extsw4_pin}]
set_false_path -to [get_ports piezodriverb_lo_pin]
set_false_path -to [get_ports piezodrivera_hi_pin]
set_false_path -from [get_pins {u_comp_driver/u_cdc_reset/syncstages_ff_reg[1]/C}]

set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

create_clock -period 83.330 -name VIRTUAL_clk_comp_unbuf -waveform {0.000 41.665}
set_input_delay -clock [get_clocks VIRTUAL_clk_comp_unbuf] -min -add_delay 2.000 [get_ports comp_in_pin]
set_input_delay -clock [get_clocks VIRTUAL_clk_comp_unbuf] -max -add_delay 6.000 [get_ports comp_in_pin]
#create_clock -period 2.604 -name VIRTUAL_clk_250_unbuf -waveform {0.000 1.302}
#create_clock -period 3.333 -name VIRTUAL_clk_250_unbuf -waveform {0.000 1.667}
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports comp_en_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports comp_en_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -min -add_delay -5.000 [get_ports vga_en_pin]
set_output_delay -clock [get_clocks sys_clk_pin] -max -add_delay 5.000 [get_ports vga_en_pin]

