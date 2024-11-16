`timescale 1ps/1ps
module counter(
    input clk,
    input count_enable,
    output reg [2:0] count,
    output reg co
);

    initial begin
        count = 3'd0;
        co = 0;
    end

    always @(posedge clk) begin
        if (count_enable) begin
            if (count == 3'b111) begin
                count <= 3'b000; 
                co <= 1;
            end else begin
                count <= count + 1;
                co <= 0;
            end
        end
    end

endmodule
