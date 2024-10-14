library verilog;
use verilog.vl_types.all;
entity FSM_controller is
    generic(
        Idle_state      : vl_logic_vector(2 downto 0) := (Hi0, Hi0, Hi0);
        Start_state     : vl_logic_vector(2 downto 0) := (Hi0, Hi0, Hi1);
        Data_state      : vl_logic_vector(2 downto 0) := (Hi0, Hi1, Hi1);
        Parity_state    : vl_logic_vector(2 downto 0) := (Hi0, Hi1, Hi0);
        Stop_state      : vl_logic_vector(2 downto 0) := (Hi1, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        Data_valid      : in     vl_logic;
        ser_done        : in     vl_logic;
        parity_enable   : in     vl_logic;
        ser_en          : out    vl_logic;
        Mux_sel         : out    vl_logic_vector(2 downto 0);
        Busy            : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Idle_state : constant is 2;
    attribute mti_svvh_generic_type of Start_state : constant is 2;
    attribute mti_svvh_generic_type of Data_state : constant is 2;
    attribute mti_svvh_generic_type of Parity_state : constant is 2;
    attribute mti_svvh_generic_type of Stop_state : constant is 2;
end FSM_controller;
