library verilog;
use verilog.vl_types.all;
entity tb_UART_Rx is
    generic(
        RX_Clock_Period : real    := 542.600000;
        prescale_value  : vl_logic_vector(7 downto 0) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of RX_Clock_Period : constant is 1;
    attribute mti_svvh_generic_type of prescale_value : constant is 2;
end tb_UART_Rx;
