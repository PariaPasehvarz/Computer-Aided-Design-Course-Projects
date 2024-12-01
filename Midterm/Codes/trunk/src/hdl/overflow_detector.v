`timescale 1ps/1ps

module overflow_detector #(parameter N = 32)(
    input [N-1:0] a,        
    input [N-1:0] b,         
    input [N-1:0] result,
    input operation,        // 0 for add, 1 for subtract
    output overflow      
);

    wire msb_a, msb_b, msb_result;
    wire add_overflow, sub_overflow;
    
    assign msb_a = a[N-1];
    assign msb_b = b[N-1];
    assign msb_result = result[N-1];

    assign add_overflow = (msb_a & msb_b & ~msb_result) | 
                         (~msb_a & ~msb_b & msb_result);

    assign sub_overflow = (msb_a & ~msb_b & ~msb_result) | 
                         (~msb_a & msb_b & msb_result);     

    assign overflow = operation ? sub_overflow : add_overflow;

endmodule