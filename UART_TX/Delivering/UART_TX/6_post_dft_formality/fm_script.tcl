
###################################################################
########################### Variables #############################
###################################################################

set SSLIB "/home/IC/Assignments/UART_TX/std_lib/scmetro_tsmc_cl013g_rvt_ss_1p08v_125c.db"
set TTLIB "/home/IC/Assignments/UART_TX/std_lib/scmetro_tsmc_cl013g_rvt_ff_1p32v_m40c.db"
set FFLIB "/home/IC/Assignments/UART_TX/std_lib/scmetro_tsmc_cl013g_rvt_tt_1p2v_25c.db"

###################################################################
############################ Guidance #############################
###################################################################

# Synopsys setup variable
set synopsys_auto_setup true

# Formality Setup File
set_svf "/home/IC/Assignments/UART_TX/6_post_dft_formality/UART_Tx_DFT.svf"
###################################################################
###################### Reference Container ########################
###################################################################

# Read Reference Design Verilog Files
read_verilog -container Ref "/home/IC/Assignments/UART_TX/6_post_dft_formality/DFT_RTL/FSM_Controller.v"
read_verilog -container Ref "/home/IC/Assignments/UART_TX/6_post_dft_formality/DFT_RTL/Parity.v"
read_verilog -container Ref "/home/IC/Assignments/UART_TX/6_post_dft_formality/DFT_RTL/Serializer.v"
read_verilog -container Ref "/home/IC/Assignments/UART_TX/6_post_dft_formality/DFT_RTL/Top_Module.v"

# Read Reference technology libraries
read_db -container Ref [list $SSLIB $TTLIB $FFLIB]
#read_db -container r 
#read_db -container r 

# set the top Reference Design 
set_reference_design UART_Tx
set_top UART_Tx

###################################################################
#################### Implementation Container #####################
###################################################################

# Read Implementation Design Files
read_verilog -netlist -container Imp "/home/IC/Assignments/UART_TX/6_post_dft_formality/DFT_syn/ALU_dft.v"

# Read Implementation technology libraries
read_db -container Imp [list $SSLIB $TTLIB $FFLIB]

# set the top Implementation Design
set_implementation_design UART_Tx
set_top UART_Tx


###################### Matching Compare points ####################
match


######################### Run Verification ########################

set successful [verify]
if {!$successful} {
diagnose
analyze_points -failing
}

########################### Reporting ############################# 
cd reports
report_passing_points > "passing_points.rpt"
report_failing_points > "failing_points.rpt"
report_aborted_points > "aborted_points.rpt"
report_unverified_points > "unverified_points.rpt"
cd ..

start_gui
#exit

