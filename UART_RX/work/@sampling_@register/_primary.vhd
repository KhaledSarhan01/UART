library verilog;
use verilog.vl_types.all;
entity Sampling_Register is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        BIT_COUNT       : in     vl_logic_vector(3 downto 0);
        sample_one_bit  : in     vl_logic;
        sample_three_bit: in     vl_logic;
        PAR_EN          : in     vl_logic;
        sampled_bit     : in     vl_logic;
        Data_out        : out    vl_logic_vector(7 downto 0);
        start_bit       : out    vl_logic;
        parity_bit      : out    vl_logic;
        stop_bit        : out    vl_logic
    );
end Sampling_Register;
