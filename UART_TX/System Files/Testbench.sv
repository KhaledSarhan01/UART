`timescale 1us/1ns
module tb_UART_TX ();

////////////////////////  Signals and Parameters /////////////////////
    localparam Width = 8 ;
    localparam Start_bit = 1'b0 ;
    localparam Stop_bit  = 1'b1 ;
    
    reg              tb_clk , tb_rst ;
    reg [Width-1:0]  tb_P_data;
    reg              tb_Data_valid;
    reg              tb_PAR_TYP , tb_PAR_EN ;
    wire             tb_Tx_out , tb_Busy;

///////////////////////// Clock Generation /////////////////////////// 
    localparam Clock_Period =  8.68; //for Clock Freqeuency= 115.2 KHz
    always #(Clock_Period*0.5) tb_clk =! tb_clk;
    initial tb_clk = 1'b0;

///////////////////////// Test Cases /////////////////////////////////
    initial begin
        //System Commands
            $dumpfile("Result.vcd");
            $dumpvars;
        //initailization
            Initialize();
            Reset();
        //Test Cases
            Testcase_No_parity('h81);
            Testcase_With_parity('h81,1'b0,1'b0);//even Parity
            Testcase_With_parity('h81,1'b1,1'b1);//Odd Parity

            Testcase_No_parity('h7f);
            Testcase_With_parity('h7f,1'b1,1'b0);//even parity
            Testcase_With_parity('h7f,1'b0,1'b1);//odd parity

            Testcase_No_parity('h86);
            Testcase_With_parity('h86,1'b1,1'b0);//even parity
            Testcase_With_parity('h86,1'b0,1'b1);//odd parity 

        //stop the Testbench
        #1000 $stop;       
    end

////////////////////////  Tasks  ////////////////////////////////////

    task Initialize();
            tb_rst          =1'b1 ;
            tb_P_data       ='h00 ;
            tb_Data_valid   =1'b0 ;
            tb_PAR_TYP      =1'b0 ;
            tb_PAR_EN       =1'b0 ;
    endtask
            
    task  Reset();
            #(Clock_Period*0.25)
            tb_rst=1'b0;
            #(Clock_Period*0.25)
            tb_rst=1'b1;
    endtask

    task Testcase_No_parity;
            input reg [Width-1:0] test_bit;
            reg  [Width+1:0] Required_Sequence , Actual_Sequence;
            integer i ;
            //input the Data to DUT    
                $display("Test Case No Parity with input data=%0b",test_bit);    
                #Clock_Period;
                tb_Data_valid= 1'b1;
                tb_PAR_EN = 1'b0;
                tb_PAR_TYP = 1'b0;
                tb_P_data = test_bit;
                #Clock_Period;
                tb_Data_valid =1'b0;

            //Getting the required sequence
                Required_Sequence = {Stop_bit,test_bit,Start_bit};    

            //Getting the Actual Sequence
                wait(tb_Busy) begin
                for (i =0 ; i <= Width+2 ; i=i+1 ) begin
                    #(Clock_Period*0.5);
                    Actual_Sequence[i] = tb_Tx_out; 
                    #(Clock_Period*0.5); 
                end
                end


            //Check out is Test case work or not
            if(Actual_Sequence == Required_Sequence) begin
                $display("Test Case is Passed at time =%0t with Actual Output=%0b and Expected Output=%0b",$time,Actual_Sequence,Required_Sequence);
            end else begin
                $display("Test Case is failed at time =%0t with Actual Output=%0b and Expected Output=%0b",$time,Actual_Sequence,Required_Sequence);
            end
            $display("==============================================================");
    endtask

    
    task  Testcase_With_parity;
            input reg [Width-1:0] test_bit;
            input Parity_bit , Parity_type;
            reg  [Width+2:0] Required_Sequence , Actual_Sequence;
            integer i ;
            //input the Data to DUT    
                $display("Test Case With Parity with input data=%0b , Parity bit =%1b , Type=%1b",test_bit,Parity_bit , Parity_type);    
                #Clock_Period;
                tb_Data_valid= 1'b1;
                tb_PAR_EN = 1'b1;
                tb_PAR_TYP = Parity_type;
                tb_P_data = test_bit;
                #Clock_Period;
                tb_Data_valid =1'b0;

            //Getting the required sequence
                Required_Sequence = {Stop_bit, Parity_bit , test_bit , Start_bit};    

            //Getting the Actual Sequence
                wait(tb_Busy) begin
                for (i =0 ; i <= Width+2 ; i=i+1 ) begin
                    #(Clock_Period*0.5);
                    Actual_Sequence[i] = tb_Tx_out; 
                    #(Clock_Period*0.5); 
                end
                end


            //Check out is Test case work or not
            if(Actual_Sequence == Required_Sequence) begin
                $display("Test Case is Passed at time =%0t with Actual Output=%0b and Expected Output=%0b",$time,Actual_Sequence,Required_Sequence);
            end else begin
                $display("Test Case is failed at time =%0t with Actual Output=%0b and Expected Output=%0b",$time,Actual_Sequence,Required_Sequence);
            end
            $display("==============================================================");
            
    endtask 
////////////////////////  instantiation  /////////////////////////////
    UART_Tx #(.Width(Width)) DUT
    (
        .clk(tb_clk) ,
        .rst(tb_rst) ,
        .P_data(tb_P_data),
        .Data_valid(tb_Data_valid),
        .PAR_TYP(tb_PAR_TYP) , 
        .PAR_EN(tb_PAR_EN) ,
        .Tx_out(tb_Tx_out) , 
        .Busy(tb_Busy)
    );
    
endmodule