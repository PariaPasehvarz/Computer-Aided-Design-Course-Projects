`timescale 1ps/1ps

module three_bit_register_tb();

    reg clk;
    reg ld;
    reg [2:0] in;
    wire [2:0] out;

    three_bit_register dut (
        .clk(clk),
        .ld(ld),
        .rst(1'b0),
        .in(in),
        .out(out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        ld = 0;
        in = 0;

        #20;

        in = 3'b101;
        ld = 1;
        #20;

        $stop;
    end

    
endmodule