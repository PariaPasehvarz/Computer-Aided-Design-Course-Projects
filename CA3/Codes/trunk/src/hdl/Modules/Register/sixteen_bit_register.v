`timescale 1ps/1ps
module sixteen_bit_register (
    input clk,
    input ld,
    input rst,
    input [15:0] in,
    output [15:0] out
);

    genvar i;
    generate
        for(i = 0; i < 16; i = i + 1) begin: reg_bits
            s2 bit_reg(
                .D00(out[i]),
                .D01(out[i]),
                .D10(in[i]),
                .D11(in[i]),
                .A1(ld),
                .B1(1'b0),
                .A0(1'b0),
                .B0(1'b0),
                .clr(rst),
                .clk(clk),
                .out(out[i]) 
            );
        end
    endgenerate

endmodule 