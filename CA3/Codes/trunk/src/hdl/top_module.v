module top_module(
    input clk,
    input initial_load_ps,
    input start,
    input [15:0] A,
    input [15:0] B,
    output [15:0] result,
    output done
);
    wire rst, ld, ld_l_shift, ld_r_shift, l_count_enable, r_count_enable, l_shift_allowed, r_shift_allowed;
    wire a_shifting, b_shifting, r_shifting;
    controller controller_inst (
        .initial_load_ps(initial_load_ps),
        .clk(clk),
        .start(start),
        .a_shifting(a_shifting),
        .b_shifting(b_shifting),
        .r_shifting(r_shifting),
        .l_shift_allowed(l_shift_allowed),
        .r_shift_allowed(r_shift_allowed),

        .rst(rst),
        .ld(ld),
        .ld_l_shift(ld_l_shift),
        .ld_r_shift(ld_r_shift),
        .l_count_enable(l_count_enable),
        .r_count_enable(r_count_enable),
        .done(done)
    );

    datapath datapath_inst (
        .clk(clk),
        .rst(rst),
        .ld(ld),
        .ld_l_shift(ld_l_shift),
        .ld_r_shift(ld_r_shift),
        .l_count_en(l_count_enable),
        .r_count_en(r_count_enable),
        .l_shift_allowed(l_shift_allowed),
        .r_shift_allowed(r_shift_allowed),
        .A(A),
        .B(B),
        .output_result(result),
        .a_shifting(a_shifting),
        .b_shifting(b_shifting),
        .r_shifting(r_shifting)
        
    );
endmodule