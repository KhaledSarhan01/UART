library verilog;
use verilog.vl_types.all;
entity serializer is
    generic(
        Width           : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        parallel_in     : in     vl_logic_vector;
        ser_en          : in     vl_logic;
        data_valid      : in     vl_logic;
        serial_out      : out    vl_logic;
        ser_done        : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
end serializer;
