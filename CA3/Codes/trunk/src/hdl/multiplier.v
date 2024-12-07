module multiplier(
    input [7:0] inA,
    input [7:0] inB,
    output [15:0] out
);
    wire [7:0] pp0, pp1, pp2, pp3;
    wire [7:0] pp4, pp5, pp6, pp7;
    
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            And And_0(.a(inA[i]), .b(inB[0]), .out(pp0[i]));
            And And_1(.a(inA[i]), .b(inB[1]), .out(pp1[i]));
            And And_2(.a(inA[i]), .b(inB[2]), .out(pp2[i]));
            And And_3(.a(inA[i]), .b(inB[3]), .out(pp3[i]));
            And And_4(.a(inA[i]), .b(inB[4]), .out(pp4[i]));
            And And_5(.a(inA[i]), .b(inB[5]), .out(pp5[i]));
            And And_6(.a(inA[i]), .b(inB[6]), .out(pp6[i]));
            And And_7(.a(inA[i]), .b(inB[7]), .out(pp7[i]));
        end
    endgenerate

    wire [15:0] shifted_pp0 = {8'b0, pp0};
    wire [15:0] shifted_pp1 = {7'b0, pp1, 1'b0};
    wire [15:0] shifted_pp2 = {6'b0, pp2, 2'b0};
    wire [15:0] shifted_pp3 = {5'b0, pp3, 3'b0};
    wire [15:0] shifted_pp4 = {4'b0, pp4, 4'b0};
    wire [15:0] shifted_pp5 = {3'b0, pp5, 5'b0};
    wire [15:0] shifted_pp6 = {2'b0, pp6, 6'b0};
    wire [15:0] shifted_pp7 = {1'b0, pp7, 7'b0};

    wire [15:0] sum1, sum2, sum3, sum4, sum5, sum6, sum7;
    wire [15:0] carry;
    
    ripple_adder_16bit add1(.a(shifted_pp0), .b(shifted_pp1), .cin(1'b0), .sum(sum1), .cout(carry[0]));
    ripple_adder_16bit add2(.a(sum1), .b(shifted_pp2), .cin(1'b0), .sum(sum2), .cout(carry[1]));
    ripple_adder_16bit add3(.a(sum2), .b(shifted_pp3), .cin(1'b0), .sum(sum3), .cout(carry[2]));
    ripple_adder_16bit add4(.a(sum3), .b(shifted_pp4), .cin(1'b0), .sum(sum4), .cout(carry[3]));
    ripple_adder_16bit add5(.a(sum4), .b(shifted_pp5), .cin(1'b0), .sum(sum5), .cout(carry[4]));
    ripple_adder_16bit add6(.a(sum5), .b(shifted_pp6), .cin(1'b0), .sum(sum6), .cout(carry[5]));
    ripple_adder_16bit add7(.a(sum6), .b(shifted_pp7), .cin(1'b0), .sum(out), .cout(carry[6]));

endmodule

module ripple_adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,
    output [15:0] sum,
    output cout
);
    wire [16:0] carry;
    assign carry[0] = cin;

    generate
        for (genvar i = 0; i < 16; i = i + 1) begin : full_adders
            full_adder fa(
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i]),
                .sum(sum[i]),
                .cout(carry[i+1])
            );
        end
    endgenerate

    assign cout = carry[16];
endmodule

module full_adder(
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    wire w1, w2, w3;
    
    Xor Xor_1(.a(a), .b(b), .out(w1));
    Xor Xor_2(.a(w1), .b(cin), .out(sum));
    And And_8(.a(w1), .b(cin), .out(w2));
    And And_9(.a(a), .b(b), .out(w3));
    Or Or_0(.a(w2), .b(w3), .out(cout));
endmodule