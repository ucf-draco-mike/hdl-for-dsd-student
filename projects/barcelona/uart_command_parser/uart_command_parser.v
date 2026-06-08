// =============================================================================
// uart_command_parser.v — Two-Byte Serial Command Parser (Barcelona · STRETCH CORE)
// =============================================================================
// WHAT YOU BUILD:
//   An FSM that reads two-byte commands from a UART: a LETTER then a DIGIT.
//     "L5"  → drive the LEDs with value 5      "D7" → show 7
//   It echoes the digit back over the UART when a command completes.
//
//   Skill targets:  [FSM] [sequential logic] [combinational logic]
//
// This core consumes already-decoded bytes (i_rx_data + i_rx_valid), so the
// testbench can drive it directly without bit-banging a serial line.
// PROVIDED: byte classification + the IDLE→ARG / APPLY→IDLE edges.
// YOUR WORK: the ARG transitions and the datapath latches. Search "TODO".
// =============================================================================
module uart_command_parser (
    input  wire       i_clk,
    input  wire       i_rst,
    input  wire [7:0] i_rx_data,
    input  wire       i_rx_valid,     // 1-cycle pulse: a byte arrived
    output reg  [3:0] o_cmd,          // last command code (1=L, 2=D) — display 1
    output reg  [3:0] o_arg,          // last argument 0..9            — display 2
    output reg  [3:0] o_leds,         // LED value set by an "L" command
    output reg  [7:0] o_tx_data,      // byte to echo
    output reg        o_tx_valid      // 1-cycle pulse: send o_tx_data
);

    // ───────────────────────── FSM state encoding ─────────────────────────
    localparam [1:0] S_IDLE  = 2'd0,   // waiting for a command letter
                     S_ARG   = 2'd1,   // waiting for the digit argument
                     S_APPLY = 2'd2;   // act + echo, then back to idle
    reg [1:0] r_state, r_next;

    // ─────────────── Byte classification (COMBINATIONAL helpers) ───────────
    wire w_is_L     = (i_rx_data == "L");
    wire w_is_D     = (i_rx_data == "D");
    wire w_is_cmd   = w_is_L | w_is_D;
    wire w_is_digit = (i_rx_data >= "0") && (i_rx_data <= "9");
    wire [3:0] w_digit = i_rx_data[3:0];      // '0'..'9' → 0..9

    // ──────────────────── Next-state logic (COMBINATIONAL) — TODO ──────────
    always @(*) begin
        r_next = r_state;
        case (r_state)
            S_IDLE:  if (i_rx_valid && w_is_cmd) r_next = S_ARG;     // provided
            S_ARG: begin
                // ---- TODO: a digit completes the command; any other byte aborts ----
                // if      (i_rx_valid && w_is_digit) r_next = S_APPLY;
                // else if (i_rx_valid)               r_next = S_IDLE;
            end
            S_APPLY: r_next = S_IDLE;                                 // provided
            default: r_next = S_IDLE;
        endcase
    end

    always @(posedge i_clk) if (i_rst) r_state <= S_IDLE; else r_state <= r_next;

    // ──────────────── Datapath latches + apply (SEQUENTIAL) — partly TODO ──
    always @(posedge i_clk) begin
        if (i_rst) begin
            o_cmd <= 4'd0; o_arg <= 4'd0; o_leds <= 4'd0;
            o_tx_data <= 8'd0; o_tx_valid <= 1'b0;
        end else begin
            o_tx_valid <= 1'b0;     // default: no echo this cycle (one-shot strobe)

            // Capture the command letter as a small code for the display.
            if (r_state == S_IDLE && i_rx_valid && w_is_cmd)
                o_cmd <= w_is_L ? 4'd1 : 4'd2;     // 1 = "L", 2 = "D"

            // ---- TODO: in S_ARG, latch the digit argument ----
            // if (r_state == S_ARG && i_rx_valid && w_is_digit)
            //     o_arg <= w_digit;

            // ---- TODO: in S_APPLY, act on the command and echo the digit ----
            // if (r_state == S_APPLY) begin
            //     if (o_cmd == 4'd1) o_leds <= o_arg;     // "L" drives the LEDs
            //     o_tx_data  <= {4'h3, o_arg};            // echo back '0'..'9'
            //     o_tx_valid <= 1'b1;
            // end
        end
    end

endmodule
