module ThreeAnd (
    input [2:0] in,
    output out
);
    wire out1, out2;
    And a1(in[0], in[1], out1);
    And a2(out1, in[2], out);

endmodule

