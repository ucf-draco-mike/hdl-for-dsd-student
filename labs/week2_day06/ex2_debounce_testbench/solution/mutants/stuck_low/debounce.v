// MUTANT: o_clean is forced low and never released. A correct testbench's
// "released" checks (expect o_clean==1) must catch this.
module debounce #( parameter CLKS_TO_STABLE = 250_000 )(
    input wire i_clk, input wire i_bouncy, output reg o_clean
);
    reg [$clog2(CLKS_TO_STABLE)-1:0] r_count  = 0;
    reg                              r_sync_0 = 1'b1;
    reg                              r_sync_1 = 1'b1;
    initial o_clean = 1'b0;   // BUG: powers up low and never changes
    always @(posedge i_clk) begin
        r_sync_0 <= i_bouncy;
        r_sync_1 <= r_sync_0;
        r_count  <= 0;        // BUG: o_clean never updated
    end
endmodule
