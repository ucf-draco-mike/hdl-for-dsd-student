// MUTANT: o_clean is never updated, so it stays stuck at its idle level (1).
// A correct testbench's "clean press" check (expect o_clean==0) must catch this.
module debounce #( parameter CLKS_TO_STABLE = 250_000 )(
    input wire i_clk, input wire i_bouncy, output reg o_clean
);
    reg [$clog2(CLKS_TO_STABLE)-1:0] r_count  = 0;
    reg                              r_sync_0 = 1'b1;
    reg                              r_sync_1 = 1'b1;
    initial o_clean = 1'b1;
    always @(posedge i_clk) begin
        r_sync_0 <= i_bouncy;
        r_sync_1 <= r_sync_0;
        if (r_sync_1 != o_clean) begin
            r_count <= r_count + 1;
            if (r_count == CLKS_TO_STABLE - 1) r_count <= 0;  // BUG: forgot o_clean <= r_sync_1
        end else r_count <= 0;
    end
endmodule
