`timescale 1ps/1ps
module controller(
    input clk, 
    input rst, 
    input start, 
    input lzd_a_done, 
    input lzd_b_done, 
    input add_done,
    input multiply_done,
    input left_shift_a_done, 
    input left_shift_b_done,
    input r_shift_done, 
    input co,
    
    output reg ld_a, 
    output reg ld_b, 
    output reg lzd_a_en, 
    output reg lzd_b_en, 
    output reg add_en, 
    output reg l_shift_a_en, 
    output reg l_shift_b_en,
    output reg mul_en, 
    output reg r_shift_en, 
    output reg write_en, 
    output reg count_enable, 
    output reg done, 
    output reg write_file
);

    reg [3:0] ps, ns;

    parameter [3:0]
        Idle             = 4'd0,
        WaitingForStart  = 4'd1,
        Init             = 4'd2,
        LZD              = 4'd3,
        LeftShftAdd      = 4'd4,
        Multiply         = 4'd6,
        StoreInShiftReg  = 4'd7,
        Write            = 4'd8,
        WriteDone        = 4'd9,
        Increment        = 4'd10,
        WriteFile        = 4'd11,
        EnDoneSig        = 4'd12,
        DisDoneSig       = 4'd13;

    always @(*) begin
        case(ps)
            Idle: 
                ns = (start) ? WaitingForStart : Idle;
            WaitingForStart:
                ns = (start) ? WaitingForStart : Init;
            Init:
                ns = LZD;
            LZD:
                ns = (lzd_a_done & lzd_b_done) ? LeftShftAdd : LZD;
            LeftShftAdd:
                ns = (add_done & left_shift_a_done & left_shift_b_done) ? Multiply : LeftShftAdd;
            Multiply:
                ns = (multiply_done) ? StoreInShiftReg : Multiply;
            StoreInShiftReg:
                ns = (r_shift_done) ? Write : StoreInShiftReg;
            Write:
                ns = WriteDone;
            WriteDone:
                ns = Increment;
            Increment:
                ns = (co) ? WriteFile : Init;
            WriteFile:
                ns = EnDoneSig;
            EnDoneSig:
                ns = DisDoneSig;
            default:
                ns = Idle;
        endcase
    end

    always @(*) begin
        ns = Idle;
        {ld_a, ld_b, lzd_a_en, lzd_b_en, add_en, l_shift_a_en, l_shift_b_en, mul_en, r_shift_en, 
        write_en, count_enable, done, write_file} = 0;
        $display("current state:", ps);
        case (ps)
            Init: begin
                ld_a = 1;
                ld_b = 1;
            end
            LZD: begin
                lzd_a_en = 1;
                lzd_b_en = 1;
            end
            LeftShftAdd: begin
                add_en = 1;
                l_shift_a_en = 1;
                l_shift_b_en = 1;
            end
            Multiply:
                mul_en = 1;
            StoreInShiftReg:
                r_shift_en = 1;
            Write:
                write_en = 1;
            WriteFile:
                write_file = 1;
            WriteDone:
                count_enable = 1;
            EnDoneSig:
                done = 1;
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if (rst == 1'b1)
            ps <= Idle;
        else
            ps <= ns;
    end
endmodule

