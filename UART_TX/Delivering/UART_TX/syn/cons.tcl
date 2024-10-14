####################################################
####### 3- Design Environment Constranits ##########
####################################################
## 1- Port and pin Definition
set input_port_list [list "P_data" "Data_valid" "PAR_TYP" "PAR_EN"]
set output_port_list [list "Tx_out" "Busy"]
set main_clk_port "CLK"
set reset_port  "rst"

## 2- Input Driving Charactristics
set buffer_cell "BUFX2M"
set buffer_cell_library "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c"
set_driving_cell [get_ports $input_port_list] -library $buffer_cell_library -lib_cell $buffer_cell

## 3- Ouptut Driving Charactrestics
set load_cap 0.5
set_load $load_cap [get_ports $output_port_list]

## 4- Operating Conditions
set fast_lib_name "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c"
set slow_lib_name "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c"
set_operating_conditions -min_library $fast_lib_name -min $fast_lib_name -max_library $slow_lib_name -max $slow_lib_name

## 5- Wire load Model
set_wire_load_model -name "tsmc13_wl30" -library $slow_lib_name

####################################################
####### 3- Design Environment Constranits ##########
####################################################

## 1- Master Clock Definitions
set clock_period 8680.6
set clock_name "Main_CLK"
create_clock [get_ports $main_clk_port] -name $clock_name -period $clock_period

## 2- Clock Uncertianity
set setup_skew 0.25
set hold_skew 0.05
set_clock_uncertainty -setup $setup_skew [get_clocks $clock_name] 
set_clock_uncertainty -hold $hold_skew [get_clocks $clock_name] 

## 3- Input Delays
set input_delay [expr $clock_period * 0.3]
set_input_delay $input_delay -clock $clock_name [get_ports $input_port_list]

## 4- Output Delays
set output_delay [expr $clock_period * 0.3]
set_output_delay $output_delay -clock $clock_name [get_ports $output_port_list]

## 5- Clock Transition
set clock_transition 0.1
set_clock_transition $clock_transition [get_clocks $clock_name]  

## 6- Don't Touch 
set_dont_touch_network [list $main_clk_port $reset_port]

