library verilog;
use verilog.vl_types.all;
entity UART_Rx is
    port(
        CLK             : in     vl_logic;
        RST             : in     vl_logic;
        RX_IN           : in     vl_logic;
        PAR_TYP         : in     vl_logic;
        PAR_EN          : in     vl_logic;
        Prescale        : in     vl_logic_vector(5 downto 0);
        P_DATA          : out    vl_logic_vector(7 downto 0);
        data_valid      : out    vl_logic;
        Parity_Error    : out    vl_logic;
        Stop_Error      : out    vl_logic
    );
end UART_Rx;
