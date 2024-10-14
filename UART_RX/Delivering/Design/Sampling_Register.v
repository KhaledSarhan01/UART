module Sampling_Register(
    // clock and active low async reset
    input clk,rst_n,
    //control inputs
    input [3:0] BIT_COUNT,
    input sample_one_bit,sample_three_bit,
    input PAR_EN,
    input Data_valid,
    // Datapath Input
    input sampled_bit,
    // Datapath Output 
    output  wire [7:0] Data_out,
    output  wire start_bit,
    output  wire parity_bit,
    output  wire stop_bit
);
/*
2) SAMPLED DATA REGISTER "Deserializer"
           Function 
            * Store Sampled data from sampler according to their BIT_COUNT
            * Provide all data for Configuration block 
                - start_bit for Start_Checker
                - Data for P_Data output and Parity_Checker
                - parity_bit for Parity_Checker
                - stop_bit for Stop_Checker  
*/    
// Sampled Data Register "11 bit"
    reg [10:0] sampled_data_register;

// putting the sampled bit in register
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)begin
            sampled_data_register <= 10'b0;
        end else begin
            if (sample_one_bit || sample_three_bit) begin
                sampled_data_register[BIT_COUNT] <= sampled_bit;
            end
        end
    end
// getting the output from data
    assign start_bit    = sampled_data_register[0];
    assign Data_out     = (Data_valid)? sampled_data_register[8:1]:8'b0;
    assign parity_bit   = (PAR_EN)? sampled_data_register[9]:1'b0;
    assign stop_bit     = (PAR_EN)? sampled_data_register[10]:sampled_data_register[9];
endmodule