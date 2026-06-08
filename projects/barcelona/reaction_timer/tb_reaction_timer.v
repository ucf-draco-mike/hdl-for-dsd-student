// =============================================================================
// tb_reaction_timer.v — Testbench for the reaction-timer FSM (Barcelona Project)
// =============================================================================
// Parameters are shrunk so the random wait resolves in a few hundred cycles.
// The active checks pass on the bare skeleton (reset only). UNCOMMENT the TODO
// scenarios once your FSM advances IDLE → WAIT → GO → DONE, and add your own.
//
//   Run it:  make sim
// =============================================================================
`timescale 1ns / 1ps

module tb_reaction_timer;

    reg        clk = 0, rst = 0, arm = 0, react = 0;
    wire       light, foul;
    wire [7:0] value;

    // Tiny timing so the round resolves quickly in simulation.
    reaction_timer #(.CS_DIV(4), .WAIT_LEN(8), .RAND_SHIFT(0)) uut (
        .i_clk(clk), .i_rst(rst), .i_arm(arm), .i_react(react),
        .o_light(light), .o_foul(foul), .o_value(value)
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

    // Single-cycle pulse helpers.
    task pulse_arm;   begin @(negedge clk); arm   = 1'b1; @(negedge clk); arm   = 1'b0; end endtask
    task pulse_react; begin @(negedge clk); react = 1'b1; @(negedge clk); react = 1'b0; end endtask

    // Wait until the stimulus LED turns on (with a safety timeout).
    integer guard;
    task wait_for_light;
        begin
            guard = 0;
            while (light !== 1'b1 && guard < 5000) begin
                @(negedge clk); guard = guard + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("tb_reaction_timer.vcd");
        $dumpvars(0, tb_reaction_timer);

        // Reset
        rst = 1; @(negedge clk); @(negedge clk); rst = 0; @(negedge clk);

        // ---- Active checks: idle/reset state ----
        check_true("reset: light off",   light === 1'b0);
        check_true("reset: no foul",     foul  === 1'b0);
        check_true("reset: value == 0",  value  == 8'd0);

        // ---- TODO: uncomment as you build the FSM ----
        // // Arm a round, wait for the stimulus, react, expect a finite time.
        // pulse_arm;
        // wait_for_light;
        // check_true("round armed: stimulus lit", light === 1'b1);
        // repeat (12) @(negedge clk);          // "human" reaction delay
        // pulse_react;
        // @(negedge clk);
        // check_true("after react: stimulus off", light === 1'b0);
        // check_true("after react: time recorded", value != 8'd0);
        //
        // // Pressing during the WAIT window is a FOUL.
        // pulse_arm;                            // back to IDLE then WAIT
        // pulse_arm;
        // @(negedge clk);
        // pulse_react;                          // early!
        // @(negedge clk);
        // check_true("early press: FOUL", foul === 1'b1);

        $display("");
        $display("==== reaction_timer: %0d/%0d checks passed ====", tests - fails, tests);
        if (fails == 0) $display("RESULT: PASS"); else $display("RESULT: FAIL");
        $finish;
    end
endmodule
