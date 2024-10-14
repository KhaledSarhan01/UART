module FSM_controller(
    input wire          clk,rst,
    input wire          Data_valid,
    input wire          ser_done,
    input wire          parity_enable,

    output reg          ser_en,
    output reg [2:0]    Mux_sel,
    output reg          Busy
);

 // State Encoding: Gray code encoding 
    parameter [2:0] Idle_state    = 3'b000 ,
                    Start_state   = 3'b001 ,
                    Data_state    = 3'b011 ,
                    Parity_state  = 3'b010 ,
                    Stop_state    = 3'b100 ;

 //Current State Register
    reg [2:0] current_state , next_state;
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            current_state <= Stop_state;
        end else begin
            current_state <= next_state;
        end  
    end

 //Next State Combinational Logic:
    always @(*) begin
        case (current_state)
                Idle_state: begin
                    if(Data_valid) begin
                        next_state <= Start_state ;
                    end
                    else begin 
                        next_state <= Idle_state ;
                    end
                end
                
                Start_state: begin
                    next_state <= Data_state ; 
                end  

                Data_state: begin
                    if(!ser_done) begin
                        next_state <= Data_state ;
                    end
                    else begin
                        if (parity_enable) begin
                            next_state <= Parity_state;
                        end else begin
                            next_state <= Stop_state ;
                        end
                    end
                end

                Parity_state: begin
                    next_state <= Stop_state ;
                end

                Stop_state: begin
                    next_state <= Idle_state ;
                end
            default: begin
                next_state <= Stop_state;
            end
        endcase
    end

//Output Combinational Logic:
    localparam [2:0] Start_bit  = 3'b000 ,
                     Stop_bit   = 3'b001 ,
                     Data_bits  = 3'b011 ,
                     Parity_bit = 3'b010 ,
                     Idle_bit   = 3'b110 ; 

    always @(*) begin
        ser_en  = 1'b0 ;
        Busy    = 1'b0 ;
        Mux_sel = Idle_bit; 
        case (current_state)
                Idle_state: begin
                    ser_en  = 1'b0 ;
                    Busy    = 1'b0 ;
                    Mux_sel = Idle_bit; 
                end

                Start_state: begin
                    ser_en  = 1'b1 ;
                    Busy    = 1'b1 ;
                    Mux_sel = Start_bit;
                end    
                
                Data_state: begin
                    ser_en  = 1'b1 ;
                    Busy    = 1'b1 ;
                    Mux_sel = Data_bits;
                end

                Parity_state: begin
                    ser_en  = 1'b0 ;
                    Busy    = 1'b1 ;
                    Mux_sel = Parity_bit;
                end

                Stop_state: begin
                    ser_en  = 1'b0 ;
                    Busy    = 1'b1 ;
                    Mux_sel = Stop_bit;
                end

            default: begin
                
            end
        endcase
    end


endmodule