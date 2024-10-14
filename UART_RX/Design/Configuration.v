module Configuration_block(
    //clock and active low async reset
    input clk,rst_n,
    // Controller
    input  wire [3:0] block_enable_word,  //represent enable of each block below "4 bits"
    output wire [2:0] error_flag_word,    //represent error flag of each checker "3 bits"
    // Flags and counts    
    output reg BIT_TICK,            //represent Sampling of one bit 
    // sampler control
    output reg sample_one_bit,      //to make sampler samples middle bit only
    output reg sample_three_bit,    //to make sampler samples 3 middle bits by majority
    //output reg middle_bit_sampling,
    // config inputs
    input [1:0] Prescale,            // 4 bit prescale config
    input PAR_TYP,                   // Check type of parity even or odd
    // sampled data 
    input start_bit,
    input parity_bit,
    input stop_bit,
    input [7:0] data_out
);

// enable signal analyze "for easy control"
    wire sampler_enable,start_enable,parity_enable,stop_enable ;
    assign {sampler_enable,start_enable,parity_enable,stop_enable} = block_enable_word;
    //assign {stop_enable,parity_enable,start_enable,sampler_enable} = block_enable_word;
    reg start_error , parity_error , stop_error;
    assign error_flag_word = {start_error , parity_error , stop_error};

// Sampler Control Block
    //Counter Logic
        reg [7:0] Edge_counter;
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                Edge_counter <= 8'b0;
            end else begin
            if(sampler_enable) begin
                case (Prescale)
                    2'b00: // No oversampling  
                    begin
                        if (Edge_counter == 8'd1) begin
                            Edge_counter <= 8'b0;
                        end else begin
                            Edge_counter <= Edge_counter + 1;
                        end
                    end
                    2'b01: // Oversampling by 8  
                    begin
                        if (Edge_counter == 8'd7) begin
                            Edge_counter <= 8'b0;
                        end else begin
                            Edge_counter <= Edge_counter + 1;
                        end
                    end
                    2'b10: // Oversampling by 16 
                    begin
                        if (Edge_counter == 8'd15) begin
                            Edge_counter <= 8'b0;
                        end else begin
                            Edge_counter <= Edge_counter + 1;
                        end
                    end
                    2'b11: // Oversampling by 32  
                    begin
                        if (Edge_counter == 8'd31) begin
                            Edge_counter <= 8'b0;
                        end else begin
                            Edge_counter <= Edge_counter + 1;
                        end
                    end
                    default: begin
                        Edge_counter <= 8'b0;
                    end
                endcase
            end else begin
                Edge_counter <= 8'b0;
            end
            end
        end
    // Next State Transition logic
    always @(*) begin
       case (Prescale)
            2'b00: // No Oversampling
            BIT_TICK = 1'b1;
            2'b01: // Oversampling by 8
            BIT_TICK = (Edge_counter == 8'd7)? 1'b1:1'b0;
            2'b10: // Oversampling by 16
            BIT_TICK = (Edge_counter == 8'd15)? 1'b1:1'b0;
            2'b11: // Oversampling by 32
            BIT_TICK = (Edge_counter == 8'd31)? 1'b1:1'b0;
        default: begin
            BIT_TICK = 1'b1;
        end
       endcase 
    end
    //Middle bit logic 
    always @(*) begin
        case (Prescale)
            2'b00: // No oversampling  
                begin
                    sample_one_bit   = 1'b1;    
                    sample_three_bit = 1'b0;
                end
            
            2'b01: // Oversampling by 8  
                    begin
                        if (Edge_counter == 8'd4) begin
                        sample_one_bit   = 1'b1;    
                        sample_three_bit = 1'b0;
                        end else begin
                        sample_one_bit   = 1'b0;    
                        sample_three_bit = 1'b0;
                        end
                    end
            
            2'b10: // Oversampling by 16 
                    begin
                        if (Edge_counter == 8'd9) begin
                        sample_one_bit   = 1'b0;    
                        sample_three_bit = 1'b1;
                        end else begin
                        sample_one_bit   = 1'b0;    
                        sample_three_bit = 1'b0;
                        end
                    end
            
            2'b11: // Oversampling by 32  
                    begin
                        if (Edge_counter == 8'd16) begin
                        sample_one_bit   = 1'b0;    
                        sample_three_bit = 1'b1;
                        end else begin
                        sample_one_bit   = 1'b0;    
                        sample_three_bit = 1'b0;
                        end
                    end
            default: begin
                sample_one_bit   = 1'b0;    
                sample_three_bit = 1'b0;
            end
        endcase
    end

// Start Checker Block
    always @(*) begin
        if (start_enable) begin
            if (start_bit != 1'b0) begin
                start_error = 1'b1;
            end else begin
                start_error = 1'b0;
            end
        end else begin
            start_error = 1'b0;
        end
    end
    
// Patity Checker Block
    wire obtained_even_parity_bit , obtained_odd_parity_bit ;
    assign obtained_even_parity_bit     = ^(data_out);
    assign obtained_odd_parity_bit      = ~^(data_out);
    
    always @(*) begin
        if(parity_enable)begin
            case (PAR_TYP)
                1'b0: begin //even Parity
                    if (parity_bit != obtained_even_parity_bit) begin
                        parity_error = 1'b1;
                    end else begin
                        parity_error = 1'b0;
                    end
                end
                1'b1: begin //odd Parity
                    if (parity_bit != obtained_odd_parity_bit) begin
                        parity_error = 1'b1;
                    end else begin
                        parity_error = 1'b0;
                    end
                end
                default: begin
                    parity_error = 1'b0;
                end
            endcase
        end else begin
            parity_error = 1'b0;
        end
    end

// Stop Checker Block
    always @(*) begin
        if (stop_enable) begin
            if (stop_bit != 1'b1) begin
                stop_error = 1'b1;
            end else begin
                stop_error = 1'b0;
            end
        end else begin
            stop_error = 1'b0;
        end
    end

endmodule

/*  (3) configuration block
            ## interface ##
            // Controller
                i_block_enable_word
                o_error_flag_word
            // Flags and counts    
                o_edge_conut
                o_BIT_TICK
            // sampler control
                o_sample_one_bit
                o_sample_three_bit    
            // config inputs
                i_Prescale
                i_par_en
                i_par_typ
            // sampled data 
                i_start_bit
                i_parity_bit
                i_stop_bit
                i_data_out

            ## blocks ##
        -----> SAMPLER Extractor Controller
            if(sampler_enable)
            * Extract the bit according to prescale configuration
                - by determining at which edge count will sample and how many bits to sample "1 or 3"
            * produce BIT_TICK that represents Extraction of single bit 
                - This signal can be used to keep track of no of Sampled bits
            * contians Edge_counter that works when sample enabled and produce Bit_TICK when it tries to sample    
         # Port Mapping
            //Extractor control
                o_sample_one_bit
                o_sample_three_bit
            //Counters and Signals         
                o_BIT_TICK
                o_Edge_count 
                i_sampler_enable 
            //configuration
                i_Prescale
                   
        -------> Partiy checker 
            if(parity_checker_enable)
            * generate real_parity_bit from i_data_out
            * obtian   obtained_parity_bit form i_parity_bit
            * compare between them 
         # Port Mapping 
            //Controller
                i_parity_checker_enable
                o_partiy_checker_error
            //Data 
                i_parity_bit
                i_data_out
            //configuration
                i_PAR_TYP    
        -------> start checker
            if(start_checker_enable)
            * check i_start_bit == 0
         # Port Mapping 
            //Controller
                i_start_checker_enable
                o_start_checker_error
            //Data 
                i_start_bit
        -------> stop checker       
            if(stop_checker_enable)
            * check i_stop_bit == 1
         # Port Mapping 
            //Controller
                i_stop_checker_enable
                o_stop_checker_error
            //Data 
                i_stop_bit
*/