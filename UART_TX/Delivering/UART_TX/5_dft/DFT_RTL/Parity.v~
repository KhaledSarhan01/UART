module Parity_calc #(parameter Width = 8)
(
    input wire              Data_valid,
    input wire              parity_type,
    input wire [Width-1:0]  in_data,
    output reg              parity_bit
);

    //Taking the input
    reg [Width-1:0]  internal_reg;   
    always @(posedge Data_valid)begin
        internal_reg <= in_data;
    end

    //Calculating the Parity Bit 
    always @(*) begin
            if (parity_type) begin //Odd Parity
                parity_bit = ~^(internal_reg);
            end else begin  //even Parity
                parity_bit = ^(internal_reg);
            end
    end
endmodule