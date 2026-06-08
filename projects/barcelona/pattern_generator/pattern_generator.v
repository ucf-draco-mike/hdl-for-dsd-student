// =============================================================================
// pattern_generator.v — LFSR Light Pattern (Barcelona · STRETCH CORE)
// =============================================================================
// WHAT YOU BUILD:
//   A run/pause FSM driving an 8-bit LFSR. The pattern marches across the LEDs
//   and shows as two hex digits; you can single-step it while paused.
//
//   Skill targets:  [FSM] [sequential logic] [combinational logic]
//
// PROVIDED: the speed divider and the "advance" select.
// YOUR WORK: the run/pause next-state logic and the LFSR step. Search "TODO".
// =============================================================================
module pattern_generator #(
    parameter integer STEP_DIV = 6_250_000      // clocks per pattern step (sim overrides)
)(
    input  wire       i_clk,
    input  wire       i_rst,
    input  wire       i_run_toggle,   // 1-cycle pulse: run ↔ pause
    input  wire       i_step,         // 1-cycle pulse: single step while paused
    output reg        o_running,
    output reg  [7:0] o_pattern       // 8-bit light pattern (two hex digits)
);

    // ───────────────────────── FSM state encoding ─────────────────────────
    localparam S_PAUSE = 1'b0;
    localparam S_RUN   = 1'b1;
    reg r_state, r_next;

    // ──────────────────── Speed divider (SEQUENTIAL) ──────────────────────
    reg [$clog2(STEP_DIV)-1:0] r_div;
    wire w_div_tick = (r_div == STEP_DIV - 1);
    always @(posedge i_clk) begin
        if (i_rst || !o_running || w_div_tick) r_div <= 0;
        else                                   r_div <= r_div + 1'b1;
    end

    // Advance the pattern automatically while running, or by button while paused.
    wire w_adv = o_running ? w_div_tick : i_step;

    // ──────────────── Run/pause next-state (COMBINATIONAL) — TODO ──────────
    always @(*) begin
        r_next = r_state;
        case (r_state)
            S_PAUSE: begin
                // ---- TODO: a toggle press starts the march ----
                // if (i_run_toggle) r_next = S_RUN;
            end
            S_RUN: begin
                // ---- TODO: a toggle press pauses ----
                // if (i_run_toggle) r_next = S_PAUSE;
            end
            default: r_next = S_PAUSE;
        endcase
    end

    always @(posedge i_clk) if (i_rst) r_state <= S_PAUSE; else r_state <= r_next;
    always @(*) o_running = (r_state == S_RUN);

    // ─────────────────── 8-bit LFSR pattern (SEQUENTIAL) — TODO ────────────
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_pattern <= 8'hA5;          // non-zero seed
        end else if (w_adv) begin
            // ---- TODO: one Fibonacci-LFSR step (taps 7,5,4,3 → x^8+x^6+x^5+x^4+1) ----
            // o_pattern <= {o_pattern[6:0],
            //               o_pattern[7] ^ o_pattern[5] ^ o_pattern[4] ^ o_pattern[3]};
        end
    end

endmodule
