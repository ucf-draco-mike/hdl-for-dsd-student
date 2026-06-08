// =============================================================================
// tb_tone_generator.v — Testbench for the tone sequencer (Barcelona · STRETCH)
// =============================================================================
// NOTE_DUR is tiny so notes advance quickly. Active checks pass on the bare
// skeleton (reset only). UNCOMMENT the TODO scenarios once play/stop and the
// note sequencer work. (The audio square wave is best verified on hardware —
// by ear — because its period is long; that is left as an extension.)
//
//   Run it:  make sim
// =============================================================================
`timescale 1ns / 1ps

module tb_tone_generator;

    reg        clk = 0, rst = 0, play = 0;
    wire       sound, playing;
    wire [3:0] note;

    localparam NDUR = 6;
    tone_generator #(.NOTE_DUR(NDUR)) uut (
        .i_clk(clk), .i_rst(rst), .i_play_toggle(play),
        .o_sound(sound), .o_playing(playing), .o_note(note)
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

    task pulse_play; begin @(negedge clk); play = 1'b1; @(negedge clk); play = 1'b0; end endtask

    initial begin
        $dumpfile("tb_tone_generator.vcd");
        $dumpvars(0, tb_tone_generator);

        rst = 1; @(negedge clk); @(negedge clk); rst = 0; @(negedge clk);

        // ---- Active checks: silent and stopped after reset ----
        check_true("reset: not playing", playing === 1'b0);
        check_true("reset: silent",      sound   === 1'b0);
        check_true("reset: note == 0",   note     == 4'd0);

        // ---- TODO: uncomment as you build the FSM + sequencer ----
        // // Start playback; the note index should advance over time.
        // pulse_play;
        // check_true("play: playing", playing === 1'b1);
        // repeat (NDUR + 2) @(negedge clk);
        // check_true("after one note duration: note == 1", note == 4'd1);
        // repeat (NDUR) @(negedge clk);
        // check_true("after two note durations: note == 2", note == 4'd2);
        //
        // // Stop playback; the output must fall silent.
        // pulse_play;
        // @(negedge clk);
        // check_true("stop: not playing", playing === 1'b0);
        // check_true("stop: silent",      sound   === 1'b0);

        $display("");
        $display("==== tone_generator: %0d/%0d checks passed ====", tests - fails, tests);
        if (fails == 0) $display("RESULT: PASS"); else $display("RESULT: FAIL");
        $finish;
    end
endmodule
