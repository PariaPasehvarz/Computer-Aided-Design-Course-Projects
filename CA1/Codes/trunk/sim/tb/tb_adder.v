`timescale 1ps/1ps
module tb_adder;

    reg clk;
    reg en;
    reg [2:0] inA, inB;
    wire [3:0] out;
    wire done;

    adder #(3) Adder (
        .clk(clk),
        .en(en),
        .inA(inA),
        .inB(inB),
        .out(out),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        en = 0;
        inA = 3'd0;
        inB = 3'd0;

        // inA = 3, inB = 2 expect 5
        #10 en = 1; inA = 3'd3; inB = 3'd2;
        #10 $display("inA = %d, inB = %d, Computed Output = %d, Expected Output = 5", inA, inB, out);
        en = 0;

        //7+4=11
        #10 en = 1; inA = 3'd7; inB = 3'd4;
        #10 $display("inA = %d, inB = %d, Computed Output = %d, Expected Output = 11", inA, inB, out);
        en = 0;

        #50 $stop;
    end
endmodule
