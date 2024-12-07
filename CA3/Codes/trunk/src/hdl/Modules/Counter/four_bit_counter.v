`timescale 1ps/1ps
module four_bit_counter (
    input clk,
    input reset,
    input count_enable,
    output [3:0] count
);
    s2 bit0(
        .D00(count[0]),
        .D01(~count[0]),
        .D10(1'b0),
        .D11(1'b0),
        .A1(reset),
        .B1(1'b0),
        .A0(count_enable),
        .B0(1'b1),
        .clr(1'b0),
        .clk(clk),
        .out(count[0])
    );

    wire bit1_A0;
    And bit1_A0_and(
        .a(count_enable),
        .b(count[0]),
        .out(bit1_A0)
    );

    s2 bit1(
        .D00(count[1]),
        .D01(~count[1]),
        .D10(1'b0),
        .D11(1'b0),
        .A1(reset),
        .B1(1'b0),
        .A0(bit1_A0),
        .B0(1'b1),
        .clr(1'b0),
        .clk(clk),
        .out(count[1])
    );

    wire bit2_A0;
    ThreeAnd bit2_A0_and(
        .in({count_enable, count[1], count[0]}),
        .out(bit2_A0)
    );

    s2 bit2(
        .D00(count[2]),
        .D01(~count[2]),
        .D10(1'b0),
        .D11(1'b0),
        .A1(reset),
        .B1(1'b0),
        .A0(bit2_A0),
        .B0(1'b1),
        .clr(1'b0),
        .clk(clk),
        .out(count[2])
    );

    wire bit3_A0;
    FourAnd bit3_A0_and(
        .in({count_enable, count[2], count[1], count[0]}),
        .out(bit3_A0)
    );

    s2 bit3(
        .D00(count[3]),
        .D01(~count[3]),
        .D10(1'b0),
        .D11(1'b0),
        .A1(reset),
        .B1(1'b0),
        .A0(bit3_A0),
        .B0(1'b1),
        .clr(1'b0),
        .clk(clk),
        .out(count[3])
    );

endmodule