vlib work
vlog -f sourcefile.txt
vsim -voptargs=+accs work.tb_UART_Rx
add wave -position insertpoint  \
sim:/tb_UART_Rx/tb_Stop_Error \
sim:/tb_UART_Rx/tb_RX_IN \
sim:/tb_UART_Rx/tb_RST \
sim:/tb_UART_Rx/tb_Prescale \
sim:/tb_UART_Rx/tb_Parity_Error \
sim:/tb_UART_Rx/tb_P_DATA \
sim:/tb_UART_Rx/tb_PAR_TYP \
sim:/tb_UART_Rx/tb_PAR_EN \
sim:/tb_UART_Rx/tb_Data_valid \
sim:/tb_UART_Rx/TX_CLK \
sim:/tb_UART_Rx/RX_CLK
add wave -position insertpoint  \
sim:/tb_UART_Rx/DUT/UART_FSM_Controller/current_state \
sim:/tb_UART_Rx/DUT/UART_FSM_Controller/BIT_COUNT
add wave -position insertpoint  \
sim:/tb_UART_Rx/DUT/UART_Sampler/Sampled_Bit_OUT
add wave -position insertpoint  \
sim:/tb_UART_Rx/DUT/UART_Config_block/error_flag_word \
sim:/tb_UART_Rx/DUT/UART_Config_block/block_enable_word \
sim:/tb_UART_Rx/DUT/UART_Config_block/Edge_counter \
sim:/tb_UART_Rx/DUT/UART_Config_block/BIT_TICK
add wave -position insertpoint  \
sim:/tb_UART_Rx/DUT/UART_Sampling_Register/sampled_data_register
run -all
