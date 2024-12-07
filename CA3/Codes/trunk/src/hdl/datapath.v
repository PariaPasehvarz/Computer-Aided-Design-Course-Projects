module datapath(
    input clk,
    input rst,
    input ld,
    input ld_l_shift,
    input ld_r_shift,
    input l_count_en,
    input r_count_en,
    input l_shift_allowed,
    input r_shift_allowed,
    input [15:0] A,
    input [15:0] B,
    output [15:0] output_result,
    output a_shifting,
    output b_shifting,
    output r_shifting
);
    wire [15:0] reg_a_out, reg_b_out;
    wire [3:0] lzd_a_out, lzd_b_out;
    wire [4:0] adder_out;
    wire [15:0] shift_a_out, shift_b_out;
    wire [15:0] multiplier_out;
    wire [3:0] counter_a_val, counter_b_val;
    wire [4:0] counter_r_val;
    wire a_shifting_en, b_shifting_en, r_shifting_en;
    assign a_shifting = a_shifting_en;
    assign b_shifting = b_shifting_en;
    assign r_shifting = r_shifting_en;

    sixteen_bit_register reg_a (
        .clk(clk),
        .ld(ld),
        .rst(rst),
        .in(A),
        .out(reg_a_out)
    );

    sixteen_bit_register reg_b (
        .clk(clk),
        .ld(ld),
        .rst(rst),
        .in(B),
        .out(reg_b_out)
    );

    LZD lzd_a (
        .in(reg_a_out[15:8]),
        .out(lzd_a_out)
    );

    LZD lzd_b (
        .in(reg_b_out[15:8]),
        .out(lzd_b_out)
    );

    four_bit_counter counter_a (
        .clk(clk),
        .reset(rst),
        .count_enable(l_count_en),
        .count(counter_a_val)
    );

    four_bit_is_less_than comp_a (
        .counter(counter_a_val),
        .lzd_output(lzd_a_out),
        .result(a_shifting_en)
    );

    wire a_left_shift_enable;
    And a_left_shift_enable_and(
        .a(a_shifting_en),
        .b(l_shift_allowed),
        .out(a_left_shift_enable)
    );

    left_shifter shift_a (
        .clk(clk),
        .ld(ld_l_shift),
        .rst(rst),
        .shift_enable(a_left_shift_enable),
        .in(reg_a_out),
        .out(shift_a_out)
    );

    four_bit_counter counter_b (
        .clk(clk),
        .reset(rst),
        .count_enable(l_count_en),
        .count(counter_b_val)
    );

    four_bit_is_less_than comp_b (
        .counter(counter_b_val),
        .lzd_output(lzd_b_out),
        .result(b_shifting_en)
    );

    wire b_left_shift_enable;
    And b_left_shift_enable_and(
        .a(b_shifting_en),
        .b(l_shift_allowed),
        .out(b_left_shift_enable)
    );
    left_shifter shift_b (
        .clk(clk),
        .ld(ld_l_shift),
        .rst(rst),
        .shift_enable(b_left_shift_enable),
        .in(reg_b_out),
        .out(shift_b_out)
    );

    adder add_lzd (
        .inA(lzd_a_out),
        .inB(lzd_b_out),
        .out(adder_out)
    );

    multiplier mult (
        .inA(shift_a_out[15:8]),
        .inB(shift_b_out[15:8]),
        .out(multiplier_out)
    );

    five_bit_counter counter_r (
        .clk(clk),
        .reset(rst),
        .count_enable(r_count_en),
        .count(counter_r_val)
    );

    five_bit_is_less_than comp_mul (
        .counter(counter_r_val),
        .lzd_output(adder_out),
        .result(r_shifting_en)
    );

    wire right_shift_enable;
    And right_shift_enable_and(
        .a(r_shifting_en),
        .b(r_shift_allowed),
        .out(right_shift_enable)
    );

    right_shifter shift_right (
        .clk(clk),
        .ld(ld_r_shift),
        .rst(rst),
        .shift_enable(right_shift_enable),
        .in(multiplier_out),
        .out(output_result)
    );

endmodule