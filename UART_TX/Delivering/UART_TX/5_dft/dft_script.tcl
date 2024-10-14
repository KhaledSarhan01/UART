
########################### Define Top Module ############################
                                                   
set top_module UART_Tx

set_svf UART_Tx_DFT.svf
##################### Define Working Library Directory ######################
                                                   
define_design_lib work -path ./work

################## Design Compiler Library Files #setup ######################

puts "###########################################"
puts "#      #setting Design Libraries           #"
puts "###########################################"

#Add the path of the libraries to the search_path variable
lappend search_path /home/IC/Assignments/UART_TX/std_lib
lappend search_path /home/IC/Assignments/UART_TX/5_dft/DFT_RTL

set SSLIB "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set TTLIB "scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set FFLIB "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"

## Standard Cell libraries 
set target_library [list $SSLIB $TTLIB $FFLIB]

## Standard Cell & Hard Macros libraries 
set link_library [list * $SSLIB $TTLIB $FFLIB]  

######################## Reading RTL Files #################################

puts "###########################################"
puts "#             Reading RTL Files           #"
puts "###########################################"

set file_format verilog

read_file -format $file_format FSM_Controller.v
read_file -format $file_format Parity.v
read_file -format $file_format Serializer.v
read_file -format $file_format Top_Module.v

###################### Defining toplevel ###################################

current_design $top_module

#################### Liniking All The Design Parts #########################
puts "###############################################"
puts "######## Liniking All The Design Parts ########"
puts "###############################################"

link 

#################### Liniking All The Design Parts #########################
puts "###############################################"
puts "######## checking design consistency ##########"
puts "###############################################"

check_design

#################### Define Design Constraints #########################
puts "###############################################"
puts "############ Design Constraints #### ##########"
puts "###############################################"

source -echo ./cons.tcl

#################### Archirecture Scan Chains #########################
puts "###############################################"
puts "############ Configure scan chains ############"
puts "###############################################"

set_scan_configuration -max_length 100 -clock_mixing no_mix -style multiplexed_flip_flop -replace true
###################### Mapping and optimization ########################
puts "###############################################"
puts "########## Mapping & Optimization #############"
puts "###############################################"

compile -scan

################################################################### 
# Setting Test Timing Variables
################################################################### 

# Preclock Measure Protocol (default protocol)
set test_default_period 100
set test_default_delay 0
set test_default_bidir_delay 0
set test_default_strobe 20
set test_default_strobe_width 0

########################## Define DFT Signals ##########################
set_dft_signal -port [get_ports scan_clk]  -type ScanClock   -view existing_dft -timing {30 60}
set_dft_signal -port [get_ports scan_rst]  -type Reset       -view existing_dft -active_state 0
set_dft_signal -port [get_ports testmode] -type Constant    -view existing_dft -active_state 1
set_dft_signal -port [get_ports testmode] -type TestMode    -view spec 	-active_state 1
set_dft_signal -port [get_ports scan_enable] 	   -type ScanEnable  -view spec 	-active_state 1 -usage scan
set_dft_signal -port [get_ports scan_input] 	   -type ScanDataIn  -view spec 	
set_dft_signal -port [get_ports scan_output] 	   -type ScanDataOut -view spec 	

############################# Create Test Protocol #####################
create_test_protocol
                               
###################### Pre-DFT Design Rule Checking ####################
dft_drc -verbose

############################# Preview DFT ##############################
preview_dft -show scan_summary

############################# Insert DFT ###############################
insert_dft

######################## Optimize Logic post DFT #######################
compile -scan -incremental

###################### Design Rule Checking post DFT ###################
dft_drc -verbose -coverage_estimate 

#############################################################################
# Write out Design after initial compile
#############################################################################

#Avoid Writing assign statements in the netlist
change_name -hier -rule verilog
write_file -format verilog -hierarchy -output ALU_dft.v

set_svf -off
####################### reporting ##########################################
cd reports
report_area -hierarchy > area_dft.rpt
report_power -hierarchy > power_dft.rpt
report_timing -delay_type min > hold_dft.rpt
report_timing -delay_type max > setup_dft.rpt
report_clock -attributes > clocks_dft.rpt
report_constraint -all_violators > constraints_dft.rpt
cd ..

################# starting graphical user interface #######################

#gui_start

exit
