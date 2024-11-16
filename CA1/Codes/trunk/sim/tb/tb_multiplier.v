`timescale 1ps/1ps
module tb_multiplier;

    reg clk;
    reg en;
    reg [7:0] inA, inB;
    wire [15:0] out;
    wire done;

    multiplier #(8) mult (
        .clk(clk),
        .en(en),
        .inA(inA),
        .inB(inB),
        .out(out),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        en = 0;
        inA = 8'b00000000;
        inB = 8'b00000000;

        // 5*10=50
        #10 en = 1; inA = 8'd5; inB = 8'd10;
        #10 $display("inA = %d, inB = %d, Computed Output = %d, Expected Output = 50", inA, inB, out);
        en = 0;

        //48*55=2640
        #10 en = 1; inA = 8'd48; inB = 8'd55;
        #10 $display("inA = %d, inB = %d, Computed Output = %d, Expected Output = 2640", inA, inB, out);
        en = 0;

        #50 $stop;
    end
endmodule
