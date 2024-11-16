`timescale 1ps/1ps

module appr_multiplier(
    input clk, 
    input rst, 
    input start, 
    output done
);

    wire ld_a, ld_b, lzd_a_en, lzd_b_en, add_en, l_shift_a_en, l_shift_b_en, mul_en, multiply_done;
    wire r_shift_en, write_en, count_enable, write_file;
    wire lzd_a_done, lzd_b_done, add_done, shift_a_done, shift_b_done, r_shift_done;

    controller Controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .lzd_a_done(lzd_a_done),
        .lzd_b_done(lzd_b_done),
        .add_done(add_done),
        .left_shift_a_done(shift_a_done),
        .left_shift_b_done(shift_b_done),
        .r_shift_done(r_shift_done),
        .co(co),
	    .multiply_done(multiply_done),

        .ld_a(ld_a),
        .ld_b(ld_b),
        .lzd_a_en(lzd_a_en),
        .lzd_b_en(lzd_b_en),
        .add_en(add_en),
        .l_shift_a_en(l_shift_a_en),
        .l_shift_b_en(l_shift_b_en),
        .mul_en(mul_en),
        .r_shift_en(r_shift_en),
        .write_en(write_en),
        .count_enable(count_enable),
        .done(done),
        .write_file(write_file)
    );

    datapath Datapath (
        .clk(clk),
        .count_enable(count_enable),
        .ld_a(ld_a),
        .ld_b(ld_b),
        .lzd_a_en(lzd_a_en),
        .lzd_b_en(lzd_b_en),
        .add_en(add_en),
        .mul_en(mul_en),
        .shift_a_en(l_shift_a_en),
        .shift_b_en(l_shift_b_en),
        .r_shift_en(r_shift_en),
        .write_file(write_file),
        .write_en(write_en),
        
        .co(co),
        .lzd_a_done(lzd_a_done),
        .lzd_b_done(lzd_b_done),
        .add_done(add_done),
        .mul_done(multiply_done),
        .shift_a_done(shift_a_done),
        .shift_b_done(shift_b_done),
        .r_shift_done(r_shift_done)
    );

endmodule
