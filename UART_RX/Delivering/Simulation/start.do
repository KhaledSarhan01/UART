vlib work
vlog -f sourcefile.txt
vsim -voptargs=+accs work.tb_UART_Rx
add wave *
run -all