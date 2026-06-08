// =============================================================================
// tone_generator.v — 8-Note Melody Sequencer (Barcelona · STRETCH CORE)
// =============================================================================
// WHAT YOU BUILD:
//   A play/stop FSM that steps through an 8-note sequence, generating a square
//   wave whose frequency is set by a per-note divisor lookup.
//
//   Skill targets:  [FSM] [sequential logic] [combinational logic]
//
// PROVIDED: the square-wave generator and the per-note duration timer.
// YOUR WORK: the note→divisor LUT (combinational), the note sequencer
//   (sequential), and the play/stop next-state. Search "TODO".
// =============================================================================
module tone_generator #(
    parameter integer NOTE_DUR = 6_250_000      // clocks per note (~0.25 s; sim overrides)
)(
    input  wire       i_clk,
    input  wire       i_rst,
    input  wire       i_play_toggle,  // 1-cycle pulse: play ↔ stop
    output reg        o_sound,        // square-wave output (to speaker / PMOD)
    output reg        o_playing,
    output reg  [3:0] o_note          // current note index 0..7 (for display)
);

    // ───────────────────────── FSM state encoding ─────────────────────────
    localparam S_STOP = 1'b0;
    localparam S_PLAY = 1'b1;
    reg r_state, r_next;

    // ─────────── Note → half-period in clocks (COMBINATIONAL LUT) — TODO ───
    // half = CLK_FREQ / (2 * note_freq). At 25 MHz, C4 (262 Hz) ≈ 47710.
    reg [15:0] w_half;
    always @(*) begin
        case (o_note)
            // ---- TODO: fill an 8-note scale (C-major shown as a hint) ----
            // 4'd0: w_half = 16'd47710;  // C4  262 Hz
            // 4'd1: w_half = 16'd42526;  // D4  294 Hz
            // 4'd2: w_half = 16'd37880;  // E4  330 Hz
            // 4'd3: w_half = 16'd35740;  // F4  349 Hz
            // 4'd4: w_half = 16'd31888;  // G4  392 Hz
            // 4'd5: w_half = 16'd28409;  // A4  440 Hz
            // 4'd6: w_half = 16'd25309;  // B4  494 Hz
            // 4'd7: w_half = 16'd23855;  // C5  524 Hz
            default: w_half = 16'd47710;
        endcase
    end

    // ──────────── Square-wave generator (SEQUENTIAL, provided) ─────────────
    reg [15:0] r_tone;
    always @(posedge i_clk) begin
        if (i_rst || !o_playing) begin
            r_tone  <= 16'd0;
            o_sound <= 1'b0;
        end else if (r_tone >= w_half) begin
            r_tone  <= 16'd0;
            o_sound <= ~o_sound;       // flip every half-period → square wave
        end else begin
            r_tone  <= r_tone + 1'b1;
        end
    end

    // ──────────── Per-note duration timer (SEQUENTIAL, provided) ───────────
    reg [$clog2(NOTE_DUR)-1:0] r_dur;
    wire w_note_tick = (r_dur == NOTE_DUR - 1);
    always @(posedge i_clk) begin
        if (i_rst || !o_playing || w_note_tick) r_dur <= 0;
        else                                    r_dur <= r_dur + 1'b1;
    end

    // ──────────────────── Note sequencer (SEQUENTIAL) — TODO ───────────────
    always @(posedge i_clk) begin
        if (i_rst) o_note <= 4'd0;
        else if (o_playing && w_note_tick) begin
            // ---- TODO: advance to the next note, wrapping 7 → 0 ----
            // o_note <= (o_note == 4'd7) ? 4'd0 : o_note + 4'd1;
        end
    end

    // ──────────── Play/stop next-state (COMBINATIONAL) — TODO ──────────────
    always @(*) begin
        r_next = r_state;
        case (r_state)
            S_STOP: begin
                // ---- TODO: a toggle press starts playback ----
                // if (i_play_toggle) r_next = S_PLAY;
            end
            S_PLAY: begin
                // ---- TODO: a toggle press stops playback ----
                // if (i_play_toggle) r_next = S_STOP;
            end
            default: r_next = S_STOP;
        endcase
    end

    always @(posedge i_clk) if (i_rst) r_state <= S_STOP; else r_state <= r_next;
    always @(*) o_playing = (r_state == S_PLAY);

endmodule
