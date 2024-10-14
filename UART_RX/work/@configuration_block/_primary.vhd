library verilog;
use verilog.vl_types.all;
entity Configuration_block is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        block_enable_word: in     vl_logic_vector(3 downto 0);
        error_flag_word : out    vl_logic_vector(2 downto 0);
        BIT_TICK        : out    vl_logic;
        sample_one_bit  : out    vl_logic;
        sample_three_bit: out    vl_logic;
        Prescale        : in     vl_logic_vector(1 downto 0);
        PAR_TYP         : in     vl_logic;
        start_bit       : in     vl_logic;
        parity_bit      : in     vl_logic;
        stop_bit        : in     vl_logic;
        data_out        : in     vl_logic_vector(7 downto 0)
    );
end Configuration_block;
