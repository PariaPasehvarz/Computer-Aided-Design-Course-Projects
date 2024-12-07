`timescale 1ps/1ps

module adder_tb();
        reg [3:0] inA;
    reg [3:0] inB;
    wire [4:0] out;
    
    adder dut (
        .inA(inA),
        .inB(inB),
        .out(out)
    );
    
    initial begin
        inA = 0;
        inB = 0;
        
        #10;
        
        inA = 4'b0010;
        inB = 4'b0011;
        #10;
        
        if (out === 5'b0101)
            $display("Test Case 1 PASSED: 2 + 3 = %d", out);
        else
            $display("Test Case 1 FAILED: 2 + 3 = %d (expected 5)", out);
            
        #10;
        
        inA = 4'b0111;
        inB = 4'b0110;
        #10;
        
        if (out === 5'b1101)
            $display("Test Case 2 PASSED: 7 + 6 = %d", out);
        else
            $display("Test Case 2 FAILED: 7 + 6 = %d (expected 13)", out);
            
        #10;
        
        $stop;
    end


endmodule 