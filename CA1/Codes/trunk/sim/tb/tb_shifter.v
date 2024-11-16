`timescale 1ps/1ps
module tb_shifter;

    reg clk;
    reg en;
    reg [31:0] in;
    reg [3:0] shift_count;
    wire [31:0] out_right;
    wire [31:0] out_left;
    wire done_right;
    wire done_left;

    shifter #(32, 4, 1) right_shifter (
        .clk(clk),
        .en(en),
        .in(in),
        .shift_count(shift_count),
        .out(out_right),
        .done(done_right)
    );

    shifter #(32, 4, 0) left_shifter (
        .clk(clk),
        .en(en),
        .in(in),
        .shift_count(shift_count),
        .out(out_left),
        .done(done_left)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        en = 0;
        in = 32'd0;
        shift_count = 4'd0;

        // shifting right by 2
        #10 en = 1; in = 32'b11110000111100001111000011110000; shift_count = 4'b0010;
        #10 $display("Right Shift: Input = %b, Shift Count = %d, Computed Output = %b", in, shift_count, out_right);
        en = 0;

        // shifting right by 3
        #10 en = 1; in = 32'b10101010101010101010101010101010; shift_count = 4'b0011;
        #10 $display("Right Shift: Input = %b, Shift Count = %d, Computed Output = %b", in, shift_count, out_right);
        en = 0;

        // left by 2
        #10 en = 1; in = 32'b11110000111100001111000011110000; shift_count = 4'b0010;
        #10 $display("Left Shift: Input = %b, Shift Count = %d, Computed Output = %b", in, shift_count, out_left);
        en = 0;

        //left by 3
        #10 en = 1; in = 32'b10101010101010101010101010101010; shift_count = 4'b0011;
        #10 $display("Left Shift: Input = %b, Shift Count = %d, Computed Output = %b", in, shift_count, out_left);
        en = 0;

        #50 $stop;
    end
endmodule

