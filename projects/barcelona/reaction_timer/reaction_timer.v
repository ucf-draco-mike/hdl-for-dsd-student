// =============================================================================
// reaction_timer.v — Reaction-Time Game (Barcelona Final Project · CORE)
// =============================================================================
// WHAT YOU BUILD:
//   An FSM that waits a pseudo-random time, lights an LED, then measures how
//   fast you react. Press too early and you FOUL.
//
//   Skill targets:  [FSM] [sequential logic] [combinational logic]
//
// PROVIDED for you (study them — they are good sequential-logic examples):
//   * a 16-bit LFSR (pseudo-random source)
//   * a centisecond tick divider
// YOUR WORK is the next-state logic and the score counter. Search for "TODO".
//
// The CS_DIV / WAIT_LEN parameters are tiny in simulation (overridden by the
// testbench) and full-size on hardware.
// =============================================================================
module reaction_timer #(
    parameter integer CS_DIV     = 250_000,    // clocks per 0.01 s (sim overrides)
    parameter integer WAIT_LEN   = 25_000_000, // base random-wait clocks (sim overrides)
    parameter integer RAND_SHIFT = 14          // random span = lfsr[9:0] << RAND_SHIFT
)(
    input  wire       i_clk,
    input  wire       i_rst,        // synchronous reset (active high)
    input  wire       i_arm,        // 1-cycle pulse: start / replay a round
    input  wire       i_react,      // 1-cycle pulse: player reacted
    output reg        o_light,      // stimulus LED (on = "press now!")
    output reg        o_foul,       // 1 if the player pressed too early
    output reg  [7:0] o_value       // reaction time in centiseconds (two hex digits)
);

    // ───────────────────────── FSM state encoding ─────────────────────────
    localparam [2:0] S_IDLE = 3'd0,   // waiting for arm
                     S_WAIT = 3'd1,   // random delay, LED off
                     S_GO   = 3'd2,   // LED on, counting reaction time
                     S_DONE = 3'd3,   // show result
                     S_FOUL = 3'd4;   // pressed too early
    reg [2:0] r_state, r_next;

    // ──────────────────── 16-bit LFSR (SEQUENTIAL, PROVIDED) ───────────────
    // Maximal-length polynomial x^16 + x^15 + x^13 + x^4 + 1.
    reg [15:0] r_lfsr;
    always @(posedge i_clk) begin
        if (i_rst) r_lfsr <= 16'hACE1;
        else       r_lfsr <= {r_lfsr[14:0],
                              r_lfsr[15] ^ r_lfsr[14] ^ r_lfsr[12] ^ r_lfsr[3]};
    end

    // ─────────────── Centisecond tick (SEQUENTIAL, PROVIDED) ───────────────
    reg [$clog2(CS_DIV)-1:0] r_div;
    wire w_cs_tick = (r_div == CS_DIV - 1);
    always @(posedge i_clk) begin
        if (i_rst || w_cs_tick) r_div <= 0;
        else                    r_div <= r_div + 1'b1;
    end

    // Random wait counter (loaded when a round starts).
    reg [31:0] r_wait;

    // ───────────────── Next-state logic (COMBINATIONAL) — TODO ─────────────
    always @(*) begin
        r_next = r_state;
        case (r_state)
            S_IDLE: if (i_arm) r_next = S_WAIT;
            S_WAIT: begin
                // ---- TODO: pressing during the wait is a FOUL ----
                // if (i_react)            r_next = S_FOUL;
                // ---- TODO: when the random wait expires, go! ----
                // else if (r_wait == 0)   r_next = S_GO;
            end
            S_GO: begin
                // ---- TODO: a press in S_GO records the reaction ----
                // if (i_react) r_next = S_DONE;
            end
            S_DONE: if (i_arm) r_next = S_IDLE;
            S_FOUL: if (i_arm) r_next = S_IDLE;
            default: r_next = S_IDLE;
        endcase
    end

    // ───────────────── State register + datapath (SEQUENTIAL) ──────────────
    always @(posedge i_clk) begin
        if (i_rst) begin
            r_state <= S_IDLE;
            r_wait  <= 32'd0;
            o_value <= 8'd0;
        end else begin
            r_state <= r_next;

            // Load a pseudo-random wait when a round starts, and zero the score.
            if (r_next == S_WAIT && r_state != S_WAIT) begin
                // {22'd0, lfsr} widens first so the shift never drops bits.
                r_wait  <= WAIT_LEN + ({22'd0, r_lfsr[9:0]} << RAND_SHIFT);
                o_value <= 8'd0;
            end else if (r_state == S_WAIT && r_wait != 32'd0) begin
                r_wait <= r_wait - 1'b1;
            end

            // ---- TODO: count reaction time while in S_GO ----
            //   if (r_state == S_GO && w_cs_tick && o_value != 8'hFF)
            //       o_value <= o_value + 1'b1;
        end
    end

    // ───────────────── Moore output logic (COMBINATIONAL) ──────────────────
    always @(*) begin
        o_light = 1'b0;
        o_foul  = 1'b0;
        case (r_state)
            S_GO:    o_light = 1'b1;     // "press now!"
            S_FOUL:  o_foul  = 1'b1;
            default: ;
        endcase
    end

endmodule
