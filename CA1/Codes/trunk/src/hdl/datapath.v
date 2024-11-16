module datapath(
    input clk, 
    input count_enable, 
    input ld_a, 
    input ld_b, 
    input lzd_a_en, 
    input lzd_b_en, 
    input add_en, 
    input mul_en,
    input shift_a_en,
    input shift_b_en,
    input r_shift_en,
    input write_file, 
    input write_en,

    output co,
    output lzd_a_done, 
    output lzd_b_done, 
    output add_done, 
    output mul_done,
    output shift_a_done,
    output shift_b_done,
    output r_shift_done
);

    wire [2:0] count;
    wire [3:0] lzdAout, lzdBout;
    wire [15:0] A, B, Aout, Bout, mul_result;
    wire [4:0] totalLzdBit;
    wire [15:0] shift_a_out, shift_b_out;
    wire [31:0] r_shift_out;

    input_ram InpRam(
        .clk(clk), 
        .read_addr(count), 
        .outA(A), 
        .outB(B)
    );

    counter Counter(
        .clk(clk), 
        .count_enable(count_enable), 
        .count(count), 
        .co(co)
    );

    register #(.N(16)) Aregister(
        .clk(clk), 
        .ld(ld_a), 
        .in(A), 
        .out(Aout)
    );

    register #(.N(16)) Bregister(
        .clk(clk), 
        .ld(ld_b), 
        .in(B), 
        .out(Bout)
    );

    LZD lzdA(
        .clk(clk), 
        .en(lzd_a_en), 
        .in(A[15:8]), 
        .out(lzdAout), 
        .done(lzd_a_done)
    );

    LZD lzdB(
        .clk(clk), 
        .en(lzd_b_en), 
        .in(B[15:8]), 
        .out(lzdBout), 
        .done(lzd_b_done)
    );

    adder #(.N(4)) Adder(
        .clk(clk), 
        .en(add_en), 
        .done(add_done), 
        .inA(lzdAout), 
        .inB(lzdBout), 
        .out(totalLzdBit)
    );

    shifter #(.N(16), .shift_bits(4), .is_right_shifter(0)) Ashift(
        .clk(clk),
        .in(Aout),
        .en(shift_a_en),
        .done(shift_a_done),
        .shift_count(lzdAout),
        .out(shift_a_out)
    );

    shifter #(.N(16), .shift_bits(4), .is_right_shifter(0)) Bshift(
        .clk(clk),
        .in(Bout),
        .en(shift_b_en),
        .done(shift_b_done),
        .shift_count(lzdBout),
        .out(shift_b_out)
    );
   
    

    multiplier #(.N(8)) Multiplier(
        .clk(clk), 
        .en(mul_en), 
        .done(mul_done), 
        .inA(shift_a_out[15:8]), 
        .inB(shift_b_out[15:8]), 
        .out(mul_result)
    );

    // add 16 0s
    wire [31:0] mul_result_32bit = {mul_result, 16'b0};

    shifter #(.N(32), .shift_bits(5), .is_right_shifter(1)) Rshift(
        .clk(clk),
        .in(mul_result_32bit),
        .en(r_shift_en),
        .done(r_shift_done),
        .shift_count(totalLzdBit),
        .out(r_shift_out)
    );

    output_ram OutRam(
        .clk(clk), 
        .write_en(write_en), 
        .write_file(write_file), 
        .write_address(count), 
        .input_data(r_shift_out)
    );

endmodule

