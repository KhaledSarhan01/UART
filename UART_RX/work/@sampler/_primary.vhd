library verilog;
use verilog.vl_types.all;
entity Sampler is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        Serial_Data_IN  : in     vl_logic;
        Sampled_Bit_OUT : out    vl_logic;
        sample_one_bit  : in     vl_logic;
        sample_three_bit: in     vl_logic;
        sampler_enable  : in     vl_logic;
        start_bit_detector: out    vl_logic
    );
end Sampler;
