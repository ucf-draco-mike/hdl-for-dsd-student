// =============================================================================
// combo_lock.v — 3-Button Combination Lock (Barcelona Final Project · CORE)
// =============================================================================
// WHAT YOU BUILD:
//   A Moore FSM that opens only when three buttons are pressed in the secret
//   order. A wrong press sends you back to the start and counts an attempt.
//
//   Skill targets:  [FSM] [sequential logic] [combinational logic]
//
// The secret code is three button indices (0..2 = SW1..SW3), set by parameter.
// The skeleton compiles and the testbench runs as-is — it just stays LOCKED
// until you fill in the next-state TODOs. Search for "TODO".
// =============================================================================
module combo_lock #(
    parameter [1:0] CODE0 = 2'd0,   // expected 1st press (SW1)
    parameter [1:0] CODE1 = 2'd2,   // expected 2nd press (SW3)
    parameter [1:0] CODE2 = 2'd1    // expected 3rd press (SW2)
)(
    input  wire       i_clk,
    input  wire       i_rst,        // synchronous reset / clear (active high)
    input  wire [2:0] i_btn,        // one-cycle press pulse per code button
    output reg        o_unlocked,   // 1 when the correct code has been entered
    output wire [3:0] o_step,       // # correct digits so far (0..3) — for display
    output reg  [3:0] o_attempts    // # wrong attempts so far (saturating) — for display
);

    // ───────────────────────── FSM state encoding ─────────────────────────
    localparam [1:0] S_IDLE = 2'd0;   // 0 correct digits
    localparam [1:0] S_ONE  = 2'd1;   // 1 correct digit
    localparam [1:0] S_TWO  = 2'd2;   // 2 correct digits
    localparam [1:0] S_OPEN = 2'd3;   // unlocked
    reg [1:0] r_state, r_next;

    // ─────────── Which button is pressed? (COMBINATIONAL encoder) ──────────
    reg [1:0] w_idx;     // index 0..2 of the pressed button
    reg       w_any;     // 1 if any code button was pressed this cycle
    always @(*) begin
        w_any = |i_btn;
        casez (i_btn)
            3'b??1:  w_idx = 2'd0;   // SW1
            3'b?10:  w_idx = 2'd1;   // SW2
            3'b100:  w_idx = 2'd2;   // SW3
            default: w_idx = 2'd0;
        endcase
    end

    // ───────── Next-state + wrong-press flag (COMBINATIONAL) — TODO ────────
    reg w_wrong;
    always @(*) begin
        r_next  = r_state;           // default: hold
        w_wrong = 1'b0;              // default: no error
        case (r_state)
            S_IDLE: if (w_any) begin
                // ---- TODO: correct 1st digit advances; otherwise flag wrong ----
                // if (w_idx == CODE0) r_next = S_ONE;
                // else                w_wrong = 1'b1;
            end
            S_ONE:  if (w_any) begin
                // ---- TODO: correct 2nd digit advances; else back to start ----
                // if (w_idx == CODE1) r_next = S_TWO;
                // else begin r_next = S_IDLE; w_wrong = 1'b1; end
            end
            S_TWO:  if (w_any) begin
                // ---- TODO: correct 3rd digit unlocks; else back to start ----
                // if (w_idx == CODE2) r_next = S_OPEN;
                // else begin r_next = S_IDLE; w_wrong = 1'b1; end
            end
            S_OPEN: r_next = S_OPEN;  // stay open until reset
            default: r_next = S_IDLE;
        endcase
    end

    // ────────────── State register + attempt counter (SEQUENTIAL) ──────────
    always @(posedge i_clk) begin
        if (i_rst) begin
            r_state    <= S_IDLE;
            o_attempts <= 4'd0;
        end else begin
            r_state <= r_next;
            if (w_wrong && o_attempts != 4'hF)
                o_attempts <= o_attempts + 4'd1;
        end
    end

    // ───────────────────── Moore outputs (COMBINATIONAL) ──────────────────
    assign o_step = (r_state == S_ONE) ? 4'd1 :
                    (r_state == S_TWO) ? 4'd2 :
                    (r_state == S_OPEN) ? 4'd3 : 4'd0;

    always @(*) o_unlocked = (r_state == S_OPEN);

endmodule
