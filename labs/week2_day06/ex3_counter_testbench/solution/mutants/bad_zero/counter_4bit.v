// MUTANT: o_zero stuck low.
module counter_4bit (input wire i_clk, input wire i_reset, input wire i_enable,
                     output reg [3:0] o_count, output wire o_zero);
    always @(posedge i_clk) if (i_reset) o_count <= 4'd0; else if (i_enable) o_count <= o_count + 4'd1;
    assign o_zero = 1'b0;  // BUG
endmodule
