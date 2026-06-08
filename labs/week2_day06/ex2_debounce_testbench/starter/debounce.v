// =============================================================================
// debounce.v — Counter-Based Button Debouncer (Solution)
// Day 5, Exercise 1
// =============================================================================

module debounce #(
    parameter CLKS_TO_STABLE = 250_000
)(
    input  wire i_clk,
    input  wire i_bouncy,
    output reg  o_clean
);

    // Power-on state. The iCE40 global set/reset (GSR) loads these initial
    // values into the flip-flops at configuration, so the debouncer starts in
    // a defined "released" state (o_clean = 1) instead of X. This also makes
    // simulation deterministic — without it, o_clean stays X forever because
    // the (r_sync_1 != o_clean) compare is X and never resolves.
    reg [$clog2(CLKS_TO_STABLE)-1:0] r_count  = 0;
    reg                              r_sync_0 = 1'b1;
    reg                              r_sync_1 = 1'b1;

    initial o_clean = 1'b1;

    always @(posedge i_clk) begin
        // 2-FF synchronizer
        r_sync_0 <= i_bouncy;
        r_sync_1 <= r_sync_0;

        // Debounce logic
        if (r_sync_1 != o_clean) begin
            r_count <= r_count + 1;
            if (r_count == CLKS_TO_STABLE - 1) begin
                o_clean <= r_sync_1;
                r_count <= 0;
            end
        end else begin
            r_count <= 0;
        end
    end

endmodule
