//time scale
`timescale 1us/1ns

//------ Testbench ---------
module TB_UART_RX;
//     Signals      //
    //clock and active low async reset
    reg RX_CLK,tb_RST;
    //Main input 
    reg tb_RX_IN;
    //configuration inputs
    reg tb_PAR_TYP,tb_PAR_EN;
    reg [5:0] tb_Prescale;
    //outputs
    wire [7:0] tb_P_DATA;
    wire tb_Data_valid;
    wire tb_Parity_Error;
    wire tb_Stop_Error;
    
//   Instantiation  //
    UART_Rx DUT(
        //clock and active low async reset
        .CLK(RX_CLK),.RST(tb_RST),
        //Main input 
        .RX_IN(tb_RX_IN),
        //configuration inputs
        .PAR_TYP(tb_PAR_TYP),.PAR_EN(tb_PAR_EN),
        .Prescale(tb_Prescale),
        //outputs
        .P_DATA(tb_P_DATA),
        .data_valid(tb_Data_valid),
        .Parity_Error(tb_Parity_Error),
        .Stop_Error(tb_Stop_Error) 
    );

// Clock Generation //
    //for TX Clock Frequency = 115.2kHz 
    localparam TX_Clock_Period =8.68; 
    //localparam RX_Clock_Period = ;
    reg TX_CLK;
    initial  begin 
        RX_CLK = 1'b0;
        TX_CLK = 1'b1; 
        end
    /*always @(*) begin
        case (tb_Prescale)
            6'd8: begin
               #((TX_Clock_Period / 8*2))  
                RX_CLK = !RX_CLK; 
            end
            6'd16: begin
               #((TX_Clock_Period / 16*2)) 
                RX_CLK = !RX_CLK; 
            end
            6'd32: begin
               #((TX_Clock_Period / 32*2))
                RX_CLK = !RX_CLK; 
            end
            default: begin
                #((TX_Clock_Period / 8*2))                  
                RX_CLK = !RX_CLK;
            end
        endcase
    end*/
    always #(TX_Clock_Period/(2.0*tb_Prescale)) RX_CLK = !RX_CLK;  
    always #(TX_Clock_Period/2) TX_CLK = !TX_CLK;

// FOR READABLITY //
localparam  EVEN        = 1'b0 ,
            ODD         = 1'b1 ,
            ENABLED     = 1'b1 ,
            DISABLED    = 1'b0 ,
            START_BIT   = 1'b0 ,
            STOP_BIT    = 1'b1 ;

//  Initial Block   //
initial begin
    //dumping variables
    $dumpfile("tb_results.vcd");
    $dumpvars;

    //Initailization
    Initialization();
    Reset_Test();

    //###########################################################################################
        //Group Test 1: Oversampling By 8
        Reset();
        $display("########## Group Test 1 (Oversampling by 8) ############# \n\n"); 
        tb_Prescale = 6'd8;
        Group_Test;       

    //###########################################################################################
        //Group Test 2: Oversampling By 16
        Reset();
        $display("########## Group Test 2 (Oversampling by 16) ############# \n\n"); 
        tb_Prescale = 6'd16;
        Group_Test;       

    //###########################################################################################
        //Group Test 3: Oversampling By 32
        Reset();
        $display("########## Group Test 3 (Oversampling by 32) ############# \n\n"); 
        tb_Prescale = 6'd32;
        Group_Test; 

    //finish testbench
    $display("############# Testbench Completed ############# \n\n");
    #(1000);
    $stop;                  
end

///////////////////////////////////////////////////
/////////////    Main Test Tasks   ////////////////
//////////////////////////////////////////////////
task Group_Test;
    //Tests
    // Packet One: 1011_0010 even parity : 0 , odd parity : 1
    // Packet two: 1010_0100 even parity : 1 , odd parity : 0
    begin
        // Test Single Packet with Right Bits 
            // No Parity
            $display("=====> Test Single Packet with Right Bits , NO PARITY \n");
            Single_Packet(8'b1011_0010,1'b0,START_BIT,STOP_BIT,DISABLED,EVEN);
             
            // Even Parity 
            $display("=====> Test Single Packet with Right Bits , EVEN PARITY \n");
            Single_Packet(8'b1011_0010,1'b0,START_BIT,STOP_BIT,ENABLED,EVEN);
            
            // Odd Parity
            $display("=====> Test Single Packet with Right Bits , ODD PARITY \n");
            Single_Packet(8'b1011_0010,1'b1,START_BIT,STOP_BIT,ENABLED,ODD);
            

        //  Test Single Packet with Wrong Bits
            // Wrong stop Bit 
            $display("=====> Test Single Packet with Wrong STOP Bit\n");
            Single_Packet(8'b1011_0010,1'b0,START_BIT,!STOP_BIT,DISABLED,EVEN);
            
            // Wrong Even Bit
            $display("=====> Test Single Packet with Wrong EVEN PAR Bit\n");
            Single_Packet(8'b1011_0010,1'b1,START_BIT,STOP_BIT,ENABLED,EVEN);
            
            // Wrong Odd  Bit
            $display("=====> Test Single Packet with Wrong ODD PAR Bit\n");
            Single_Packet(8'b1011_0010,1'b0,START_BIT,STOP_BIT,ENABLED,ODD);
            

        // Test Consecutive Packets
            // Right Parity Bits
            $display("=====> Test Two Consecutive Packet with Right EVEN Parity Bits\n");
            Double_Packet(8'b1011_0010,1'b0,8'b1010_0100,1'b1,ENABLED,EVEN);
            
            $display("=====> Test Two Consecutive Packet with Right ODD Parity Bits\n");
            Double_Packet(8'b1011_0010,1'b1,8'b1010_0100,1'b0,ENABLED,ODD);
            
            // Wrong Parity Bits
            $display("=====> Test Two Consecutive Packet with Wrong EVEN Parity Bits\n");
            Double_Packet(8'b1011_0010,1'b1,8'b1010_0100,1'b1,ENABLED,EVEN);
            
            $display("=====> Test Two Consecutive Packet with Wrong ODD Parity Bits\n");
            Double_Packet(8'b1011_0010,1'b1,8'b1010_0100,1'b1,ENABLED,ODD);
             
    end
endtask
task Initialization;
    $display("############# Testbench Begins ############# \n\n");
    //clock and active low async reset
    tb_RST = 1'b1;
    //Main input 
    tb_RX_IN = 1'b1;
    //configuration inputs
    tb_PAR_TYP = 1'b0;
    tb_PAR_EN = 1'b0;
    tb_Prescale =6'd8;
endtask

task Reset_Test;
    /*
    Reset Test "Latency 1 clk"
        //Inputs
            tb_RST      = 1'b0;

        // Outputs and Intrenal Signals:
                tb_P_DATA       = 8'b0;
                tb_Data_valid   = 1'b0;

                SAMPLING_DATA_data_reg  = 11'b0;
                
                CONTROL_bit_count       = 4'b0;
                CONTROL_current_state   = 3'b000; "IDLE"

                CONFIG_enable_word      = 4'b0;
                CONFIG_edge_count       = 8'b0;  
            
    */
    reg success_flag;
    begin
     $display("############# Reset Test ############# \n\n");
    @(posedge RX_CLK);      // Setup Time 
        tb_RST = 1'b0;
        case (tb_Prescale)
            6'd8: begin
               #((TX_Clock_Period / 8.0)*1.75)    //Observation Time
                check_output('b0,'b0,'b0,'b0,success_flag); 
            end
            6'd16: begin
               #((TX_Clock_Period / 16.0)*1.75)    //Observation Time
                check_output('b0,'b0,'b0,'b0,success_flag); 
            end
            6'd32: begin
               #((TX_Clock_Period / 32.0)*1.75)    //Observation Time
                check_output('b0,'b0,'b0,'b0,success_flag); 
            end
            default: begin
                #((TX_Clock_Period / 8.0)*1.75)    //Observation Time
                check_output('b0,'b0,'b0,'b0,success_flag);
            end
        endcase
    //Check Success 
    if (success_flag) begin
        $display("Reset Test SUCESS at time = %0t",$time);
    end else begin
        $display("Reset Test FAILED at time = %0t",$time);
        $stop;
    end

    @(posedge RX_CLK);      // Release Time
        tb_RST = 1'b1;   
    end
endtask

task Single_Packet;
    //input data
    input [7:0] Data_IN;
    input parity_bit;
    input start_bit;
    input stop_bit;
    
    //configuration data
    input parity_enable;
    input parity_type;

    begin
        //Enter Configuation
        Configuration_inputs(parity_enable,parity_type); 
        load_start_bit(start_bit);
        load_Data_bits(Data_IN);
        if(parity_enable)begin
            load_parity_bit(parity_bit,parity_type,Data_IN);
            load_stop_bit(stop_bit,Data_IN);
        end else begin
            load_stop_bit(stop_bit,Data_IN);
        end
        load_void_data(Data_IN);
        Reset();
    end
endtask

task Double_Packet;
    //input data
    input [7:0] Data_IN_1;
    input parity_bit_1;
    input [7:0] Data_IN_2;
    input parity_bit_2;
    //configuration data
    input parity_enable;
    input parity_type;
    reg success_flag;

    begin
        //Enter Configuation
        Configuration_inputs(parity_enable,parity_type); 
        //First Packet
        load_start_bit(1'b0);
        load_Data_bits(Data_IN_1);
        if(parity_enable)begin
            load_parity_bit(parity_bit_1,parity_type,Data_IN_1);
            load_stop_bit(1'b1,Data_IN_1);
        end else begin
            load_stop_bit(1'b1,Data_IN_1);
        end
        //check data vaild
        @(posedge RX_CLK);
        check_output(Data_IN_1,1'b1,1'b0,1'b0,success_flag);
        if (success_flag) begin
            $display("----> Data valid Appears correctly");
            $display("#### Module is Working Right ####");
        end else begin
            $display("----> Data valid Appears Wrong");
            $display("#### Module is Working Wrong at time=%0t",$time);
            $stop;
        end
        //Second Packet
        load_start_bit(1'b0);
        load_Data_bits(Data_IN_2);
        if(parity_enable)begin
            load_parity_bit(parity_bit_2,parity_type,Data_IN_2);
            load_stop_bit(1'b1,Data_IN_2);
        end else begin
            load_stop_bit(1'b1,Data_IN_2);
        end
        load_void_data(Data_IN_2);
        Reset();
    end
endtask


///////////////////////////////////////////////////
//////////////////// Sub Tasks ////////////////////
//////////////////////////////////////////////////
 
task Configuration_inputs;
        input parity_enable;
        input parity_type;
        begin
        tb_PAR_TYP  = parity_type;
        tb_PAR_EN   = parity_enable;
        //tb_Prescale = prescale;

        if(!parity_enable)
        begin
            $display("\t Configuration Inputs: Parity DISABLED , Prescale=%0d , at time=%0t\n",tb_Prescale,$time);
        end
        else begin
            if(!parity_type) begin
                $display("\t Configuration Inputs: Parity ENABLED EVEN , Prescale=%0d , at time=%0t\n",tb_Prescale,$time);
            end else begin
                $display("\t Configuration Inputs: Parity ENABLED ODD , Prescale=%0d , at time=%0t\n",tb_Prescale,$time);     
            end
        end 
        end
endtask

task load_start_bit;
    input start_bit;
    reg success_flag;
    begin
        //loading start Bit
        @(posedge TX_CLK);
        $display("-- Loading Start bit --");
        tb_RX_IN = start_bit;
        
        //check start bit funtion
        if(!start_bit) begin //Right Start Bit
        $display("----> This is the Right Start Bit");
        success_flag = 1'b1;
        end else begin
        $display("---->This is the Wrong Start Bit");    
        success_flag = 1'b0;
        end 
        
        //check the working of module
        if (success_flag) begin
            $display("### Module is Working Right ###");
        end else begin
            $display("### Module is Working Wrong at time =%0t ####",$time);
            $stop;
        end
    end
endtask

task load_Data_bits;
    input [7:0] Data_IN;
    reg success_flag;
    integer i;
    begin
        // loading bits
        for(i=0 ; i<8 ; i=i+1) begin
            @(posedge TX_CLK)
            tb_RX_IN = Data_IN[i] ;
            $display("-- Loading BIT no %0d --",i); 
        end
        // check the output 
        case (tb_Prescale)
            6'd8: begin
               #((TX_Clock_Period / 8.0)*1.75)    //Observation Time
                check_output(Data_IN,1'b0,1'b0,1'b0,success_flag);
            end
            6'd16: begin
               #((TX_Clock_Period / 16.0)*1.75)    //Observation Time
                check_output(Data_IN,1'b0,1'b0,1'b0,success_flag); 
            end
            6'd32: begin
               #((TX_Clock_Period / 32.0)*1.75)    //Observation Time
                check_output(Data_IN,1'b0,1'b0,1'b0,success_flag);
            end
            default: begin
                #((TX_Clock_Period / 8)*1.75)    //Observation Time
                check_output(Data_IN,1'b0,1'b0,1'b0,success_flag);
            end
        endcase
        

        //check the working of module
        if (success_flag) begin
            $display("### Module is Working Right ###");
        end else begin
            $display("### Module is Working Wrong at time =%0t ####",$time);
            $stop;
        end
    end
endtask     

task  load_parity_bit;
    input parity_bit;
    input parity_type;
    input [7:0] Data_IN;
    reg right_even_parity, right_odd_parity;
    reg success_flag;
    begin
        // Right parity bits
        right_even_parity = ~^(Data_IN);
        right_odd_parity  = ^(Data_IN);

        //Loading Parity bit
        $display("-- Loading Parity Bit --");
        @(posedge TX_CLK);
        tb_RX_IN = parity_bit;

        //Checking Output 
        if (parity_type == EVEN) begin
            if (parity_bit == right_even_parity ) begin
                $display("----> RIGHT EVEN PARITY");
                check_output(Data_IN,1'b0,1'b0,1'b0,success_flag);
            end else begin
                $display("----> WRONG EVEN PARITY");
                check_output(Data_IN,1'b0,1'b1,1'b0,success_flag);
            end
        end else if (parity_type == ODD) begin
           if (parity_bit == right_odd_parity ) begin
                $display("----> RIGHT ODD PARITY");
                check_output(Data_IN,1'b0,1'b0,1'b0,success_flag);
            end else begin
                $display("----> WRONG ODD PARITY");
                check_output(Data_IN,1'b0,1'b1,1'b0,success_flag);
            end
        end

        //check the working of module
        if (success_flag) begin
            $display("### Module is Working Right ###");
        end else begin
            $display("### Module is Working Wrong at time =%0t ####",$time);
            $stop;
        end
    end
endtask
           
task load_stop_bit;
    input stop_bit;
    input Data_IN;
    reg success_flag;
    begin
        //loading Stop bit
        $display("-- Loading Stop Bit --");
        @(posedge TX_CLK);
        tb_RX_IN = stop_bit;
        
        //check outputs
        if (stop_bit) begin
            $display("----> Right Stop Bit");
            check_output(Data_IN,1'b0,1'b0,1'b0,success_flag);
        end else begin
            $display("----> Wrong Stop Bit");
            check_output(Data_IN,1'b0,1'b0,1'b1,success_flag);
        end
        //check the working of module
        if (success_flag) begin
            $display("### Module is Working Right ###");
        end else begin
            $display("### Module is Working Wrong at time =%0t ####",$time);
            $stop;
        end
    end
endtask

task load_void_data;
    input Data_IN;
    reg success_flag;
    begin
        //check data vaild
        @(posedge RX_CLK);
        check_output(Data_IN,1'b1,1'b0,1'b0,success_flag);
        if (success_flag) begin
            $display("----> Data valid Appears correctly");
            $display("#### Module is Working Right ####");
        end else begin
            $display("----> Data valid Appears Wrong");
            $display("#### Module is Working Wrong at time=%0t",$time);
            $stop;
        end

        //add Void Data
        @(TX_Clock_Period * 10);
        tb_RX_IN = 1'b1;
    end
endtask
///////////////////////////////////////////////////
////////////// Internal Tasks ////////////////////
/////////////////////////////////////////////////

task check_output;
    input [7:0] reference_P_Data;
    input reference_Data_Valid;
    input reference_Parity_Error;
    input reference_Stop_Error;
    output output_observation_flag;
    begin
        if (tb_P_DATA == reference_Data_Valid && tb_Data_valid == reference_Data_Valid && tb_Stop_Error == reference_Stop_Error && tb_Parity_Error == reference_Parity_Error ) 
            begin
            $display("\t Output Check SUCESS : P_Data = %8b , Data_Valid = %1b , Parity Error= %1b , Stop Error = %1b, at time = %0t \n",
                    tb_P_DATA,tb_Data_valid,tb_Parity_Error,tb_Stop_Error,$time);
            output_observation_flag = 1'b1;
        end else begin
            $display("\t Output Check FAILED : P_Data = %8b , Data_Valid = %1b , Parity Error= %1b , Stop Error = %1b, at time = %0t \n",
                    tb_P_DATA,tb_Data_valid,tb_Parity_Error,tb_Stop_Error,$time);
            output_observation_flag = 1'b0;
        end
    end    
endtask

task Reset;
    begin
     $display("-----> Reset the Module \n");
    @(posedge RX_CLK);      // Setup Time 
        tb_RST = 1'b0;
    @(posedge RX_CLK);      // Release Time
        tb_RST = 1'b1;   
    end
endtask

endmodule
