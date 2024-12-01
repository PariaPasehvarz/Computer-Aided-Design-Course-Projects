`timescale 1ps / 1ps    

module error_detector (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [7:0] X_input,
    input wire [2:0] N_input,
    output wire error
);

    assign error = (^{clk, reset, start, X_input, N_input} === 1'bx) || 
                  (^{clk, reset, start, X_input, N_input} === 1'bz);

endmodule