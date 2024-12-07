`timescale 1ps/1ps

module right_shifter_tb();
    reg clk;
    reg ld;
    reg shift_enable;
    reg [15:0] in;
    wire [15:0] out;
    
    right_shifter dut (
        .clk(clk),
        .ld(ld),
        .rst(1'b0),
        .shift_enable(shift_enable),
        .in(in),
        .out(out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        ld = 0;
        shift_enable = 0;
        in = 0;
        
        #100;
        
        in = 16'b1011101110101010;
        ld = 1;
        shift_enable = 0;
        #10;
        ld = 0;
        
        $display("Time=%0t Loaded value: %b", $time, out);
        
        repeat(3) begin
            #10;
            shift_enable = 1;
            #10;
            shift_enable = 0;
            $display("Time=%0t After shift: %b", $time, out);
        end
        
        #10;
        in = 16'b1111000011110000;
        ld = 1;
        #10;
        ld = 0;
        $display("Time=%0t Loaded new value: %b", $time, out);
        
        #10;
        shift_enable = 1;
        #10;
        shift_enable = 0;
        $display("Time=%0t After shift: %b", $time, out);
        
        #100;
        $stop;
    end

endmodule 