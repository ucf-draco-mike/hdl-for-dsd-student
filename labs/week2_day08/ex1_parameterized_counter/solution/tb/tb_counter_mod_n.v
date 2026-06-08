// =============================================================================
// tb_counter_mod_n.v -- Parameterized Counter Testbench (Solution)
// Day 8, Exercise 1
// =============================================================================

`timescale 1ns / 1ps

module tb_counter_mod_n;

    reg clk, reset, enable;

    wire [3:0] count_10; wire wrap_10;
    counter_mod_n #(.N(10)) uut_10 (
        .i_clk(clk), .i_reset(reset), .i_enable(enable),
        .o_count(count_10), .o_wrap(wrap_10));

    wire [3:0] count_16; wire wrap_16;
    counter_mod_n #(.N(16)) uut_16 (
        .i_clk(clk), .i_reset(reset), .i_enable(enable),
        .o_count(count_16), .o_wrap(wrap_16));

    wire [5:0] count_60; wire wrap_60;
    counter_mod_n #(.N(60)) uut_60 (
        .i_clk(clk), .i_reset(reset), .i_enable(enable),
        .o_count(count_60), .o_wrap(wrap_60));

    initial clk = 0;
    always #20 clk = ~clk;

    integer test_count = 0, fail_count = 0;

    task check_val;
        input [31:0] actual, expected;
        input [80*8-1:0] label;
    begin
        test_count = test_count + 1;
        if (actual !== expected) begin
            fail_count = fail_count + 1;
            $display("FAIL: %0s -- expected %0d, got %0d", label, expected, actual);
        end else
            $display("PASS: %0s = %0d", label, actual);
    end
    endtask

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_counter_mod_n);

        // Stimulus rule: change reset/enable one tick (#1) AFTER a clock edge,
        // never on the edge itself, so the DUT samples the intended values
        // instead of racing the testbench assignment.

        // ---- Reset: hold for 3 edges, all counters should be 0 ----
        reset = 1; enable = 1;
        repeat (3) @(posedge clk); #1;
        check_val(count_10, 0, "N=10 after reset");
        check_val(count_16, 0, "N=16 after reset");
        check_val(count_60, 0, "N=60 after reset");
        reset = 0;                       // deassert just after the edge

        // ---- N=10: count up to max, assert wrap, then wrap to 0 ----
        repeat (9) @(posedge clk); #1;
        check_val(count_10, 9, "N=10 at max");
        check_val(wrap_10, 1, "N=10 wrap asserted");
        @(posedge clk); #1;
        check_val(count_10, 0, "N=10 after wrap");

        // ---- N=16: re-reset, count to max, wrap ----
        reset = 1; @(posedge clk); #1; reset = 0;
        repeat (15) @(posedge clk); #1;
        check_val(count_16, 15, "N=16 at max");
        check_val(wrap_16, 1, "N=16 wrap asserted");
        @(posedge clk); #1;
        check_val(count_16, 0, "N=16 after wrap");

        // ---- Enable hold: count N=10 to 5, disable, confirm it holds ----
        reset = 1; @(posedge clk); #1; reset = 0;
        repeat (5) @(posedge clk); #1;
        check_val(count_10, 5, "N=10 counted to 5");
        enable = 0;
        repeat (4) @(posedge clk); #1;
        check_val(count_10, 5, "N=10 held during disable");
        enable = 1;

        // ---- N=60: re-reset, count to max, wrap ----
        reset = 1; @(posedge clk); #1; reset = 0;
        repeat (59) @(posedge clk); #1;
        check_val(count_60, 59, "N=60 at max");
        check_val(wrap_60, 1, "N=60 wrap asserted");
        @(posedge clk); #1;
        check_val(count_60, 0, "N=60 after wrap");

        $display("");
        $display("========================================");
        $display("Counter tests: %0d / %0d passed",
                 test_count - fail_count, test_count);
        if (fail_count == 0) $display("  All tests passed!");
        $display("========================================");
        $finish;
    end

endmodule
