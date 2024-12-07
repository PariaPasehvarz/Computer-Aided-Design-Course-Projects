`timescale 1ps/1ps
module adder(
    input [3:0] inA,
    input [3:0] inB,
    output [4:0] out
);
    wire [4:0] carry;
    wire [3:0] sum;
    
    assign carry[0] = 1'b0;
    
    // 4 full adders
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin: full_adder_gen
            wire sum_temp;
            
            Xor xor1(.a(inA[i]), .b(inB[i]), .out(sum_temp));
            
            Xor xor2(.a(sum_temp), .b(carry[i]), .out(sum[i]));
            
            // carry[i+1] = G + P·Ci = (A·B) + (A⊕B)·Ci
            wire and1_out, and2_out;
            And and1(.a(inA[i]), .b(inB[i]), .out(and1_out));
            And and2(.a(sum_temp), .b(carry[i]), .out(and2_out));
            Or or1(.a(and1_out), .b(and2_out), .out(carry[i+1]));
        end
    endgenerate
    
    assign out = {carry[4], sum};

endmodule