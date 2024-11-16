`timescale 1ps/1ps
module LZD(
    input clk,
    input en,
    input [7:0] in,
    output reg [3:0] out,
    output reg done
);

    always @(posedge clk) begin
        if (en) begin
            
            casex(in)
                8'b00000000: out = 8;
                8'b00000001: out = 7;
                8'b0000001x: out = 6;
                8'b000001xx: out = 5;
                8'b00001xxx: out = 4;
                8'b0001xxxx: out = 3;
                8'b001xxxxx: out = 2;
                8'b01xxxxxx: out = 1;
                8'b1xxxxxxx: out = 0;
                default: out = 8;
            endcase
            done = 1;
        end else begin
            done = 0;
        end
    end

endmodule
