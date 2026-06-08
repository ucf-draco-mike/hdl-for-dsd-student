// MUTANT: counts regardless of i_enable.
module counter_4bit (input wire i_clk, input wire i_reset, input wire i_enable,
                     output reg [3:0] o_count, output wire o_zero);
    always @(posedge i_clk) if (i_reset) o_count <= 4'd0; else o_count <= o_count + 4'd1; // BUG: ignores enable
    assign o_zero = (o_count == 4'd0);
endmodule
