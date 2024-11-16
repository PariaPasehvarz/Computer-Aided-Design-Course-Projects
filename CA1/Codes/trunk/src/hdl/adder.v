`timescale 1ps/1ps
module adder #(parameter N = 3)(
    input clk,
    input en,
    output reg done,
    input [N-1:0] inA,
    input [N-1:0] inB,
    output reg [N:0] out
);
    
    always @(posedge clk) begin
        if (en) begin
            out = inA + inB;
            done = 1;
        end else begin
            done = 0;
        end
    end

endmodule