module UART_Tx #(parameter Width = 8)
(
    input wire              CLK,rst,
    input wire [Width-1:0]  P_data,
    input wire              Data_valid,
    input wire              PAR_TYP , PAR_EN ,
    output wire              Tx_out , Busy,
//DFT Signals
    input wire testmode,
    input wire scan_clk,
    input wire scan_rst,
    input wire scan_enable,
    input wire scan_input,
    output wire scan_output
);
//DFT MUXing
wire clk_m ;//=(testmode)? scan_clk:CLK; 
assign clk_m =(testmode)? scan_clk:CLK;

wire rst_m;// =(testmode)? scan_rst:rst;
assign rst_m =(testmode)? scan_rst:rst;

//internal Signals and parameters
    wire Data_serial , Parity_bit;
    wire Ser_done , Ser_enable;
    wire [2:0] Mux_sel;
    localparam Start_bit    = 1'b0 ;
    localparam Stop_bit     = 1'b1 ;
    localparam Idle_bit     = 1'b1 ;

    reg Tx_out_reg;
    assign Tx_out = Tx_out_reg;

//Mux part
always @(*) begin
    case (Mux_sel)
            3'b000: Tx_out_reg = Start_bit;
            3'b001: Tx_out_reg = Stop_bit;
            3'b011: Tx_out_reg = Data_serial;
            3'b010: Tx_out_reg = Parity_bit;
            3'b110: Tx_out_reg = Idle_bit;
        default:   Tx_out_reg = Idle_bit;
    endcase
end

//instantiation of the internal blocks
serializer  #(.Width(Width)) ser_block
(
    .clk(clk_m),
    .rst(rst_m),
    //inputs and outputs
    .parallel_in(P_data),
    .data_valid(Data_valid),
    .serial_out(Data_serial),
    //flages and control
    .ser_en(Ser_enable) , 
    .ser_done(Ser_done) 
);

Parity_calc  #(.Width(Width)) parity_block
(   
   .clk(clk_m),
    .rst(rst_m),	
    //control data
    .Data_valid(Data_valid),
    .parity_type(PAR_TYP),
    //inputs and outputs
    .in_data(P_data),
    .parity_bit(Parity_bit)
);

FSM_controller FSM_control_block
(
    .clk(clk_m),
    .rst(rst_m),
    //inputs
    .Data_valid(Data_valid),
    .ser_done(Ser_done),
    .parity_enable(PAR_EN),
    //outputs
    .ser_en(Ser_enable),
    .Mux_sel(Mux_sel),
    .Busy(Busy)
);
         

endmodule
