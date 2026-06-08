// MUTANT: debounce threshold is effectively ~2 cycles regardless of
// CLKS_TO_STABLE, so a sub-threshold glitch leaks through. A testbench that
// checks o_clean stays stable DURING a short glitch must catch this.
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
            if (r_count == 1) begin           // BUG: fires after ~2 clocks, not CLKS_TO_STABLE
                o_clean <= r_sync_1;
                r_count <= 0;
            end
        end else r_count <= 0;
    end
endmodule
