// =============================================================================
// tb_pattern_generator.v — Testbench for the LFSR pattern (Barcelona · STRETCH)
// =============================================================================
// STEP_DIV is tiny so the pattern advances quickly. Active checks pass on the
// bare skeleton (reset only). UNCOMMENT the TODO scenarios once run/pause and
// the LFSR step work, and add your own (e.g. the LFSR never gets stuck at 0).
//
//   Run it:  make sim
// =============================================================================
`timescale 1ns / 1ps

module tb_pattern_generator;

    reg        clk = 0, rst = 0, toggle = 0, step = 0;
    wire       running;
    wire [7:0] pattern;

    localparam SDIV = 4;
    pattern_generator #(.STEP_DIV(SDIV)) uut (
        .i_clk(clk), .i_rst(rst), .i_run_toggle(toggle), .i_step(step),
        .o_running(running), .o_pattern(pattern)
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

    task pulse_toggle; begin @(negedge clk); toggle = 1'b1; @(negedge clk); toggle = 1'b0; end endtask
    task pulse_step;   begin @(negedge clk); step   = 1'b1; @(negedge clk); step   = 1'b0; end endtask

    initial begin
        $dumpfile("tb_pattern_generator.vcd");
        $dumpvars(0, tb_pattern_generator);

        rst = 1; @(negedge clk); @(negedge clk); rst = 0; @(negedge clk);

        // ---- Active checks: paused at the seed after reset ----
        check_true("reset: paused",        running === 1'b0);
        check_true("reset: pattern == A5", pattern  == 8'hA5);

        // ---- TODO: uncomment as you build the FSM + LFSR ----
        // // A single step while paused changes the pattern.
        // pulse_step;
        // check_true("step: pattern advanced", pattern != 8'hA5);
        //
        // // Run it free for a while; it should keep changing (never stuck).
        // pulse_toggle;
        // check_true("toggle: running", running === 1'b1);
        // repeat (3 * SDIV) @(negedge clk);
        // check_true("running: pattern non-zero", pattern != 8'h00);
        // pulse_toggle;
        // check_true("toggle: paused", running === 1'b0);
        //
        // // TODO (your idea): confirm the LFSR is periodic / visits many values.

        $display("");
        $display("==== pattern_generator: %0d/%0d checks passed ====", tests - fails, tests);
        if (fails == 0) $display("RESULT: PASS"); else $display("RESULT: FAIL");
        $finish;
    end
endmodule
