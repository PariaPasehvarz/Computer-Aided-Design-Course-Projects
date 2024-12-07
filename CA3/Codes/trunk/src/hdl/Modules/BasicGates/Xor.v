module Xor(
    input a,
    input b,
    output out
);
    
    c2 xor_impl(
        .D00(1'b0),
        .D01(1'b1),
        .D10(1'b1),
        .D11(1'b0),
        .A1(a),
        .B1(1'b0),
        .A0(b),
        .B0(1'b1),
        .out(out)
    );

endmodule