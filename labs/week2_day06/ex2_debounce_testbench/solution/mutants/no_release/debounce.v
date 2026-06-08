// MUTANT: o_clean can fall (press) but never rises again (release is broken).
// A correct testbench's "clean release" check (expect o_clean==1) must catch this.
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
            if (r_count == CLKS_TO_STABLE - 1) begin
                if (o_clean == 1'b1) o_clean <= r_sync_1;  // BUG: only falls, never rises
                r_count <= 0;
            end
        end else r_count <= 0;
    end
endmodule
