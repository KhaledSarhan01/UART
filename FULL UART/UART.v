module UART #(parameter DATA_WIDTH = 8)(
    // Clocks and Active Low Reset
    input wire TX_CLK,RX_CLK,
    input wire UART_RST,

    // External Interface
    input  wire RX_IN,
    output wire TX_OUT,

    // Internal Interface
    input  wire [DATA_WIDTH-1:0] TX_DATA,
    output wire [DATA_WIDTH-1:0] RX_DATA,
    
    // Configuration
    input wire PAR_EN,PAR_TYP,
    input wire [5:0] PRESCALE,

    // TX Controls 
    input  wire TX_DATA_VALID,
    output wire TX_BUSY,
    
    // RX Controls and Configuration
    output wire RX_DATA_VALID,
    output wire RX_PAR_ERROR,
    output wire RX_STOP_ERROR
);

UART_Tx #(.Width(DATA_WIDTH))(
    .clk(TX_CLK), 
    .rst(RX_CLK),
    .Tx_out(TX_OUT),
    .P_data(TX_DATA),
    .PAR_TYP(PAR_TYP), 
    .PAR_EN(PAR_EN),
    .Data_valid(TX_DATA_VALID), 
    .Busy(TX_BUSY)
);

UART_Rx #(.Width(DATA_WIDTH))(
    //clock and active low async reset
    .CLK(RX_CLK),
    .RST(UART_RST),
    //Main input 
    .RX_IN(RX_IN),
    //outputs
    .P_DATA(RX_DATA),

    //configuration inputs
    .PAR_TYP(PAR_TYP),
    .PAR_EN(PAR_EN),
    .Prescale(PRESCALE),
    
    .data_valid(RX_DATA_VALID), 
    .Parity_Error(RX_PAR_ERROR),
    .Stop_Error(RX_STOP_ERROR)
    );

endmodule