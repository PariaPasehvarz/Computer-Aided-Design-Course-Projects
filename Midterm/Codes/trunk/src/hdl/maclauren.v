`timescale 1ps/1ps

module maclauren #(
    parameter OUTPUT_WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire start,
    input wire [7:0] X,
    input wire [2:0] N,
    
    output wire [31:0] Y,
    output wire valid,
    output wire ready,
    output wire overflow,
    output wire error
);

wire load_N;
wire load_X;
wire load_registers;

controller ctrl (
    .clk(clk),
    .reset(rst),
    .start(start),
    .N_input(N),
    .overflow(overflow),
    .error(error),
    .load_N(load_N),
    .load_X(load_X),
    .load_registers(load_registers),
    .ready(ready),
    .valid(valid)
);

datapath dp (
    .clk(clk),
    .reset(rst),
    .start(start),
    .load_N(load_N),
    .load_X(load_X),
    .load_registers(load_registers),
    .X_input(X),
    .N_input(N),
    .result(Y),
    .valid(valid),
    .ready(ready),
    .overflow(overflow),
    .error(error)
);

endmodule