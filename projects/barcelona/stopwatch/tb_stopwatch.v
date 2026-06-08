// =============================================================================
// tb_stopwatch.v — Testbench for the stopwatch FSM + BCD (Barcelona Project)
// =============================================================================
// TICK_DIV is tiny so a "second" is a few clocks. The active checks pass on the
// bare skeleton (reset only). UNCOMMENT the TODO scenarios once run/stop and the
// BCD carry work, and add your own (e.g. the 9→0 tens carry, the 99→00 wrap).
//
//   Run it:  make sim
// =============================================================================
`timescale 1ns / 1ps

module tb_stopwatch;

    reg        clk = 0, rst = 0, toggle = 0;
    wire       running;
    wire [3:0] tens, ones;

    localparam TICK = 4;     // clocks per "second" in simulation
    stopwatch #(.TICK_DIV(TICK)) uut (
        .i_clk(clk), .i_rst(rst), .i_run_toggle(toggle),
        .o_running(running), .o_tens(tens), .o_ones(ones)
    );

    always #20 clk = ~clk;

    integer tests = 0, fails = 0;
    task check_true;
        input [255:0] label;
        input         cond;
        begin
            tests = tests + 1;
            if (cond !== 1'b1) begin
                fails = fails + 1;
                $display("FAIL: %0s", label);
            end else
                $display("PASS: %0s", label);
        end
    endtask

    task pulse_toggle;
        begin @(negedge clk); toggle = 1'b1; @(negedge clk); toggle = 1'b0; end
    endtask

    initial begin
        $dumpfile("tb_stopwatch.vcd");
        $dumpvars(0, tb_stopwatch);

        // Reset
        rst = 1; @(negedge clk); @(negedge clk); rst = 0; @(negedge clk);

        // ---- Active checks: stopped at 00 after reset ----
        check_true("reset: stopped",     running === 1'b0);
        check_true("reset: tens == 0",   tens     == 4'd0);
        check_true("reset: ones == 0",   ones     == 4'd0);

        // ---- TODO: uncomment as you build the FSM + counter ----
        // // Start the clock and let several "seconds" elapse.
        // pulse_toggle;
        // check_true("toggle: running", running === 1'b1);
        // repeat (5 * TICK + 2) @(negedge clk);
        // check_true("after ~5 s: ones == 5", ones == 4'd5);
        // check_true("after ~5 s: tens == 0", tens == 4'd0);
        //
        // // Stop and confirm it holds.
        // pulse_toggle;
        // check_true("toggle: stopped", running === 1'b0);
        //
        // // TODO (your idea): run long enough to see the ones→tens carry
        // //                   (ones 9 → 0, tens 0 → 1) and the 99 → 00 wrap.

        $display("");
        $display("==== stopwatch: %0d/%0d checks passed ====", tests - fails, tests);
        if (fails == 0) $display("RESULT: PASS"); else $display("RESULT: FAIL");
        $finish;
    end
endmodule
