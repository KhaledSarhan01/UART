library verilog;
use verilog.vl_types.all;
entity UART_Tx is
    generic(
        Width           : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        P_data          : in     vl_logic_vector;
        Data_valid      : in     vl_logic;
        PAR_TYP         : in     vl_logic;
        PAR_EN          : in     vl_logic;
        Tx_out          : out    vl_logic;
        Busy            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
end UART_Tx;
