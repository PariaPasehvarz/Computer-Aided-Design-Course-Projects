module FourAnd (
    input [3:0] in,
    output out
);
    wire out1, out2;
    And a1(in[0], in[1], out1);
    And a2(in[2], in[3], out2);
    And a3(out1, out2, out);

endmodule

