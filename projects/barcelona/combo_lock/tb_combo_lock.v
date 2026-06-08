// =============================================================================
// tb_combo_lock.v — Testbench for the combination-lock FSM (Barcelona Project)
// =============================================================================
// The active checks pass on the bare skeleton (reset behaviour only). As you
// build the FSM, UNCOMMENT the TODO scenarios and add more — extending this
// testbench is part of the assignment.
//
//   Run it:  make sim
// =============================================================================
`timescale 1ns / 1ps

module tb_combo_lock;

    reg        clk = 0, rst = 0;
    reg  [2:0] btn = 3'b000;
    wire       unlocked;
    wire [3:0] step, attempts;

    // DUT — secret code = SW1, SW3, SW2  (indices 0, 2, 1).
    combo_lock #(.CODE0(2'd0), .CODE1(2'd2), .CODE2(2'd1)) uut (
        .i_clk(clk), .i_rst(rst), .i_btn(btn),
        .o_unlocked(unlocked), .o_step(step), .o_attempts(attempts)
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

    // Press one code button (idx 0..2) for a single clock, then release.
    task press;
        input [1:0] idx;
        begin
            @(negedge clk); btn = (3'b001 << idx);
            @(negedge clk); btn = 3'b000;
            @(negedge clk);                    // idle gap between presses
        end
    endtask

    initial begin
        $dumpfile("tb_combo_lock.vcd");
        $dumpvars(0, tb_combo_lock);

        // Reset
        rst = 1; @(negedge clk); @(negedge clk); rst = 0; @(negedge clk);

        // ---- Active checks: locked and clear after reset ----
        check_true("reset: locked",        unlocked === 1'b0);
        check_true("reset: step == 0",     step      == 4'd0);
        check_true("reset: attempts == 0", attempts  == 4'd0);

        // ---- TODO: uncomment as you build the FSM ----
        // // Enter the correct code: SW1, SW3, SW2  →  indices 0, 2, 1
        // press(2'd0); check_true("digit 1 correct: step == 1", step == 4'd1);
        // press(2'd2); check_true("digit 2 correct: step == 2", step == 4'd2);
        // press(2'd1); check_true("digit 3 correct: UNLOCKED",  unlocked === 1'b1);
        //
        // // A reset re-locks the door
        // rst = 1; @(negedge clk); rst = 0; @(negedge clk);
        // check_true("after reset: locked again", unlocked === 1'b0);
        //
        // // A wrong first digit logs an attempt and stays at step 0
        // press(2'd1);                                   // expected index 0
        // check_true("wrong digit: attempts == 1", attempts == 4'd1);
        // check_true("wrong digit: step == 0",     step     == 4'd0);
        //
        // // TODO (your idea): wrong digit mid-sequence resets to start;
        // //                   re-entering the full code still unlocks.

        $display("");
        $display("==== combo_lock: %0d/%0d checks passed ====", tests - fails, tests);
        if (fails == 0) $display("RESULT: PASS"); else $display("RESULT: FAIL");
        $finish;
    end
endmodule
