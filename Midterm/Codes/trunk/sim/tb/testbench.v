`timescale 1ps/1ps

module testbench;
    // Inputs
    reg clk;
    reg reset;
    reg [7:0] X_input;
    reg [2:0] N_input;
    reg start;

    // Outputs
    wire [31:0] result;
    wire calculation_done;
    wire overflow;
    wire ready;
    wire error;

    // Instantiate the top module
    maclauren dut (
        .clk(clk),
        .rst(reset),
        .start(start),
        .X(X_input),
        .N(N_input),
        .Y(result),
        .valid(calculation_done),  
        .ready(ready),
        .overflow(overflow),
        .error(error)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test stimulus
    initial begin
        reset = 1;
        start = 0;
        // X_input = 8'b0;
        // N_input = 3'b0;
        
        #100 reset = 0;
        #20;  // Wait for ready signal

        @(posedge clk) start = 1;
        @(posedge clk) start = 0;

        // Test case 1: X = 0.5, N = 5
        X_input = 8'b0100_0000;  // 0.5
        N_input = 3'b101;        // N = 5

        // Replace wait statements with fixed delays
        #100;  // Allow sufficient time for calculation

        // Test Case 2: x = 0.25
        X_input = 8'b0010_0000;  // 0.25 in fixed point
        N_input = 3'b101;

        // Replace wait statements with fixed delays
        #100;  // Allow sufficient time for calculation

        // Test case 3: X = -0.5
        X_input = 8'b1100_0000;  // -0.5
        N_input = 3'b101; 

        // Replace wait statements with fixed delays
        #100;  // Allow sufficient time for calculation

        $stop;
    end


endmodule
