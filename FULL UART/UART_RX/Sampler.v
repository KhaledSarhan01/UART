module Sampler (
    //clock and active low async reset 
    input clk ,rst_n,
    //Datapath inputs / outputs
    input Serial_Data_IN,
    output reg Sampled_Bit_OUT,
    //Extractor control
    input sample_one_bit,
    input sample_three_bit,
    //input middle_bit_sampling,
    //input BIT_TICK,
    //Controller interface
    input sampler_enable,           
    output wire start_bit_detector
);
// Data storage and logic
    reg [2:0] Data_Storage;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            Data_Storage <= 3'b111;
        end else begin
            if (sampler_enable) begin
                Data_Storage[0] <= Serial_Data_IN;
                Data_Storage[1] <= Data_Storage[0];
                Data_Storage[2] <= Data_Storage[1];
            end
        end
    end

// Sampled Data out
    always @(*) begin
        if (sample_one_bit) begin
            // Middle Bit
            Sampled_Bit_OUT = Data_Storage[1]; 
        end else if (sample_three_bit) begin
            // logic is        
            Sampled_Bit_OUT = (~Data_Storage[0] & Data_Storage[1] & Data_Storage[2])||(Data_Storage[0] |Data_Storage[1] | Data_Storage[2]);
        end else begin
            Sampled_Bit_OUT = 1'b0 ;
        end
    end

// Detector logic
    assign start_bit_detector = ~(Serial_Data_IN);

endmodule


/*
(1) SAMPLER
         Function:
            * Enable the Controller when any data enters = 0 "Start Bit"
                - send enable signal to Controller module
            * send Sampled bit to Sampled Data Register 
                - it's decoder with 11 bit register where sampled data is stored  

    ----------------------------------------------------------------------------
    Data_storage[0] | Data_storage[1] | Data_storage[2] | sampled_bit_out_three 
    ----------------------------------------------------------------------------
        0           |       0         |        0        |           0
        0           |       0         |        1        |           0
        0           |       1         |        0        |           0
        0           |       1         |        1        |           1
        1           |       0         |        0        |           0
        1           |       0         |        1        |           1
        1           |       1         |        0        |           1
        1           |       1         |        1        |           1           
    -----------------------------------------------------------------------------
    sampled_bit_out  = (~DS_0 & (DS_1 & DS_2)) || (DS_0 &(DS_1||DS_2)) 



         Port Mapping 
            //Datapath inputs / outputs
                i_Serial_Data_IN
                o_Sampled_Bit_OUT
            //Extractor control
                i_sample_one_bit
                i_sample_three_bit
            //Controller interface
                i_Sampler_enable
                o_Start_bit_detector
*/    