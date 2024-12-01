`timescale 1ps/1ps

module multiplier (
    input [15:0] inA,
    input [15:0] inB,
    output [15:0] out
);
    
    wire signed [31:0] mult_result;

    assign mult_result = $signed(inA) * $signed(inB);

    assign out = (inA == 16'b0) ? inB : mult_result[30:15];

endmodule