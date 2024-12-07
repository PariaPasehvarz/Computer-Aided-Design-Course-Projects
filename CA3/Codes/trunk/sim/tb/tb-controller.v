`timescale 1ns/1ns
`default_nettype none

module tb ();
    reg initial_load_ps;
    reg clk;
    reg start;
    reg a_shifting;
    reg b_shifting;
    reg r_shifting;

    wire rst;
    wire ld;
    wire ld_l_shift;
    wire ld_r_shift;
    wire l_count_enable;
    wire r_count_enable;
    wire done;

    controller uut (
        .initial_load_ps(initial_load_ps),
        .clk(clk),
        .start(start),
        .a_shifting(a_shifting),
        .b_shifting(b_shifting),
        .r_shifting(r_shifting),
        .rst(rst),
        .ld(ld),
        .ld_l_shift(ld_l_shift),
        .ld_r_shift(ld_r_shift),
        .l_count_enable(l_count_enable),
        .r_count_enable(r_count_enable),
        .done(done)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        initial_load_ps = 1;
        #10;
        initial_load_ps = 0;
        start = 0;
        a_shifting = 0;
        b_shifting = 0;
        r_shifting = 0;

        #10;
        start = 1;l
        #10;
        start = 0;

        #20;

        #10;

        a_shifting = 1;
        b_shifting = 1;
        #30;
        a_shifting = 0;
        b_shifting = 0;

        #10;

        r_shifting = 1;
        #40;
        r_shifting = 0;

        #10;

        if (done)
            $display("Test completed successfully");

        #20;
        $stop;
    end
endmodule
