module four_bit_is_less_than (
    input [3:0] counter,
    input [3:0] lzd_output,
    output result
);
    wire [3:0] gt_bits;
    wire [3:0] eq_bits;
    wire [3:0] xor_outputs;
    wire [3:0] counter_inv;
    
    Xor xor3 (.a(counter[3]), .b(lzd_output[3]), .out(xor_outputs[3]));
    Xor xor2 (.a(counter[2]), .b(lzd_output[2]), .out(xor_outputs[2]));
    Xor xor1 (.a(counter[1]), .b(lzd_output[1]), .out(xor_outputs[1]));
    Xor xor0 (.a(counter[0]), .b(lzd_output[0]), .out(xor_outputs[0]));
    
    Not not_eq3 (.a(xor_outputs[3]), .out(eq_bits[3]));
    Not not_eq2 (.a(xor_outputs[2]), .out(eq_bits[2]));
    Not not_eq1 (.a(xor_outputs[1]), .out(eq_bits[1]));
    Not not_eq0 (.a(xor_outputs[0]), .out(eq_bits[0]));
    
    Not not_c3 (.a(counter[3]), .out(counter_inv[3]));
    Not not_c2 (.a(counter[2]), .out(counter_inv[2]));
    Not not_c1 (.a(counter[1]), .out(counter_inv[1]));
    Not not_c0 (.a(counter[0]), .out(counter_inv[0]));
    
    And and_gt3 (.a(counter_inv[3]), .b(lzd_output[3]), .out(gt_bits[3]));
    
    wire gt2_temp;
    And and_gt2_temp (.a(counter_inv[2]), .b(lzd_output[2]), .out(gt2_temp));
    And and_gt2 (.a(eq_bits[3]), .b(gt2_temp), .out(gt_bits[2]));
    
    wire gt1_temp1, gt1_temp2;
    And and_gt1_temp1 (.a(counter_inv[1]), .b(lzd_output[1]), .out(gt1_temp1));
    And and_gt1_temp2 (.a(eq_bits[3]), .b(eq_bits[2]), .out(gt1_temp2));
    And and_gt1 (.a(gt1_temp2), .b(gt1_temp1), .out(gt_bits[1]));
    
    wire gt0_temp1, gt0_temp2, gt0_temp3;
    And and_gt0_temp1 (.a(counter_inv[0]), .b(lzd_output[0]), .out(gt0_temp1));
    And and_gt0_temp2 (.a(eq_bits[3]), .b(eq_bits[2]), .out(gt0_temp2));
    And and_gt0_temp3 (.a(eq_bits[1]), .b(gt0_temp1), .out(gt0_temp3));
    And and_gt0 (.a(gt0_temp2), .b(gt0_temp3), .out(gt_bits[0]));
    
    wire or_temp1, or_temp2;
    Or or1 (.a(gt_bits[3]), .b(gt_bits[2]), .out(or_temp1));
    Or or2 (.a(gt_bits[1]), .b(gt_bits[0]), .out(or_temp2));
    Or final_or (.a(or_temp1), .b(or_temp2), .out(result));

endmodule
