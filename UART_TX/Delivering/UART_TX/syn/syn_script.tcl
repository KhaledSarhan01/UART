########## Defining Top Module ##############
set top_module UART_Tx

cd ../fm
set_svf UART_Tx.svf
cd ../syn

################################################
########## 1-Setting design Library ############
################################################
## Search Path
lappend search_path "/home/IC/Assignments/UART_TX/std_lib"
lappend search_path "/home/IC/Assignments/UART_TX/RTL"

## Library Definitions
set TTLIB "scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"
set SSLIB "scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set FFLIB "scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"

## Target Library and Link Library
set target_library [list $TTLIB $SSLIB $FFLIB]
set link_library [list * $TTLIB $SSLIB $FFLIB]

#################################################
############ 2-Reading RTL Library ##############
#################################################
## Defining important variables
set rtl_list [list FSM_Controller.v Parity.v Serializer.v Top_Module.v]

## Reading and linking the Project 
read_file -format verilog $rtl_list
link
check_design

####################################################
#########  3 & 4-Design Constraints ################
####################################################
current_design $top_module
source -echo ./cons.tcl

################################################
########### 5- Compilation #####################
################################################
compile 

###############################################
########### 6- Reports ########################
###############################################
cd Reports
report_area -hierarchy > area.rpt
report_power -hierarchy > power.rpt
report_timing -max_paths 100 -delay_type min > hold.rpt
report_timing -max_paths 100 -delay_type max > setup.rpt
report_clock -attributes > clocks.rpt
cd ..
report_constraint -all_violators > constraints.rpt

############################################
###### Writing synthesis output files ######
############################################
cd Files
write_file -format verilog -output UART_Tx.v
write_file -format ddc -output UART_Tx.ddc 
write_sdf UART_Tx.sdf
write_sdc UART_Tx.sdc
cd ..

cd ../fm
set_svf -off
cd ../syn

exit
