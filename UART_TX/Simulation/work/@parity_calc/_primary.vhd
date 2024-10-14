library verilog;
use verilog.vl_types.all;
entity Parity_calc is
    generic(
        Width           : integer := 8
    );
    port(
        Data_valid      : in     vl_logic;
        parity_type     : in     vl_logic;
        in_data         : in     vl_logic_vector;
        parity_bit      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Width : constant is 1;
end Parity_calc;
