module UART_Rx(
    //clock and active low async reset
    input wire CLK,RST,
    //Main input 
    input wire RX_IN,
    //configuration inputs
    input wire PAR_TYP,PAR_EN,
    input wire [5:0] Prescale,
    //outputs
    output wire [7:0] P_DATA,
    output wire data_valid, 
    output wire Parity_Error,
    output wire Stop_Error
);

// Sampled BIT Counter Signals
    wire [3:0] BIT_COUNT_UART_Rx;
    wire Bit_TICK_UART_Rx;

// Datapath
    wire sampled_bit_UART_Rx;
    wire [7:0] Data_out_UART_Rx;
    wire start_bit_UART_Rx;
    wire parity_bit_UART_Rx;
    wire stop_bit_UART_Rx;

// Controller Signals    
    wire [3:0] block_enable_word_UART_Rx;  
    wire [2:0] error_flag_word_UART_Rx;
    reg [1:0] Prescale_Select;

// sampler control
    wire sample_one_bit_UART_Rx;      //to make sampler samples middle bit only
    wire sample_three_bit_UART_Rx;    //to make sampler samples 3 middle bits by majority
    wire start_bit_detector_UART_Rx;
    //wire middle_bit_sampling_UART_Rx;


Sampling_Register UART_Sampling_Register(
    // clock and active low async reset
    .clk(CLK),.rst_n(RST),
    //control inputs
    .BIT_COUNT(BIT_COUNT_UART_Rx),
    .sample_one_bit(sample_one_bit_UART_Rx),
    .sample_three_bit(sample_three_bit_UART_Rx),
    .PAR_EN(PAR_EN),
    .Data_valid(data_valid),
    // Datapath Input
    .sampled_bit(sampled_bit_UART_Rx),
    // Datapath Output 
    .Data_out(Data_out_UART_Rx),
    .start_bit(start_bit_UART_Rx),
    .parity_bit(parity_bit_UART_Rx),
    .stop_bit(stop_bit_UART_Rx)
);

Configuration_block UART_Config_block(
    //clock and active low async reset
    .clk(CLK),.rst_n(RST),
    // Controller
    .block_enable_word(block_enable_word_UART_Rx),  //represent enable of each block below "4 bits"
    .error_flag_word(error_flag_word_UART_Rx),    //represent error flag of each checker "3 bits"
    // Flags and counts    
    .BIT_TICK(Bit_TICK_UART_Rx),            //represent Sampling of one bit 
    // sampler control
    .sample_one_bit(sample_one_bit_UART_Rx),      //to make sampler samples middle bit only
    .sample_three_bit(sample_three_bit_UART_Rx),    //to make sampler samples 3 middle bits by majority
    //.middle_bit_sampling(middle_bit_sampling_UART_Rx),
    // config inputs
    .Prescale(Prescale_Select),                  // 2 bit prescale config
    .PAR_TYP(PAR_TYP),                   // Check type of parity even or odd
    // sampled data 
    .start_bit(start_bit_UART_Rx),
    .parity_bit(parity_bit_UART_Rx),
    .stop_bit(stop_bit),
    .data_out(Data_out_UART_Rx)
);

Sampler UART_Sampler (
    //clock and active low async reset 
    .clk(CLK),.rst_n(RST),
    //Datapath inputs / outputs
    .Serial_Data_IN(RX_IN),
    .Sampled_Bit_OUT(sampled_bit_UART_Rx),
    //Extractor control
    .sample_one_bit(sample_one_bit_UART_Rx),
    .sample_three_bit(sample_three_bit_UART_Rx),
    //.middle_bit_sampling(middle_bit_sampling_UART_Rx),
    //.BIT_TICK(Bit_TICK_UART_Rx),
    //Controller interface
    .sampler_enable(block_enable_word_UART_Rx[3]),           // can be cancelled
    .start_bit_detector(start_bit_detector_UART_Rx)
);

UART_Rx_Controller UART_FSM_Controller(
    // clock and active low async reset 
    .clk(CLK),.rst_n(RST),
    // extranal interface 
    .PAR_EN(PAR_EN),
    .Data_valid(data_valid),
    // configuration block
    .block_enable_word(block_enable_word_UART_Rx), //= {sampler,parity,start,stop}
    .error_flag_word(error_flag_word_UART_Rx),
    // bit counter
    .BIT_TICK(Bit_TICK_UART_Rx),
    .BIT_COUNT(BIT_COUNT_UART_Rx),
    // sampler 
    .start_bit_detector(start_bit_detector_UART_Rx)
);

// Parallel Data output 
    assign P_DATA = Data_out_UART_Rx;
    assign Parity_Error = error_flag_word_UART_Rx[1];
    assign Stop_Error   = error_flag_word_UART_Rx[0];

// Prescale Selection 
    always @(*) begin
        case (Prescale)
            6'd1:  Prescale_Select = 2'b00; //No Oversampling
            6'd8:  Prescale_Select = 2'b01; //Oversampling by 8
            6'd16: Prescale_Select = 2'b10; //Oversampling by 16
            6'd32: Prescale_Select = 2'b11; //Oversampling by 32
            default: begin
                Prescale_Select = 2'b11; //Oversampling by 32 
            end
        endcase
    end

endmodule
/*
   ## Documentation of UART_Rx:
        * the UART Recieves Serial input from RX_IN
            - HIGH at IDLE 
        * the module support oversampling :
            00: no oversampling 
            01: oversmapling by 8
            10: oversmapling by 16
            11: oversmapling by 32
        * DATA is extracted from the received frame 
         - sent through P_DATA bus associated with DATA_VLD signal HIGH 
         - PAR_ERR = 0 && STP_ERR = 0 && START_ERR = 0
         - can accept consective frames with no gap 
        * Configuration :
            - PAR_EN: 0 "disable" / 1 "enable"
            - PAR_TYP: 0 "even" / 1 "odd"
##########################################################################################
    ## Architecture of UART_Rx:
        (1) SAMPLER ✅✅
         Function:
            * Enable the Controller when any data enters = 0 "Start Bit"
                - send enable signal to Controller module
            * send Sampled bit to Sampled Data Register 
                - it's decoder with 11 bit register where sampled data is stored  
         Port Mapping 
            Datapath inputs / outputs
                i_Serial_Data_IN
                o_Sampled_Bit_OUT
            Extractor control
                i_sample_one_bit
                i_sample_three_bit
            Controller interface
                i_Sampler_enable
                o_Start_bit_detector
<---------------------------------------------------------------------------------------->
        (2) FSM Controller ✅✅
            ## interface ##
            // extranal interface 
                i_par_en
            // configuration block
                o_block_enable_word //= {sampler,parity,start,stop}
                i_error_flag_word
            // bit counter
                i_BIT_TICK
                o_BIT_COUNT
            // sampler 
                i_start_bit_detector
                o_sampler_enable // = block_enable_word[0] "can be canceled"

            ## function  ##
            * FSM Module with following behaviour
                - IDLE  : # any error , normal case 
                          # enable_word = 0000 
                            bit_count   = 0   
                - START : # if(o_start_bit_detector) 
                          # enable_word = 1100 
                            bit_count   = 1
                - DATA  : # if(error = 0 && BIT_TICK) 
                          # enable_word = 1000 
                            bit_count   = 2 -> 9
                - PARITY: # if(error = 0 && PAT_EN ) 
                          # enable_word = 1010 
                            bit_count   = 10
                - STOP  : # if(error = 0 && BIT_TICK) 
                          # enable_word = 1001 
                            bit_count   = 11 or 10
            * BIT_COUNT : round loop counter
                if(BIT_Count) BIT_COUNT = BIT_COUNT+1; 
<---------------------------------------------------------------------------------------->       
        (3) configuration block ✅✅
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
<---------------------------------------------------------------------------------------->
        (4) SAMPLED DATA REGISTER "Deserializer" ✅✅
           Function 
            * Store Sampled data from sampler according to their BIT_COUNT
            * Provide all data for Configuration block 
                - start_bit for Start_Checker
                - Data for P_Data output and Parity_Checker
                - parity_bit for Parity_Checker
                - stop_bit for Stop_Checker  

*/    
