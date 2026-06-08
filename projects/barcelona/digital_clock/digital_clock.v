// =============================================================================
// digital_clock.v — Seconds Clock 00..59 with Set Mode (Barcelona · STRETCH CORE)
// =============================================================================
// WHAT YOU BUILD:
//   A mode FSM (RUN ↔ SET) plus a 00..59 BCD seconds counter. While running it
//   ticks once per second; in SET mode a button bumps the seconds.
//
//   Skill targets:  [FSM] [sequential logic] [combinational logic]
//
// PROVIDED: the 1 Hz divider and the "advance one second" select.
// YOUR WORK: the mode next-state logic and the 00..59 BCD carry. Search "TODO".
// =============================================================================
module digital_clock #(
    parameter integer TICK_DIV = 25_000_000     // clocks per second (sim overrides)
)(
    input  wire       i_clk,
    input  wire       i_rst,
    input  wire       i_mode,        // 1-cycle pulse: toggle RUN ↔ SET
    input  wire       i_inc,         // 1-cycle pulse: +1 second (SET mode only)
    output reg        o_setting,     // 1 while in SET mode
    output reg  [3:0] o_tens,        // seconds tens digit (0..5)
    output reg  [3:0] o_ones         // seconds ones digit (0..9)
);

    // ───────────────────────── FSM state encoding ─────────────────────────
    localparam S_RUN = 1'b0;
    localparam S_SET = 1'b1;
    reg r_state, r_next;

    // ─────────────────── 1 Hz tick divider (SEQUENTIAL) ────────────────────
    // Timekeeping pauses while you are setting the clock, so it resumes from a
    // whole second when you return to RUN.
    reg [$clog2(TICK_DIV)-1:0] r_div;
    wire w_tick = (r_div == TICK_DIV - 1);
    always @(posedge i_clk) begin
        if (i_rst || o_setting || w_tick) r_div <= 0;
        else                              r_div <= r_div + 1'b1;
    end

    // Advance one second from real time while running, or from the button in SET.
    wire w_step = o_setting ? i_inc : w_tick;

    // ──────────────── Mode next-state logic (COMBINATIONAL) — TODO ─────────
    always @(*) begin
        r_next = r_state;
        case (r_state)
            S_RUN: begin
                // ---- TODO: a mode press enters SET ----
                // if (i_mode) r_next = S_SET;
            end
            S_SET: begin
                // ---- TODO: a mode press returns to RUN ----
                // if (i_mode) r_next = S_RUN;
            end
            default: r_next = S_RUN;
        endcase
    end

    always @(posedge i_clk) if (i_rst) r_state <= S_RUN; else r_state <= r_next;
    always @(*) o_setting = (r_state == S_SET);

    // ─────────────── 00..59 BCD seconds counter (SEQUENTIAL) — TODO ────────
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_ones <= 4'd0;
            o_tens <= 4'd0;
        end else if (w_step) begin
            // ---- TODO: ones 0..9; on 9 wrap and carry tens; on 59 wrap to 00 ----
            // if (o_ones == 4'd9) begin
            //     o_ones <= 4'd0;
            //     o_tens <= (o_tens == 4'd5) ? 4'd0 : o_tens + 4'd1;
            // end else begin
            //     o_ones <= o_ones + 4'd1;
            // end
        end
    end

endmodule
