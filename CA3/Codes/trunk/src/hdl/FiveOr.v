module FiveOr (
    input [4:0] in,
    output out
);
    wire out1, out2;
    FourOr f1(in[3:0], out1);
    Or o1(out1, in[4], out);

endmodule
