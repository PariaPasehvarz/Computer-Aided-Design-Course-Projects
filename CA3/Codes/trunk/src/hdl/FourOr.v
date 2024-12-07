module FourOr (
    input [3:0] in,
    output out
);
    wire out1, out2;
    Or o1(in[0], in[1], out1);
    Or o2(in[2], in[3], out2);
    Or o3(out1, out2, out);

endmodule

