`timescale 1ps/1ps

module register #(parameter N = 16)(clk, rst, ld, in, out);
    input clk, rst, ld;
    input[N-1:0] in;
    output reg[N-1:0] out;

    always @(posedge clk) begin 
        if(rst) begin
            out <= {N{1'b0}};  
        end else if(ld) begin
            out <= in;
        end
    end

endmodule 