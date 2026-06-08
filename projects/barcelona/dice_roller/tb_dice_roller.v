// =============================================================================
// tb_dice_roller.v — Testbench for the dice FSM (Barcelona Final Project)
// =============================================================================
// The active checks below pass on the bare skeleton (they only exercise the
// reset/settled behaviour). As you build the FSM, UNCOMMENT the TODO scenarios
// and add your own — "extend the testbench" is part of the assignment.
//
//   Run it:  make sim          (or: iverilog -g2012 -o sim.vvp *.v && vvp sim.vvp)
// =============================================================================
`timescale 1ns / 1ps

module tb_dice_roller;

    reg        clk = 0, rst = 0, roll = 0;
    wire [3:0] die1, die2;
    wire       rolling;

    dice_roller uut (
        .i_clk(clk), .i_rst(rst), .i_roll(roll),
        .o_die1(die1), .o_die2(die2), .o_rolling(rolling)
    );

    // 25 MHz-ish clock (40 ns period)
    always #20 clk = ~clk;

    // ───────────────────────────── scoreboard ─────────────────────────────
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

    // Helper: hold the roll button for n clocks, then release.
    task do_roll;
        input integer n;
        begin
            @(negedge clk); roll = 1'b1;
            repeat (n) @(negedge clk);
            roll = 1'b0;
            @(negedge clk);
        end
    endtask

    // ───────────────────────────── stimulus ───────────────────────────────
    initial begin
        $dumpfile("tb_dice_roller.vcd");
        $dumpvars(0, tb_dice_roller);

        // Reset
        rst = 1; @(negedge clk); @(negedge clk); rst = 0; @(negedge clk);

        // ---- Active checks: settled state right after reset ----
        check_true("reset: not rolling",         rolling === 1'b0);
        check_true("reset: die1 in range 1..6",  (die1 >= 4'd1) && (die1 <= 4'd6));
        check_true("reset: die2 in range 1..6",  (die2 >= 4'd1) && (die2 <= 4'd6));

        // ---- TODO: uncomment as you build the FSM ----
        // // Holding the button should enter the rolling state
        // @(negedge clk); roll = 1'b1; @(negedge clk); @(negedge clk);
        // check_true("button held: rolling",      rolling === 1'b1);
        // roll = 1'b0; @(negedge clk);
        // check_true("button released: settled",  rolling === 1'b0);
        //
        // // After a roll both dice must still show a legal face (1..6)
        // do_roll(20);
        // check_true("after roll: die1 1..6", (die1 >= 4'd1) && (die1 <= 4'd6));
        // check_true("after roll: die2 1..6", (die2 >= 4'd1) && (die2 <= 4'd6));
        //
        // // TODO (your idea): roll twice and check the values usually differ,
        // //                   or that the dice freeze when the button is up.

        $display("");
        $display("==== dice_roller: %0d/%0d checks passed ====", tests - fails, tests);
        if (fails == 0) $display("RESULT: PASS"); else $display("RESULT: FAIL");
        $finish;
    end
endmodule
