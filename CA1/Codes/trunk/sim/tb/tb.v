`timescale 1ps/1ps


module tb();
    reg clk,rst,start;
    wire done;

    appr_multiplier Appr_Multiplier(.clk(clk), .start(start), .rst(rst), .done(done));

    always #5 clk = ~clk;
        initial begin
            {start,rst,clk} = 3'b0;
            #50 start = 1'b1;
            #50 start = 1'b0;
            #5000
            #100 rst = 1'b1;
            #100 rst = 1'b0;
            #10 $stop;
        end
endmodule