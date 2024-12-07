`timescale 1ps/1ps
module controller(
    input initial_load_ps,
    input clk,
    input start,
    input a_shifting,
    input b_shifting,
    input r_shifting,
    
    output rst,
    output ld,
    output ld_l_shift,
    output ld_r_shift,
    output l_count_enable,
    output r_count_enable,
    output l_shift_allowed,
    output r_shift_allowed,
    output done
);
    wire [2:0] ps, ns;
    wire [2:0] state_reg_in;
    mux shift_reg_in_mux(.a(ns),.b(3'b0),.sel(initial_load_ps),.out(state_reg_in));
    three_bit_register three_bit_ps_register (
        .clk(clk),
        .ld(1'b1),
        .rst(1'b0),
        .in(state_reg_in),
        .out(ps)
    );

    wire [2:0] notPs;
    //use generate to create 3 not gates
    genvar i;
    generate
        for(i = 0; i < 3; i = i + 1) begin: not_gates
            Not not_inst(
                .a(ps[i]),
                .out(notPs[i])
            );
        end
    endgenerate

    wire idle, idle_2, init, load_to_left_shifters, left_shift, load_to_right_shifter, right_shift,done_state;

    ThreeAnd idle_and(
        .in({notPs[2], notPs[1], notPs[0]}),
        .out(idle)
    );

    ThreeAnd idle_2_and(
        .in({notPs[2], notPs[1], ps[0]}),
        .out(idle_2)
    );

    ThreeAnd init_and(
        .in({notPs[2], ps[1], notPs[0]}),
        .out(init)
    );

    ThreeAnd load_to_left_shifters_and(
        .in({notPs[2], ps[1], ps[0]}),
        .out(load_to_left_shifters)
    );

    ThreeAnd left_shift_and(
        .in({ps[2], notPs[1], notPs[0]}),
        .out(left_shift)
    );

    ThreeAnd load_to_right_shifter_and(
        .in({ps[2], notPs[1], ps[0]}),
        .out(load_to_right_shifter)
    );

    ThreeAnd right_shift_and(
        .in({ps[2], ps[1], notPs[0]}),
        .out(right_shift)
    );

    ThreeAnd done_and(
        .in({ps[2], ps[1], ps[0]}),
        .out(done_state)
    );

    assign rst = idle_2;
    assign ld = init;
    assign ld_l_shift = load_to_left_shifters;
    assign ld_r_shift = load_to_right_shifter;
    assign l_count_enable = left_shift;
    assign r_count_enable = right_shift;
    assign l_shift_allowed = left_shift;
    assign r_shift_allowed = right_shift;
    assign done = done_state;


    //s0 = idle.start +idle_2.start + init + left_shift.~a_shifting.~b_shifting + right_shift.~r_shifting
    wire idle_and_start;
    And idle_and_start_inst(
        .a(idle),
        .b(start),
        .out(idle_and_start)
    );

    wire idle_2_and_start;
    And idle_2_and_start_inst(
        .a(idle_2),
        .b(start),
        .out(idle_2_and_start)
    );

    wire not_a_shifting, not_b_shifting;
    Not not_a_shifting_inst(
        .a(a_shifting),
        .out(not_a_shifting)
    );

    Not not_b_shifting_inst(
        .a(b_shifting),
        .out(not_b_shifting)
    );

    wire left_shift_and_not_a_shifting_and_not_b_shifting;
    ThreeAnd left_shift_and_not_a_shifting_and_not_b_shifting_inst(
        .in({left_shift, not_a_shifting, not_b_shifting}),
        .out(left_shift_and_not_a_shifting_and_not_b_shifting)
    );

    wire not_r_shifting;
    Not not_r_shifting_inst(
        .a(r_shifting),
        .out(not_r_shifting)
    );

    wire right_shift_and_not_r_shifting;
    And right_shift_and_not_r_shifting_inst(
        .a(right_shift),
        .b(not_r_shifting),
        .out(right_shift_and_not_r_shifting)
    );

    FiveOr ns_0_or(
        .in({idle_and_start, idle_2_and_start, init, left_shift_and_not_a_shifting_and_not_b_shifting, right_shift_and_not_r_shifting}),
        .out(ns[0])
    );

    //s1 =idle_2.~start + init + load_to_right_shifter + right_shift
    wire idle_2_and_not_start;
    wire not_start;
    Not not_start_inst(
        .a(start),
        .out(not_start)
    );
    And idle_2_and_not_start_inst(
        .a(idle_2),
        .b(not_start),
        .out(idle_2_and_not_start)
    );

    FourOr ns_1_or(
        .in({idle_2_and_not_start, init, load_to_right_shifter, right_shift}),
        .out(ns[1])
    );

    //s2 = load_to_left_shifters + left_shift + load_to_right_shifter + right_shift
    FourOr ns_2_or(
        .in({load_to_left_shifters,left_shift,load_to_right_shifter, right_shift}),
        .out(ns[2])
    );

endmodule

