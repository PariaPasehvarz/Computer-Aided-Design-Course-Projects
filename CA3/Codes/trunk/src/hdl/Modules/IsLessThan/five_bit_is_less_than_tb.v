module five_bit_is_less_than_tb;
    reg [4:0] counter;
    reg [4:0] lzd_output;
    wire result;

    five_bit_is_less_than uut (
        .counter(counter),
        .lzd_output(lzd_output),
        .result(result)
    );
    
    initial begin
        counter = 0;
        lzd_output = 0;
        #100;
        counter = 5'b0011;
        lzd_output = 5'b0111;
        #10;
        if (result !== 1'b1) $display("Test 1 Failed: %b < %b should be 1", counter, lzd_output);

        counter = 5'b1000;
        lzd_output = 5'b0111;
        #10;
        if (result !== 1'b0) $display("Test 2 Failed: %b < %b should be 0", counter, lzd_output);

        counter = 5'b0101;
        lzd_output = 5'b0101;
        #10;
        if (result !== 1'b0) $display("Test 3 Failed: %b < %b should be 0", counter, lzd_output);
        
        counter = 5'b0000;
        lzd_output = 5'b0001;
        #10;
        if (result !== 1'b1) $display("Test 4 Failed: %b < %b should be 1", counter, lzd_output);
        
        counter = 5'b1111;
        lzd_output = 5'b1111;
        #10;
        if (result !== 1'b0) $display("Test 5 Failed: %b < %b should be 0", counter, lzd_output);
        
        $display("All tests completed");
        $stop;
    end


endmodule 