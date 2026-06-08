// =============================================================================
// tb_digital_clock.v — Testbench for the seconds clock (Barcelona · STRETCH)
// =============================================================================
// TICK_DIV is tiny so a "second" is a few clocks. Active checks pass on the bare
// skeleton (reset only). UNCOMMENT the TODO scenarios once mode-toggle and the
// 00..59 carry work, and add your own (e.g. the 59 → 00 wrap).
//
//   Run it:  make sim
// =============================================================================
`timescale 1ns / 1ps

module tb_digital_clock;

    reg        clk = 0, rst = 0, mode = 0, inc = 0;
    wire       setting;
    wire [3:0] tens, ones;

    localparam TICK = 4;
    digital_clock #(.TICK_DIV(TICK)) uut (
        .i_clk(clk), .i_rst(rst), .i_mode(mode), .i_inc(inc),
        .o_setting(setting), .o_tens(tens), .o_ones(ones)
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

    task pulse_mode; begin @(negedge clk); mode = 1'b1; @(negedge clk); mode = 1'b0; end endtask
    task pulse_inc;  begin @(negedge clk); inc  = 1'b1; @(negedge clk); inc  = 1'b0; end endtask

    initial begin
        $dumpfile("tb_digital_clock.vcd");
        $dumpvars(0, tb_digital_clock);

        rst = 1; @(negedge clk); @(negedge clk); rst = 0; @(negedge clk);

        // ---- Active checks: running at 00 after reset ----
        check_true("reset: not setting", setting === 1'b0);
        check_true("reset: tens == 0",   tens     == 4'd0);
        check_true("reset: ones == 0",   ones     == 4'd0);

        // ---- TODO: uncomment as you build the FSM + counter ----
        // // Enter SET mode and bump the seconds three times.
        // pulse_mode;
        // check_true("mode press: setting", setting === 1'b1);
        // pulse_inc; pulse_inc; pulse_inc;
        // check_true("after 3 inc: ones == 3", ones == 4'd3);
        //
        // // Back to RUN; let several seconds tick.
        // pulse_mode;
        // check_true("mode press: running", setting === 1'b0);
        // repeat (4 * TICK + 2) @(negedge clk);
        // check_true("ran ~4 s from 3: ones == 7", ones == 4'd7);
        //
        // // TODO (your idea): drive ones past 9 to see the tens carry, and
        // //                   past 59 to see the wrap back to 00.

        $display("");
        $display("==== digital_clock: %0d/%0d checks passed ====", tests - fails, tests);
        if (fails == 0) $display("RESULT: PASS"); else $display("RESULT: FAIL");
        $finish;
    end
endmodule
