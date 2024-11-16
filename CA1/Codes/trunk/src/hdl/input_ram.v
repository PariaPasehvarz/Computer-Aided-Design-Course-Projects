`timescale 1ps/1ps
module input_ram(
    input clk,
    input [2:0] read_addr,
    output reg [15:0] outA,
    output reg [15:0] outB
);


    reg [15:0] memory [15:0];

    initial begin
	$readmemb("./file/input.txt", memory); 

    end

    always @(posedge clk) begin
        outA <= memory[2 * read_addr];
        outB <= memory[2 * read_addr + 1];
    end

endmodule

