/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Fri Jul 26 03:36:55 2024
/////////////////////////////////////////////////////////////


module UART_Tx ( CLK, rst, P_data, Data_valid, PAR_TYP, PAR_EN, Tx_out, Busy
 );
  input [7:0] P_data;
  input CLK, rst, Data_valid, PAR_TYP, PAR_EN;
  output Tx_out, Busy;
  wire   Data_serial, Parity_bit, Ser_enable, Ser_done, n2, n3, n4, n5;
  wire   [2:0] Mux_sel;

  serializer ser_block ( .clk(CLK), .rst(rst), .parallel_in(P_data), .ser_en(
        Ser_enable), .data_valid(n4), .serial_out(Data_serial), .ser_done(
        Ser_done) );
  Parity_calc parity_block ( .Data_valid(n4), .parity_type(PAR_TYP), .in_data(
        P_data), .parity_bit(Parity_bit) );
  FSM_controller FSM_control_block ( .clk(CLK), .rst(rst), .Data_valid(n4), 
        .ser_done(Ser_done), .parity_enable(PAR_EN), .ser_en(Ser_enable), 
        .Mux_sel(Mux_sel), .Busy(Busy) );
  OAI2B1X2M U7 ( .A1N(Mux_sel[1]), .A0(Data_serial), .B0(Mux_sel[0]), .Y(n3)
         );
  NAND2X12M U8 ( .A(n2), .B(n3), .Y(Tx_out) );
  AOI31X2M U9 ( .A0(Mux_sel[1]), .A1(n5), .A2(Parity_bit), .B0(Mux_sel[2]), 
        .Y(n2) );
  INVX2M U10 ( .A(Mux_sel[0]), .Y(n5) );
  CLKBUFX16M U11 ( .A(Data_valid), .Y(n4) );
endmodule

