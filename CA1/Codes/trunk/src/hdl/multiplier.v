`timescale 1ps/1ps
module multiplier #(parameter N = 8)(
    input clk,
    input en,
    output reg done,
    input [N-1:0] inA,
    input [N-1:0] inB,
    output reg [N*2-1:0] out
);
    
    always @(posedge clk) begin
        if (en) begin
            out = inA * inB;
            done = 1;
        end else begin
            done = 0;
        end
    end

endmodule