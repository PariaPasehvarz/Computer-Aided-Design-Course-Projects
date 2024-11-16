`timescale 1ps/1ps
module tb_LZD;

    reg clk;
    reg en;
    reg [7:0] in;
    wire [3:0] out;
    wire done;

    LZD leadingZeroDetector (
        .clk(clk),
        .en(en),
        .in(in),
        .out(out),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        en = 0;
        in = 8'b00000000;

        // 00000000 -> 8
        #10 en = 1; in = 8'b00000000;
        #10 $display("Input = %b, Computed Output = %d, Expected Output = 8", in, out);
        en = 0;

        // 00000111 ->5
        #10 en = 1; in = 8'b00000111;
        #10 $display("Input = %b, Computed Output = %d, Expected Output = 5", in, out);
        en = 0;

        //01000000->1
        #10 en = 1; in = 8'b01000000;
        #10 $display("Input = %b, Computed Output = %d, Expected Output = 1", in, out);
        en = 0;

        //10000000 ->0
        #10 en = 1; in = 8'b10000000;
        #10 $display("Input = %b, Computed Output = %d, Expected Output = 0", in, out);
        en = 0;

        // Finish simulation
        #50 $stop;
    end
endmodule

