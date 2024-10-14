
####################################################################################
# Constraints
# ----------------------------------------------------------------------------
#
# 0. Design Compiler variables
#
# 1. Master Clock Definitions
#
# 2. Generated Clock Definitions
#
# 3. Clock Uncertainties
#
# 4. Clock Latencies 
#
# 5. Clock Relationships
#
# 6. #set input/output delay on ports
#
# 7. Driving cells
#
# 8. Output load

####################################################################################
           #########################################################
                  #### Section 0 : DC Variables ####
           #########################################################
#################################################################################### 

# Prevent assign statements in the generated netlist (must be applied before compile command)
set_fix_multiple_port_nets -all -buffer_constants -feedthroughs

#################################################################################### 
           #########################################################
                  #### Section 1 : Clock Definition ####
           #########################################################
#################################################################################### 
# 1. Master Clock Definitions 
# 2. Generated Clock Definitions
# 3. Clock Latencies
# 4. Clock Uncertainties
# 4. Clock Transitions
####################################################################################

## Main Clock
set CLK_NAME CLK
set CLK_PER 8680.6
set CLK_SETUP_SKEW 0.25
set CLK_HOLD_SKEW 0.25
set CLK_LAT 0
set CLK_RISE 0.1
set CLK_FALL 0.1

create_clock -name $CLK_NAME -period $CLK_PER -waveform "0 [expr $CLK_PER/2]" [get_ports CLK]
set_clock_uncertainty -setup $CLK_SETUP_SKEW [get_clocks $CLK_NAME]
set_clock_uncertainty -hold $CLK_HOLD_SKEW  [get_clocks $CLK_NAME]
set_clock_transition -rise $CLK_RISE  [get_clocks $CLK_NAME]
set_clock_transition -fall $CLK_FALL  [get_clocks $CLK_NAME]
set_clock_latency $CLK_LAT [get_clocks $CLK_NAME]
set_dont_touch_network "$CLK_NAME"

## Scan Clock
set SCAN_CLK_NAME "SCAN_CLK"
set SCAN_CLK_PER 10000
set SCAN_CLK_SETUP_SKEW 0.025
set SCAN_CLK_HOLD_SKEW 0.01
set SCAN_CLK_LAT 0
set SCAN_CLK_RISE 0
set SCAN_CLK_FALL 0

create_clock -name $SCAN_CLK_NAME -period $SCAN_CLK_PER [get_ports scan_clk]
set_clock_uncertainty -setup $SCAN_CLK_SETUP_SKEW [get_clocks $SCAN_CLK_NAME]
set_clock_uncertainty -hold $SCAN_CLK_HOLD_SKEW  [get_clocks $SCAN_CLK_NAME]
set_clock_transition -rise $SCAN_CLK_RISE  [get_clocks $SCAN_CLK_NAME]
set_clock_transition -fall $SCAN_CLK_FALL  [get_clocks $SCAN_CLK_NAME]
set_clock_latency $SCAN_CLK_LAT [get_clocks $SCAN_CLK_NAME]

set_dont_touch_network "$SCAN_CLK_NAME"

####################################################################################
           #########################################################
                  #### Section 2 : Clocks Relationships ####
           #########################################################
####################################################################################


####################################################################################
           #########################################################
             #### Section 3 : #set input/output delay on ports ####
           #########################################################
####################################################################################

set in_delay  [expr 0.3*$CLK_PER]
set out_delay [expr 0.3*$CLK_PER]

#Constrain Input Paths
set input_src_list [list "P_data" "Data_valid" "PAR_TYP"  "PAR_EN"]
set_input_delay $in_delay -clock $CLK_NAME [get_port $input_src_list]

#Constrain Scan Input Paths
set scanIN_src_list [list "testmode" "scan_clk" "scan_rst" "scan_input" "scan_enable"]
set_input_delay $in_delay -clock $SCAN_CLK_NAME [get_port $scanIN_src_list]


#Constrain Output Paths
set output_src_list [list "Tx_out" "Busy"]
set_output_delay $out_delay -clock $CLK_NAME [get_port $output_src_list]

#Constrain Scan Output Paths
set scanOUT_src_list "scan_output"
set_output_delay $out_delay -clock $SCAN_CLK_NAME [get_port $scanOUT_src_list]

####################################################################################
           #########################################################
                  #### Section 4 : Driving cells ####
           #########################################################
####################################################################################

#functional ports
set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port CLK]
set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_port rst]
set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_ports $input_src_list]

#scan ports
set_driving_cell -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c -lib_cell BUFX2M -pin Y [get_ports $scanIN_src_list]

####################################################################################
           #########################################################
                  #### Section 5 : Output load ####
           #########################################################
####################################################################################

#functional ports
set_load 0.1  [get_ports $output_src_list]

#scan ports
set_load 0.1  [get_ports $scanOUT_src_list]

####################################################################################
           #########################################################
                 #### Section 6 : Operating Condition ####
           #########################################################
####################################################################################

# Define the Worst Library for Max(#setup) analysis
# Define the Best Library for Min(hold) analysis

set_operating_conditions -min_library "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c" -min "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c" -max_library "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c" -max "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c"

####################################################################################
           #########################################################
                  #### Section 7 : wireload Model ####
           #########################################################
####################################################################################

#set_wire_load_model -name tsmc13_wl30 -library scmetro_tsmc_cl013g_rvt_ss_1p08v_125c

####################################################################################
           #########################################################
                  #### Section 8 : Case Analysis ####
           #########################################################
####################################################################################
set_clock_groups -asynchronous -group [get_clocks $CLK_NAME] -group [get_clocks $SCAN_CLK_NAME]

####################################################################################

