library verilog;
use verilog.vl_types.all;
entity UART_Rx_Controller is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        PAR_EN          : in     vl_logic;
        Data_valid      : out    vl_logic;
        block_enable_word: out    vl_logic_vector(3 downto 0);
        error_flag_word : in     vl_logic_vector(2 downto 0);
        BIT_TICK        : in     vl_logic;
        BIT_COUNT       : out    vl_logic_vector(3 downto 0);
        start_bit_detector: in     vl_logic
    );
end UART_Rx_Controller;
