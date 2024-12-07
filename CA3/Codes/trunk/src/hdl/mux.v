module mux(
    input [2:0] a,
    input [2:0] b, // b is selected in sel=1
    input sel,
    output [2:0] out
);
    //out = sel.b + ~sel.a
    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : mux_logic
            wire not_sel;
            Not not_sel_inst(.a(sel), .out(not_sel));
            wire and_out_a, and_out_b;
            And and_out_a_inst(.a(not_sel), .b(a[i]), .out(and_out_a));
            And and_out_b_inst(.a(sel), .b(b[i]), .out(and_out_b));
            Or or_out_inst(.a(and_out_a), .b(and_out_b), .out(out[i]));
        end
    endgenerate
endmodule