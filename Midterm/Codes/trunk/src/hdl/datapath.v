`timescale 1ps/1ps

module datapath (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] X_input,
    input wire [2:0] N_input,
    input wire valid,
    input wire ready,
    input wire load_N,
    input wire load_X,
    input wire load_registers,

    output wire [31:0] result,
    output wire overflow,
    output wire error
);

wire [7:0] coefficient_x;
wire [2:0] polynomial_degree;
wire [2:0] starting_stage_num, stage0_num, stage1_num, stage2_num, stage3_num, stage01_num, stage12_num, stage23_num, stage30_num;
wire [127:0] memory;
wire [15:0] starting_x_power, shifted_x;
wire [15:0] stage0_x_power, stage1_x_power, stage2_x_power, stage3_x_power, stage01_x_power, stage12_x_power, stage23_x_power, stage30_x_power;
wire [31:0] starting_result, stage0_result, stage01_result, stage1_result, stage12_result, stage2_result, stage23_result, stage3_result, stage30_result;
wire stage0_overflow, stage1_overflow, stage2_overflow, stage3_overflow;
wire plus = 1'b0;
wire minus = 1'b1;

wire [31:0] result_mux1, result_mux2;

error_detector error_check (
    .clk(clk),
    .reset(reset),
    .start(start),
    .X_input(X_input),
    .N_input(N_input),
    .error(error)
);

coefficients_rom coeff_rom (
    .memory(memory)
);

register #(.N(8)) reg_X (
    .clk(clk),
    .rst(reset),
    .ld(load_X),
    .in(X_input),
    .out(coefficient_x)
);

register #(.N(3)) reg_N (
    .clk(clk),
    .rst(reset),
    .ld(load_N),
    .in(N_input),
    .out(polynomial_degree)
);

assign shifted_x = {coefficient_x, 8'b0};
assign starting_result = (ready) ? 32'b0 : stage30_result;
assign starting_x_power = (ready) ? shifted_x : stage30_x_power;
assign starting_stage_num = (ready) ? 3'b0 : stage30_num;

stage stage0 (
    .clk(clk),
    .X_input(shifted_x),
    .N_input(polynomial_degree),
    .memory(memory),
    .stage_sign(plus),  
    .prev_stage_result(starting_result),          
    .current_x_power(starting_x_power),        
    .current_stage_num(starting_stage_num),                   
    .current_stage_result(stage0_result),     
    .next_x_power(stage0_x_power), 
    .next_stage_num(stage0_num), 
    .overflow(stage0_overflow)  
);

register #(.N(32)) reg_stage01_result (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage0_result),
    .out(stage01_result)
);

register #(.N(16)) reg_stage01_x_power (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage0_x_power),
    .out(stage01_x_power)
);

register #(.N(3)) reg_stage01_num (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage0_num),
    .out(stage01_num)
);

stage stage1 (
    .clk(clk),
    .X_input(shifted_x),
    .N_input(polynomial_degree),
    .memory(memory),
    .stage_sign(minus),  
    .prev_stage_result(stage01_result),  
    .current_x_power(stage01_x_power),    
    .current_stage_num(stage01_num),   
    .current_stage_result(stage1_result),    
    .next_x_power(stage1_x_power), 
    .next_stage_num(stage1_num), 
    .overflow(stage1_overflow)
);

register #(.N(32)) reg_stage12_result (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage1_result),
    .out(stage12_result)
);

register #(.N(16)) reg_stage12_x_power (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage1_x_power),
    .out(stage12_x_power)
);

register #(.N(3)) reg_stage12_num (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage1_num),
    .out(stage12_num)
);

stage stage2 (
    .clk(clk),
    .X_input(shifted_x),
    .N_input(polynomial_degree),
    .memory(memory),
    .stage_sign(plus),  
    .prev_stage_result(stage12_result),  
    .current_x_power(stage12_x_power),    
    .current_stage_num(stage12_num),   
    .current_stage_result(stage2_result),    
    .next_x_power(stage2_x_power), 
    .next_stage_num(stage2_num), 
    .overflow(stage2_overflow)
);

register #(.N(32)) reg_stage23_result (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage2_result),
    .out(stage23_result)
);

register #(.N(16)) reg_stage23_x_power (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage2_x_power),
    .out(stage23_x_power)
);

register #(.N(3)) reg_stage23_num (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage2_num),
    .out(stage23_num)
);

stage stage3 (
    .clk(clk),
    .X_input(shifted_x),
    .N_input(polynomial_degree),
    .memory(memory),
    .stage_sign(minus),  
    .prev_stage_result(stage23_result),  
    .current_x_power(stage23_x_power),    
    .current_stage_num(stage23_num),   
    .current_stage_result(stage3_result),    
    .next_x_power(stage3_x_power), 
    .next_stage_num(stage3_num), 
    .overflow(stage3_overflow)
);

register #(.N(32)) reg_stage30_result (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage3_result),
    .out(stage30_result)
);

register #(.N(16)) reg_stage30_x_power (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage3_x_power),
    .out(stage30_x_power)
);

register #(.N(3)) reg_stage30_num (
    .clk(clk),
    .rst(reset),
    .ld(load_registers),
    .in(stage3_num),
    .out(stage30_num)
);

assign result = valid ? (
    ((polynomial_degree - 1) % 4 == 0) ? stage01_result :
    ((polynomial_degree - 1) % 4 == 1) ? stage12_result :
    ((polynomial_degree - 1) % 4 == 2) ? stage23_result :
    stage30_result
) : 32'b0;

assign overflow = stage0_overflow | stage1_overflow | stage2_overflow | stage3_overflow;
endmodule
    