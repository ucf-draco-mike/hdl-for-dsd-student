// =============================================================================
// dice_roller.v — Two-Die Electronic Dice (Barcelona Final Project · CORE MODULE)
// =============================================================================
// WHAT YOU BUILD:
//   A tiny FSM plus a sequential datapath and combinational output logic.
//   Hold the roll button to spin two dice; release to let them settle.
//
//   Skill targets:  [FSM] [sequential logic] [combinational logic]
//
// The skeleton compiles and the testbench runs as-is — it just never leaves the
// IDLE state until you fill in the TODOs. Search for "TODO" to find your work.
// =============================================================================
module dice_roller (
    input  wire       i_clk,
    input  wire       i_rst,        // synchronous reset (active high)
    input  wire       i_roll,       // held high while rolling
    output reg  [3:0] o_die1,       // settled value, 1..6
    output reg  [3:0] o_die2,       // settled value, 1..6
    output reg        o_rolling     // 1 while the dice are spinning
);

    // ───────────────────────── FSM state encoding ─────────────────────────
    localparam S_IDLE = 1'b0;       // showing a settled roll
    localparam S_ROLL = 1'b1;       // animating while the button is held
    reg r_state, r_next;

    // ──────────── Free-running 1..6 counters (SEQUENTIAL datapath) ─────────
    // These spin continuously; the display only samples them while rolling.
    reg [2:0] r_d1, r_d2;
    always @(posedge i_clk) begin
        if (i_rst) begin
            r_d1 <= 3'd1;
            r_d2 <= 3'd4;
        end else begin
            // die 1 advances every clock and wraps 6 → 1
            r_d1 <= (r_d1 == 3'd6) ? 3'd1 : r_d1 + 1'b1;
            // ---- TODO: advance die 2 so the two dice de-sync ----
            //   Example: increment and wrap 6 → 1, or count down, or use a
            //   slower tick so it spins at a different rate from die 1.
            // r_d2 <= (r_d2 == 3'd6) ? 3'd1 : r_d2 + 1'b1;
        end
    end

    // ───────────────── Next-state logic (COMBINATIONAL) — TODO ─────────────
    always @(*) begin
        r_next = r_state;            // default: hold current state
        case (r_state)
            S_IDLE: begin
                // ---- TODO: when i_roll is held, start rolling ----
                // if (i_roll) r_next = S_ROLL;
            end
            S_ROLL: begin
                // ---- TODO: when i_roll is released, settle ----
                // if (!i_roll) r_next = S_IDLE;
            end
            default: r_next = S_IDLE;
        endcase
    end

    // ───────────────────── State register (SEQUENTIAL) ─────────────────────
    always @(posedge i_clk) begin
        if (i_rst) r_state <= S_IDLE;
        else       r_state <= r_next;
    end

    // ─────────────────────── Display latch (SEQUENTIAL) ────────────────────
    // While rolling, the displays follow the spinning counters; on release the
    // last values stay frozen because we stop updating them in S_IDLE.
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_die1 <= 4'd1;
            o_die2 <= 4'd4;
        end else if (r_state == S_ROLL) begin
            o_die1 <= {1'b0, r_d1};
            o_die2 <= {1'b0, r_d2};
        end
    end

    // ───────────────────── Status output (COMBINATIONAL) ──────────────────
    always @(*) o_rolling = (r_state == S_ROLL);

endmodule
