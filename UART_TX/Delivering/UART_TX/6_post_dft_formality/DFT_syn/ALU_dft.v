/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : K-2015.06
// Date      : Fri Aug  2 05:56:37 2024
/////////////////////////////////////////////////////////////


module serializer_DW01_inc_0 ( A, SUM );
  input [7:0] A;
  output [7:0] SUM;

  wire   [7:2] carry;

  ADDHX1M U1_1_6 ( .A(A[6]), .B(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  ADDHX1M U1_1_3 ( .A(A[3]), .B(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  ADDHX1M U1_1_2 ( .A(A[2]), .B(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  ADDHX1M U1_1_1 ( .A(A[1]), .B(A[0]), .CO(carry[2]), .S(SUM[1]) );
  ADDHX1M U1_1_4 ( .A(A[4]), .B(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  ADDHX1M U1_1_5 ( .A(A[5]), .B(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  CLKXOR2X2M U1 ( .A(carry[7]), .B(A[7]), .Y(SUM[7]) );
  CLKINVX1M U2 ( .A(A[0]), .Y(SUM[0]) );
endmodule


module serializer_test_1 ( clk, rst, parallel_in, ser_en, data_valid, 
        serial_out, ser_done, test_si, test_se );
  input [7:0] parallel_in;
  input clk, rst, ser_en, data_valid, test_si, test_se;
  output serial_out, ser_done;
  wire   N8, N9, N10, N11, N12, N13, N14, N15, n20, n21, n22, n23, n24, n25,
         n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36, n37, n38, n39,
         n40, n41, n42, n43, n44, n45, n46, n47, n48, n18;
  wire   [7:0] Counter;
  wire   [7:0] data_reg;

  SDFFRQX2M data_reg_reg_6_ ( .D(n34), .SI(data_reg[5]), .SE(test_se), .CK(clk), .RN(rst), .Q(data_reg[6]) );
  SDFFRQX2M data_reg_reg_5_ ( .D(n35), .SI(data_reg[4]), .SE(test_se), .CK(clk), .RN(rst), .Q(data_reg[5]) );
  SDFFRQX2M data_reg_reg_4_ ( .D(n36), .SI(data_reg[3]), .SE(test_se), .CK(clk), .RN(rst), .Q(data_reg[4]) );
  SDFFRQX2M data_reg_reg_3_ ( .D(n37), .SI(data_reg[2]), .SE(test_se), .CK(clk), .RN(rst), .Q(data_reg[3]) );
  SDFFRQX2M data_reg_reg_2_ ( .D(n38), .SI(data_reg[1]), .SE(test_se), .CK(clk), .RN(rst), .Q(data_reg[2]) );
  SDFFRQX2M data_reg_reg_1_ ( .D(n39), .SI(data_reg[0]), .SE(test_se), .CK(clk), .RN(rst), .Q(data_reg[1]) );
  SDFFRQX2M data_reg_reg_0_ ( .D(n40), .SI(Counter[7]), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(data_reg[0]) );
  SDFFRQX2M data_reg_reg_7_ ( .D(n33), .SI(data_reg[6]), .SE(test_se), .CK(clk), .RN(rst), .Q(data_reg[7]) );
  SDFFRQX2M Counter_reg_0_ ( .D(n48), .SI(test_si), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(Counter[0]) );
  SDFFRQX2M Counter_reg_7_ ( .D(n47), .SI(Counter[6]), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(Counter[7]) );
  SDFFRQX2M Counter_reg_3_ ( .D(n44), .SI(Counter[2]), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(Counter[3]) );
  SDFFRQX2M Counter_reg_1_ ( .D(n46), .SI(Counter[0]), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(Counter[1]) );
  SDFFRQX2M Counter_reg_2_ ( .D(n45), .SI(Counter[1]), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(Counter[2]) );
  SDFFRQX2M Counter_reg_6_ ( .D(n41), .SI(Counter[5]), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(Counter[6]) );
  SDFFRQX2M Counter_reg_4_ ( .D(n43), .SI(Counter[3]), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(Counter[4]) );
  SDFFRQX2M Counter_reg_5_ ( .D(n42), .SI(Counter[4]), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(Counter[5]) );
  SDFFRQX2M serial_out_reg ( .D(n32), .SI(data_reg[7]), .SE(test_se), .CK(clk), 
        .RN(rst), .Q(serial_out) );
  AND2X2M U20 ( .A(ser_en), .B(n29), .Y(n18) );
  NOR2X2M U21 ( .A(n21), .B(n18), .Y(n20) );
  NOR2BX2M U22 ( .AN(data_valid), .B(ser_en), .Y(n21) );
  OAI2BB1X2M U23 ( .A0N(data_reg[0]), .A1N(n20), .B0(n28), .Y(n40) );
  AOI22X1M U24 ( .A0(parallel_in[0]), .A1(n21), .B0(data_reg[1]), .B1(n18), 
        .Y(n28) );
  OAI2BB1X2M U25 ( .A0N(n20), .A1N(data_reg[1]), .B0(n27), .Y(n39) );
  AOI22X1M U26 ( .A0(parallel_in[1]), .A1(n21), .B0(data_reg[2]), .B1(n18), 
        .Y(n27) );
  OAI2BB1X2M U27 ( .A0N(n20), .A1N(data_reg[2]), .B0(n26), .Y(n38) );
  AOI22X1M U28 ( .A0(parallel_in[2]), .A1(n21), .B0(data_reg[3]), .B1(n18), 
        .Y(n26) );
  OAI2BB1X2M U29 ( .A0N(n20), .A1N(data_reg[3]), .B0(n25), .Y(n37) );
  AOI22X1M U30 ( .A0(parallel_in[3]), .A1(n21), .B0(data_reg[4]), .B1(n18), 
        .Y(n25) );
  OAI2BB1X2M U31 ( .A0N(n20), .A1N(data_reg[4]), .B0(n24), .Y(n36) );
  AOI22X1M U32 ( .A0(parallel_in[4]), .A1(n21), .B0(data_reg[5]), .B1(n18), 
        .Y(n24) );
  OAI2BB1X2M U33 ( .A0N(n20), .A1N(data_reg[5]), .B0(n23), .Y(n35) );
  AOI22X1M U34 ( .A0(parallel_in[5]), .A1(n21), .B0(data_reg[6]), .B1(n18), 
        .Y(n23) );
  OAI2BB1X2M U35 ( .A0N(n20), .A1N(data_reg[6]), .B0(n22), .Y(n34) );
  AOI22X1M U36 ( .A0(parallel_in[6]), .A1(n21), .B0(data_reg[7]), .B1(n18), 
        .Y(n22) );
  AO22X1M U37 ( .A0(n20), .A1(data_reg[7]), .B0(parallel_in[7]), .B1(n21), .Y(
        n33) );
  AO22X1M U38 ( .A0(n20), .A1(Counter[0]), .B0(N8), .B1(n18), .Y(n48) );
  AO22X1M U39 ( .A0(n18), .A1(data_reg[0]), .B0(serial_out), .B1(n20), .Y(n32)
         );
  AO22X1M U40 ( .A0(Counter[3]), .A1(n20), .B0(N11), .B1(n18), .Y(n44) );
  AO22X1M U41 ( .A0(n20), .A1(Counter[7]), .B0(N15), .B1(n18), .Y(n47) );
  AO22X1M U42 ( .A0(n20), .A1(Counter[6]), .B0(N14), .B1(n18), .Y(n41) );
  AO22X1M U43 ( .A0(n20), .A1(Counter[5]), .B0(N13), .B1(n18), .Y(n42) );
  AO22X1M U44 ( .A0(n20), .A1(Counter[4]), .B0(N12), .B1(n18), .Y(n43) );
  AO22X1M U45 ( .A0(n20), .A1(Counter[2]), .B0(N10), .B1(n18), .Y(n45) );
  AO22X1M U46 ( .A0(n20), .A1(Counter[1]), .B0(N9), .B1(n18), .Y(n46) );
  NAND4BX1M U47 ( .AN(Counter[0]), .B(Counter[3]), .C(n30), .D(n31), .Y(n29)
         );
  NOR2X2M U48 ( .A(Counter[2]), .B(Counter[1]), .Y(n30) );
  NOR4X1M U49 ( .A(Counter[7]), .B(Counter[6]), .C(Counter[5]), .D(Counter[4]), 
        .Y(n31) );
  INVX2M U50 ( .A(n29), .Y(ser_done) );
  serializer_DW01_inc_0 add_31 ( .A(Counter), .SUM({N15, N14, N13, N12, N11, 
        N10, N9, N8}) );
endmodule


module Parity_calc_test_1 ( clk, rst, Data_valid, parity_type, in_data, 
        parity_bit, test_si, test_so, test_se );
  input [7:0] in_data;
  input clk, rst, Data_valid, parity_type, test_si, test_se;
  output parity_bit, test_so;
  wire   internal_reg_6_, internal_reg_5_, internal_reg_4_, internal_reg_3_,
         internal_reg_2_, internal_reg_1_, internal_reg_0_, n9, n10, n11, n12;

  SDFFRQX2M internal_reg_reg_5_ ( .D(in_data[5]), .SI(internal_reg_4_), .SE(
        test_se), .CK(clk), .RN(rst), .Q(internal_reg_5_) );
  SDFFRQX2M internal_reg_reg_1_ ( .D(in_data[1]), .SI(internal_reg_0_), .SE(
        test_se), .CK(clk), .RN(rst), .Q(internal_reg_1_) );
  SDFFRQX2M internal_reg_reg_4_ ( .D(in_data[4]), .SI(internal_reg_3_), .SE(
        test_se), .CK(clk), .RN(rst), .Q(internal_reg_4_) );
  SDFFRQX2M internal_reg_reg_0_ ( .D(in_data[0]), .SI(test_si), .SE(test_se), 
        .CK(clk), .RN(rst), .Q(internal_reg_0_) );
  SDFFRQX2M internal_reg_reg_3_ ( .D(in_data[3]), .SI(internal_reg_2_), .SE(
        test_se), .CK(clk), .RN(rst), .Q(internal_reg_3_) );
  SDFFRQX2M internal_reg_reg_6_ ( .D(in_data[6]), .SI(internal_reg_5_), .SE(
        test_se), .CK(clk), .RN(rst), .Q(internal_reg_6_) );
  SDFFRQX2M internal_reg_reg_2_ ( .D(in_data[2]), .SI(internal_reg_1_), .SE(
        test_se), .CK(clk), .RN(rst), .Q(internal_reg_2_) );
  SDFFRQX1M internal_reg_reg_7_ ( .D(in_data[7]), .SI(internal_reg_6_), .SE(
        test_se), .CK(clk), .RN(rst), .Q(test_so) );
  XOR3XLM U12 ( .A(parity_type), .B(n9), .C(n10), .Y(parity_bit) );
  XOR3XLM U13 ( .A(internal_reg_1_), .B(internal_reg_0_), .C(n11), .Y(n10) );
  XOR3XLM U14 ( .A(internal_reg_5_), .B(internal_reg_4_), .C(n12), .Y(n9) );
  XNOR2X2M U15 ( .A(internal_reg_3_), .B(internal_reg_2_), .Y(n11) );
  XNOR2X2M U16 ( .A(test_so), .B(internal_reg_6_), .Y(n12) );
endmodule


module FSM_controller_test_1 ( clk, rst, Data_valid, ser_done, parity_enable, 
        ser_en, Mux_sel, Busy, test_si, test_so, test_se );
  output [2:0] Mux_sel;
  input clk, rst, Data_valid, ser_done, parity_enable, test_si, test_se;
  output ser_en, Busy, test_so;
  wire   n10, n11, n12, n13, n14, n15, n16, n17, n6, n7, n8, n9, n19;
  wire   [2:0] current_state;
  wire   [2:1] next_state;

  SDFFRQX2M current_state_reg_0_ ( .D(n8), .SI(test_si), .SE(test_se), .CK(clk), .RN(rst), .Q(current_state[0]) );
  SDFFSX1M current_state_reg_2_ ( .D(next_state[2]), .SI(n19), .SE(test_se), 
        .CK(clk), .SN(rst), .Q(current_state[2]), .QN(test_so) );
  SDFFRX1M current_state_reg_1_ ( .D(next_state[1]), .SI(current_state[0]), 
        .SE(test_se), .CK(clk), .RN(rst), .Q(current_state[1]), .QN(n19) );
  OAI21X2M U8 ( .A0(n14), .A1(n7), .B0(n16), .Y(ser_en) );
  NAND2X2M U9 ( .A(n19), .B(test_so), .Y(n14) );
  NAND2X2M U10 ( .A(n16), .B(n17), .Y(Mux_sel[0]) );
  NAND2BX2M U11 ( .AN(n10), .B(n11), .Y(next_state[2]) );
  OAI211X2M U12 ( .A0(current_state[2]), .A1(current_state[0]), .B0(n16), .C0(
        n11), .Y(Mux_sel[1]) );
  OAI211X4M U13 ( .A0(current_state[2]), .A1(n19), .B0(n17), .C0(n6), .Y(Busy)
         );
  INVX2M U14 ( .A(ser_en), .Y(n6) );
  AOI22X1M U15 ( .A0(current_state[0]), .A1(current_state[2]), .B0(n7), .B1(
        current_state[1]), .Y(n11) );
  OAI22X1M U16 ( .A0(current_state[0]), .A1(n14), .B0(n15), .B1(test_so), .Y(
        Mux_sel[2]) );
  NOR2X2M U17 ( .A(current_state[0]), .B(current_state[1]), .Y(n15) );
  NAND3X2M U18 ( .A(current_state[0]), .B(test_so), .C(current_state[1]), .Y(
        n16) );
  NAND3X2M U19 ( .A(n7), .B(n19), .C(current_state[2]), .Y(n17) );
  INVX2M U20 ( .A(current_state[0]), .Y(n7) );
  NOR3X2M U21 ( .A(n7), .B(current_state[2]), .C(n10), .Y(next_state[1]) );
  NOR2X2M U22 ( .A(parity_enable), .B(n12), .Y(n10) );
  INVX2M U23 ( .A(n13), .Y(n8) );
  AOI32X1M U24 ( .A0(n12), .A1(test_so), .A2(current_state[0]), .B0(Data_valid), .B1(n9), .Y(n13) );
  INVX2M U25 ( .A(n14), .Y(n9) );
  NAND2X2M U26 ( .A(ser_done), .B(current_state[1]), .Y(n12) );
endmodule


module UART_Tx ( CLK, rst, P_data, Data_valid, PAR_TYP, PAR_EN, Tx_out, Busy, 
        testmode, scan_clk, scan_rst, scan_enable, scan_input, scan_output );
  input [7:0] P_data;
  input CLK, rst, Data_valid, PAR_TYP, PAR_EN, testmode, scan_clk, scan_rst,
         scan_enable, scan_input;
  output Tx_out, Busy, scan_output;
  wire   clk_m, rst_m, Parity_bit, Ser_enable, Ser_done, n2, n3, n4, n6, n7;
  wire   [2:0] Mux_sel;

  INVX2M U9 ( .A(Mux_sel[0]), .Y(n4) );
  NAND2X2M U10 ( .A(n2), .B(n3), .Y(Tx_out) );
  OAI2B1X2M U11 ( .A1N(Mux_sel[1]), .A0(scan_output), .B0(Mux_sel[0]), .Y(n3)
         );
  AOI31X2M U12 ( .A0(Mux_sel[1]), .A1(n4), .A2(Parity_bit), .B0(Mux_sel[2]), 
        .Y(n2) );
  MX2X2M U13 ( .A(rst), .B(scan_rst), .S0(testmode), .Y(rst_m) );
  MX2X2M U14 ( .A(CLK), .B(scan_clk), .S0(testmode), .Y(clk_m) );
  serializer_test_1 ser_block ( .clk(clk_m), .rst(rst_m), .parallel_in(P_data), 
        .ser_en(Ser_enable), .data_valid(Data_valid), .serial_out(scan_output), 
        .ser_done(Ser_done), .test_si(n6), .test_se(scan_enable) );
  Parity_calc_test_1 parity_block ( .clk(clk_m), .rst(rst_m), .Data_valid(
        Data_valid), .parity_type(PAR_TYP), .in_data(P_data), .parity_bit(
        Parity_bit), .test_si(n7), .test_so(n6), .test_se(scan_enable) );
  FSM_controller_test_1 FSM_control_block ( .clk(clk_m), .rst(rst_m), 
        .Data_valid(Data_valid), .ser_done(Ser_done), .parity_enable(PAR_EN), 
        .ser_en(Ser_enable), .Mux_sel(Mux_sel), .Busy(Busy), .test_si(
        scan_input), .test_so(n7), .test_se(scan_enable) );
endmodule

