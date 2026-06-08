// =============================================================================
// game_of_life.v — 1-D Cellular Automaton (Barcelona · STRETCH CORE)
// =============================================================================
// WHAT YOU BUILD:
//   "Life" on a single wrapped row of 8 cells. Each generation, every cell's
//   next value comes from a Wolfram rule applied to its 3-cell neighbourhood.
//   Run continuously or single-step one generation at a time.
//
//   Skill targets:  [FSM] [sequential logic] [combinational logic]
//
// PROVIDED: the generation timer, the advance select, and loading the next row.
// YOUR WORK: the next-generation rule (combinational), the generation counter
//   (sequential), and the run/pause next-state. Search "TODO".
//
// (A full 2-D Conway grid in block RAM is a great extension — see TESTPLAN.md.)
// =============================================================================
module game_of_life #(
    parameter integer GEN_DIV = 6_250_000,      // clocks per generation (sim overrides)
    parameter [7:0]   SEED    = 8'h18,          // initial row (two centre cells on)
    parameter [7:0]   RULE    = 8'd90           // Wolfram rule number
)(
    input  wire       i_clk,
    input  wire       i_rst,
    input  wire       i_run_toggle,   // 1-cycle pulse: run ↔ pause
    input  wire       i_step,         // 1-cycle pulse: one generation while paused
    output reg        o_running,
    output reg  [7:0] o_cells,        // current generation (8 wrapped cells)
    output reg  [7:0] o_gen           // generation counter (two hex digits)
);

    // ───────────────────────── FSM state encoding ─────────────────────────
    localparam S_PAUSE = 1'b0;
    localparam S_RUN   = 1'b1;
    reg r_state, r_next;

    // ─────────────────── Generation timer (SEQUENTIAL) ─────────────────────
    reg [$clog2(GEN_DIV)-1:0] r_div;
    wire w_gen_tick = (r_div == GEN_DIV - 1);
    always @(posedge i_clk) begin
        if (i_rst || !o_running || w_gen_tick) r_div <= 0;
        else                                   r_div <= r_div + 1'b1;
    end

    // Advance automatically while running, or by button while paused.
    wire w_adv = o_running ? w_gen_tick : i_step;

    // ──────────── Next-generation rule (COMBINATIONAL) — TODO ──────────────
    reg [7:0] w_next;
    integer k;
    always @(*) begin
        w_next = o_cells;            // default: hold the row unchanged
        for (k = 0; k < 8; k = k + 1) begin
            // ---- TODO: apply RULE to each wrapped 3-cell neighbourhood ----
            //   The 3-bit index is {left, centre, right} of cell k (ring of 8):
            // w_next[k] = RULE[ {o_cells[(k+1)%8], o_cells[k], o_cells[(k+7)%8]} ];
        end
    end

    // ──────────── Row register + generation counter (SEQUENTIAL) ───────────
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_cells <= SEED;
            o_gen   <= 8'd0;
        end else if (w_adv) begin
            o_cells <= w_next;       // provided: load the next generation
            // ---- TODO: count generations (two hex digits, wraps at 0xFF) ----
            // o_gen <= o_gen + 1'b1;
        end
    end

    // ──────────────── Run/pause next-state (COMBINATIONAL) — TODO ──────────
    always @(*) begin
        r_next = r_state;
        case (r_state)
            S_PAUSE: begin
                // ---- TODO: a toggle press starts free-running ----
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

endmodule
