`timescale 1ps/1ps
module LZD(
    input [7:0] in,
    output [3:0] out
);
    wire is_zero, is_seven, is_six, is_five;
    wire is_four, is_three, is_two, is_one, is_zero_pos;
    
    wire not_7, not_6, not_5, not_4, not_3, not_2, not_1, not_0;
    
    Not not_bit7(.a(in[7]), .out(not_7));
    Not not_bit6(.a(in[6]), .out(not_6));
    Not not_bit5(.a(in[5]), .out(not_5));
    Not not_bit4(.a(in[4]), .out(not_4));
    Not not_bit3(.a(in[3]), .out(not_3));
    Not not_bit2(.a(in[2]), .out(not_2));
    Not not_bit1(.a(in[1]), .out(not_1));
    Not not_bit0(.a(in[0]), .out(not_0));
    
    assign is_zero_pos = in[7];
    
    //is_one: (!in[7] && in[6])
    And and_is_one(.a(not_7), .b(in[6]), .out(is_one));
    
    wire and_72;
    And and_72_gate(.a(not_7), .b(not_6), .out(and_72));
    And and_is_two(.a(and_72), .b(in[5]), .out(is_two));
    
    wire and_725;
    And and_725_gate(.a(and_72), .b(not_5), .out(and_725));
    And and_is_three(.a(and_725), .b(in[4]), .out(is_three));
    
    wire and_7254;
    And and_7254_gate(.a(and_725), .b(not_4), .out(and_7254));
    And and_is_four(.a(and_7254), .b(in[3]), .out(is_four));
    
    wire and_72543;
    And and_72543_gate(.a(and_7254), .b(not_3), .out(and_72543));
    And and_is_five(.a(and_72543), .b(in[2]), .out(is_five));
    
    wire and_725432;
    And and_725432_gate(.a(and_72543), .b(not_2), .out(and_725432));
    And and_is_six(.a(and_725432), .b(in[1]), .out(is_six));
    
    wire and_7254321;
    And and_7254321_gate(.a(and_725432), .b(not_1), .out(and_7254321));
    And and_is_seven(.a(and_7254321), .b(in[0]), .out(is_seven));
    
    wire and_72543210;
    And and_72543210_gate(.a(and_7254321), .b(not_0), .out(and_72543210));
    assign is_zero = and_72543210;

    assign out[3] = 1'b0;
    
    wire or_45, or_456, or_4567;
    Or or_45_gate(.a(is_four), .b(is_five), .out(or_45));
    Or or_456_gate(.a(or_45), .b(is_six), .out(or_456));
    Or or_4567_gate(.a(or_456), .b(is_seven), .out(or_4567));
    Or or_out2(.a(or_4567), .b(is_zero), .out(out[2]));
    
    wire or_23, or_236, or_2367;
    Or or_23_gate(.a(is_two), .b(is_three), .out(or_23));
    Or or_236_gate(.a(or_23), .b(is_six), .out(or_236));
    Or or_2367_gate(.a(or_236), .b(is_seven), .out(or_2367));
    Or or_out1(.a(or_2367), .b(is_zero), .out(out[1]));
    
    wire or_13, or_135, or_1357;
    Or or_13_gate(.a(is_one), .b(is_three), .out(or_13));
    Or or_135_gate(.a(or_13), .b(is_five), .out(or_135));
    Or or_1357_gate(.a(or_135), .b(is_seven), .out(or_1357));
    Or or_out0(.a(or_1357), .b(is_zero), .out(out[0]));

endmodule