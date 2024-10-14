module UART_Rx_Controller(
    // clock and active low async reset 
    input clk , rst_n,
    // extranal interface 
    input PAR_EN,
    output reg Data_valid,
    // configuration block
    output reg [3:0] block_enable_word, //= {sampler,parity,start,stop}
    input [2:0] error_flag_word,
    // bit counter
    input BIT_TICK,
    output wire [3:0] BIT_COUNT,
    // sampler 
    input wire start_bit_detector
);
// BIT Counter
    reg [3:0] BIT_COUNT_reg;
    assign BIT_COUNT = BIT_COUNT_reg;

    reg BIT_COUNT_CLR;
    always @(posedge clk or negedge rst_n ) begin
        if (!rst_n) begin
            BIT_COUNT_reg <= 4'b0;
        end else begin
            if (BIT_COUNT_CLR || Data_valid) begin
                    BIT_COUNT_reg <= 4'b0;
                end else begin
                    if(BIT_TICK) begin
                        BIT_COUNT_reg <= BIT_COUNT_reg + 1;
                     end
                end
        end
    end
// State Encoding: Gray Code Encoding 
    localparam [2:0] IDLE    = 3'b000  ,
                     START   = 3'b001  ,
                     DATA    = 3'b010  ,
                     PARITY  = 3'b011  ,
                     STOP    = 3'b100  ,
                     DONE    = 3'b101  ;

// Current State Seqential Logic
    reg [2:0] current_state , next_state;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

// Output Logic
    always @(*) begin
        case (current_state)
            IDLE  : begin
                Data_valid = 1'b0;
                block_enable_word =4'b0000; //= {sampler,parity,start,stop}
                BIT_COUNT_CLR = 1'b1;
            end
            START : begin
                Data_valid = 1'b0;
                block_enable_word =4'b1100;
                BIT_COUNT_CLR = 1'b0;
            end
            DATA  : begin
                Data_valid = 1'b0;
                block_enable_word =4'b1000;
                BIT_COUNT_CLR = 1'b0;
            end 
            PARITY: begin
                Data_valid = 1'b0;
                block_enable_word =4'b1010;
                BIT_COUNT_CLR = 1'b0;
            end 
            STOP  : begin
                Data_valid = 1'b0;
                block_enable_word =4'b1001;
                BIT_COUNT_CLR = 1'b0;
            end
            DONE: begin
                Data_valid = 1'b1;
                block_enable_word =4'b0000;
                BIT_COUNT_CLR = 1'b1;
            end
            default: begin
                Data_valid = 1'b0;
                block_enable_word =4'b0000;
                BIT_COUNT_CLR = 1'b0;
            end
        endcase
    end

// Next State Combinational Logic 
    always @(*) begin
        case (current_state)
            IDLE  : begin
                if (!(error_flag_word)&& BIT_COUNT_reg == 4'd0 && start_bit_detector) begin
                    next_state = START;
                end else begin
                    next_state = IDLE ;
                end            
            end
            START : begin
                if (!(error_flag_word) && BIT_COUNT_reg == 4'd1) begin
                    next_state = DATA;
                end else if(error_flag_word) begin
                    next_state = IDLE;
                end else begin
                    next_state = START;
                end
            end
            DATA  : begin
                if (!(error_flag_word) && PAR_EN && BIT_COUNT_reg == 4'd10) begin
                    next_state = PARITY;
                end else if (!(error_flag_word)  && BIT_COUNT_reg == 4'd9) begin
                    next_state = STOP;
                end else if(error_flag_word) begin
                    next_state = IDLE;
                end else begin
                    next_state = DATA;
                end
            end 
            PARITY: begin
                if (!(error_flag_word) && PAR_EN  && BIT_COUNT_reg == 4'd11) begin
                    next_state = STOP;
                end else if(error_flag_word) begin
                    next_state = IDLE;
                end else begin
                    next_state = PARITY;
                end
            end 
            STOP  : begin
                if (!(error_flag_word) && PAR_EN  && BIT_COUNT_reg == 4'd12) begin
                    next_state = DONE;
                end else if (!(error_flag_word) && BIT_COUNT_reg == 4'd11) begin
                    next_state = DONE;
                end else if(error_flag_word) begin
                    next_state = IDLE;
                end else begin
                    next_state = STOP;
                end
            end
            DONE: begin
                if (!(error_flag_word) && ((PAR_EN && BIT_COUNT_reg == 4'd11)||(!(PAR_EN) && BIT_COUNT_reg == 4'd10)) ) begin
                    next_state = IDLE;
                end
                else begin
                    next_state = (BIT_COUNT_reg == 4'b0)? IDLE:DONE;
                end
                
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
/*
## INPUTS
    input PAR_EN,
    input [2:0] error_flag_word,
    input start_bit_detector,
    input BIT_TICK,
    reg  BIT_COUNT_Register
## OUTPUTS
    output reg Data_valid
    output reg [3:0] block_enable_word, //= {sampler,parity,start,stop}    
    
    
     
*/
/*
(2) FSM Controller
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
*/
