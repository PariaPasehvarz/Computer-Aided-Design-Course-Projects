`timescale 1ps/1ps
module left_shifter (
    input clk,
    input ld,
    input rst,
    input shift_enable,
    input [15:0] in,
    output [15:0] out
);
    wire [16:0] shift_in; //1 extra bit for the 0 input to LSB
    
    assign shift_in[15:0] = {out[14:0], 1'b0};
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_stage
            s2 bit_cell (
                .D00(out[i]),
                .D01(shift_in[i]),
                .D10(in[i]),
                .D11(1'b0),
                .A1(ld),
                .B1(1'b0),
                .A0(shift_enable),
                .B0(1'b1),
                .clr(rst),
                .clk(clk),
                .out(out[i])
            );
        end
    endgenerate

endmodule
