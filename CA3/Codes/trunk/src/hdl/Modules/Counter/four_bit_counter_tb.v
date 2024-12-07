`timescale 1ps / 1ps

module four_bit_counter_tb;
    reg clk;
    reg reset;
    reg count_enable;
    wire [3:0] count;

    four_bit_counter dut (
        .clk(clk),
        .reset(reset),
        .count_enable(count_enable),
        .count(count)
    );
    

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    

    initial begin

        reset = 1;
        count_enable = 0;

        #100;
        reset = 0;
        #20;
        count_enable = 1;
        #200;
        count_enable = 0;
        #50;
        
        count_enable = 1;
        #100;
        

        reset = 1;
        #20;
        reset = 0;
        #100;

        $stop;
    end
    
endmodule 