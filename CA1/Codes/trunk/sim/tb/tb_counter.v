`timescale 1ps/1ps
module tb_counter;

    reg clk;
    reg count_enable;
    wire [2:0] count;
    wire co;

    counter Counter (
        .clk(clk),
        .count_enable(count_enable),
        .count(count),
        .co(co)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        count_enable = 0;

        #10 count_enable = 1;

        #10;
        $display("Count = %d, Carry-out (expected 0) = %d", count, co);  // count = 0, co = 0
        
        #10;
        $display("Count = %d, Carry-out (expected 0) = %d", count, co);  // count = 1,co = 0
       
        #40;
        $display("Count = %d, Carry-out (expected 0) = %d", count, co);  // count = 5, co = 0
        
        #10;
        $display("Count = %d, Carry-out (expected 0) = %d", count, co);  //count = 6, co = 0
        
        #10;
        $display("Count = %d, Carry-out (expected 1) = %d", count, co);  // count = 7, co = 1

        #10;
        count_enable = 0;
        
        #20 $stop;
    end
endmodule

