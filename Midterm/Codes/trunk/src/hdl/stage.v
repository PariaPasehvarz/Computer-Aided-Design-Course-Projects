`timescale 1ps/1ps

module stage ( 
    input clk,
    input [2:0] N_input,
    input [15:0] X_input,
    input [127:0] memory,
    input stage_sign,  
    
    input [31:0] prev_stage_result,
    input [15:0] current_x_power,
    input [2:0] current_stage_num,

    output [31:0] current_stage_result,
    output [15:0] next_x_power,
    output [2:0] next_stage_num,
    output overflow
);

    wire [15:0] mult_result;
    wire [31:0] mult_result_sign_extended;

    multiplier mult (
        .inA(current_x_power),
        .inB(X_input),
        .out(next_x_power)
    );
    
    multiplier mult2 (
        .inA(memory[127 - (current_stage_num * 16) -: 16]),
        .inB(current_x_power),
        .out(mult_result)
    );

    assign mult_result_sign_extended = {mult_result, 16'b0};

    assign current_stage_result = stage_sign ? (prev_stage_result - mult_result_sign_extended) : (prev_stage_result + mult_result_sign_extended);

    overflow_detector #(.N(32)) overflow_check (
        .a(prev_stage_result),
        .b(mult_result_sign_extended),
        .result(current_stage_result),
        .operation(stage_sign),
        .overflow(overflow)
    );

    assign next_stage_num = current_stage_num + 1;

endmodule
