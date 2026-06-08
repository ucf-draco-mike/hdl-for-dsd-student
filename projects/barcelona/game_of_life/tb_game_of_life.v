// =============================================================================
// tb_game_of_life.v — Testbench for the 1-D automaton (Barcelona · STRETCH)
// =============================================================================
// GEN_DIV is tiny so generations advance quickly. Active checks pass on the bare
// skeleton (reset only). UNCOMMENT the TODO scenarios once the rule, the
// generation counter, and run/pause work, and add your own.
//
//   Run it:  make sim
// =============================================================================
`timescale 1ns / 1ps

module tb_game_of_life;

    reg        clk = 0, rst = 0, toggle = 0, step = 0;
    wire       running;
    wire [7:0] cells, gen;

    localparam GDIV = 4;
    localparam [7:0] SEED = 8'h18;
    game_of_life #(.GEN_DIV(GDIV), .SEED(SEED), .RULE(8'd90)) uut (
        .i_clk(clk), .i_rst(rst), .i_run_toggle(toggle), .i_step(step),
        .o_running(running), .o_cells(cells), .o_gen(gen)
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
        $dumpfile("tb_game_of_life.vcd");
        $dumpvars(0, tb_game_of_life);

        rst = 1; @(negedge clk); @(negedge clk); rst = 0; @(negedge clk);

        // ---- Active checks: seeded and paused after reset ----
        check_true("reset: paused",       running === 1'b0);
        check_true("reset: cells == SEED", cells   == SEED);
        check_true("reset: gen == 0",      gen     == 8'd0);

        // ---- TODO: uncomment as you build the rule + counter + FSM ----
        // // One single step evolves the row and bumps the generation count.
        // pulse_step;
        // check_true("step: gen == 1",      gen   == 8'd1);
        // check_true("step: row evolved",   cells != SEED);
        //
        // // Free-run a few generations.
        // pulse_toggle;
        // check_true("toggle: running", running === 1'b1);
        // repeat (3 * GDIV) @(negedge clk);
        // check_true("running: gen advanced past 1", gen > 8'd1);
        // pulse_toggle;
        // check_true("toggle: paused", running === 1'b0);
        //
        // // TODO (your idea): with RULE 90 a single live cell makes a Sierpinski
        // //                   pattern — seed 0x10 and watch the row over time.

        $display("");
        $display("==== game_of_life: %0d/%0d checks passed ====", tests - fails, tests);
        if (fails == 0) $display("RESULT: PASS"); else $display("RESULT: FAIL");
        $finish;
    end
endmodule
