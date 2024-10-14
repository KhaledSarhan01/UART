module serializer #(parameter Width = 8)
(
    input wire              clk,rst,
    input wire [Width-1:0]  parallel_in,
    input wire              ser_en , data_valid,
    output reg              serial_out,
    output wire             ser_done 
);
    //internal Registers:
    reg [Width-1:0] data_reg ;
    reg [7:0] Counter;    

    //ser_done signal
        assign ser_done = (Counter == 8'd8)? 1'b1: 1'b0 ;

    //Serial_out Logic
    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            data_reg    <= 'b0;
            Counter     <= 8'b0;
            serial_out  <= 1'b0;
        end else begin
            if(data_valid && !(ser_en)) begin
                data_reg    <= parallel_in ;
                Counter     <= 8'b0;
                serial_out  <= 1'b0;
            end else begin
                if (ser_en && !(ser_done)) begin
                    serial_out  <= data_reg[0]  ;
                    data_reg    <= data_reg >> 1;
                    Counter     <= Counter + 1  ;
                end
            end
        end
    end    

endmodule