`timescale 1ps/1ps
module shifter #(parameter N = 32, parameter shift_bits = 4, parameter is_right_shifter = 1)(
    input clk,
    input en,
    output reg done,
    input [N-1:0] in,
    input [shift_bits-1:0] shift_count,
    output reg [N-1:0] out //reg because it is assigned inside always
);

    always @(posedge clk) begin
        if (en) begin
            out = is_right_shifter ? in >> shift_count : in << shift_count;
            done = 1;
        end else begin
            done = 0;
        end
    end

endmodule
