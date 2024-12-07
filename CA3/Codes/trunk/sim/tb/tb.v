`timescale 1ns/1ns
`default_nettype none

module tb ();
    reg initial_load_ps;
    reg clk;
    reg start;
    reg [15:0] A;
    reg [15:0] B;
    wire [15:0] result;
    wire done;

    top_module top_module_inst (
        .clk(clk),
        .initial_load_ps(initial_load_ps),
        .start(start),
        .A(A),
        .B(B),
        .result(result),
        .done(done)
    );

    initial clk = 0;
    always #5 clk = ~clk;
    integer i;
    reg [15:0] Atestcases [4:0];
    reg [15:0] Btestcases [4:0];


    initial begin

        Atestcases[0] = 16'b0011_0111_1111_1110;
        Btestcases[0] = 16'b0000_1110_1111_1110;

        Atestcases[1] = 16'b0011_0101_1011_1010;
        Btestcases[1] = 16'b1000_1010_1011_1110;

        Atestcases[2] = 16'b0011_0101_0011_1110;
        Btestcases[2] = 16'b0010_1110_0111_1110;

        Atestcases[3] = 16'b0111_0101_1011_1110;
        Btestcases[3] = 16'b0001_1010_0111_1110;

        Atestcases[4] = 16'b0000_0000_1011_1110;
        Btestcases[4] = 16'b0000_0000_1111_0110;



        initial_load_ps = 1;
        #10;
        initial_load_ps = 0;

        for (i = 0; i < 5; i=i+1) begin
            start = 0;
            A = Atestcases[i];
            B = Btestcases[i];

            #10;
            start = 1;
            #10;
            start = 0;

            #300;
        end
        #20;
        $stop;
    end
endmodule
