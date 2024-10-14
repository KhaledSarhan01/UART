###################################################################

# Created by write_sdc on Fri Jul 26 03:36:55 2024

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max scmetro_tsmc_cl013g_rvt_ss_1p08v_125c            \
-max_library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c\
                         -min scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c            \
-min_library scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c
set_wire_load_model -name tsmc13_wl30 -library                                 \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports {P_data[7]}]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports {P_data[6]}]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports {P_data[5]}]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports {P_data[4]}]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports {P_data[3]}]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports {P_data[2]}]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports {P_data[1]}]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports {P_data[0]}]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports Data_valid]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports PAR_TYP]
set_driving_cell -lib_cell BUFX2M -library                                     \
scmetro_tsmc_cl013g_rvt_ss_1p08v_125c [get_ports PAR_EN]
set_load -pin_load 0.5 [get_ports Tx_out]
set_load -pin_load 0.5 [get_ports Busy]
create_clock [get_ports CLK]  -name Main_CLK  -period 8680.6  -waveform {0 4340.3}
set_clock_uncertainty -setup 0.25  [get_clocks Main_CLK]
set_clock_uncertainty -hold 0.05  [get_clocks Main_CLK]
set_clock_transition -max -rise 0.1 [get_clocks Main_CLK]
set_clock_transition -max -fall 0.1 [get_clocks Main_CLK]
set_clock_transition -min -rise 0.1 [get_clocks Main_CLK]
set_clock_transition -min -fall 0.1 [get_clocks Main_CLK]
set_input_delay -clock Main_CLK  2604.18  [get_ports {P_data[7]}]
set_input_delay -clock Main_CLK  2604.18  [get_ports {P_data[6]}]
set_input_delay -clock Main_CLK  2604.18  [get_ports {P_data[5]}]
set_input_delay -clock Main_CLK  2604.18  [get_ports {P_data[4]}]
set_input_delay -clock Main_CLK  2604.18  [get_ports {P_data[3]}]
set_input_delay -clock Main_CLK  2604.18  [get_ports {P_data[2]}]
set_input_delay -clock Main_CLK  2604.18  [get_ports {P_data[1]}]
set_input_delay -clock Main_CLK  2604.18  [get_ports {P_data[0]}]
set_input_delay -clock Main_CLK  2604.18  [get_ports Data_valid]
set_input_delay -clock Main_CLK  2604.18  [get_ports PAR_TYP]
set_input_delay -clock Main_CLK  2604.18  [get_ports PAR_EN]
set_output_delay -clock Main_CLK  2604.18  [get_ports Tx_out]
set_output_delay -clock Main_CLK  2604.18  [get_ports Busy]
