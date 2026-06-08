// =============================================================================
// stopwatch.v — Two-Digit Stopwatch 00..99 s (Barcelona Final Project · CORE)
// =============================================================================
// WHAT YOU BUILD:
//   A start/stop FSM driving a two-digit BCD seconds counter (00..99).
//   One button toggles run/stop; reset clears to 00.
//
//   Skill targets:  [FSM] [sequential logic] [combinational logic]
//
// PROVIDED: a 1 Hz tick divider (TICK_DIV is tiny in simulation).
// YOUR WORK: the run/stop next-state logic and the BCD carry. Search "TODO".
// =============================================================================
module stopwatch #(
    parameter integer TICK_DIV = 25_000_000     // clocks per second (sim overrides)
)(
    input  wire       i_clk,
    input  wire       i_rst,          // synchronous reset → clears to 00, stops
    input  wire       i_run_toggle,   // 1-cycle pulse: start ↔ stop
    output reg        o_running,      // 1 while counting
    output reg  [3:0] o_tens,         // seconds tens digit (0..9)
    output reg  [3:0] o_ones          // seconds ones digit (0..9)
);

    // ───────────────────────── FSM state encoding ─────────────────────────
    localparam S_STOP = 1'b0;
    localparam S_RUN  = 1'b1;
    reg r_state, r_next;

    // ─────────────────── 1 Hz tick divider (SEQUENTIAL) ────────────────────
    // Counts only while running; cleared while stopped so a fresh run starts
    // a whole second later.
    reg [$clog2(TICK_DIV)-1:0] r_div;
    wire w_tick = (r_div == TICK_DIV - 1);
    always @(posedge i_clk) begin
        if (i_rst || !o_running) r_div <= 0;
        else if (w_tick)         r_div <= 0;
        else                     r_div <= r_div + 1'b1;
    end

    // ─────────────── Run/stop next-state logic (COMBINATIONAL) — TODO ──────
    always @(*) begin
        r_next = r_state;
        case (r_state)
            S_STOP: begin
                // ---- TODO: a toggle press starts the clock ----
                // if (i_run_toggle) r_next = S_RUN;
            end
            S_RUN: begin
                // ---- TODO: a toggle press stops the clock ----
                // if (i_run_toggle) r_next = S_STOP;
            end
            default: r_next = S_STOP;
        endcase
    end

    // ───────────────────── State register (SEQUENTIAL) ─────────────────────
    always @(posedge i_clk) begin
        if (i_rst) r_state <= S_STOP;
        else       r_state <= r_next;
    end
    always @(*) o_running = (r_state == S_RUN);

    // ───────────── Two-digit BCD seconds counter (SEQUENTIAL) — TODO ───────
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_ones <= 4'd0;
            o_tens <= 4'd0;
        end else if (o_running && w_tick) begin
            // ---- TODO: count ones 0..9; on 9 wrap to 0 and carry the tens;
            //            on 99 wrap back to 00. (combinational carry below)
            // if (o_ones == 4'd9) begin
            //     o_ones <= 4'd0;
            //     o_tens <= (o_tens == 4'd9) ? 4'd0 : o_tens + 4'd1;
            // end else begin
            //     o_ones <= o_ones + 4'd1;
            // end
        end
    end

endmodule
