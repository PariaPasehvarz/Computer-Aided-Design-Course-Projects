`timescale 1ps/1ps

module sixteen_bit_register_tb();

    reg clk;
    reg ld;
    reg [15:0] in;
    wire [15:0] out;

    sixteen_bit_register dut (
        .clk(clk),
        .ld(ld),
        .rst(1'b0),
        .in(in),
        .out(out)
    );
    

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    

    initial begin
        ld = 0;
        in = 0;
        #20;
        
        in = 16'hAAAA;
        ld = 1;
        #20;
        
        $stop;
    end

    
endmodule