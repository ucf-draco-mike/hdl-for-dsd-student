// =============================================================================
// uart_tx_asserted.sv — UART TX with Assertion Layer
// Day 14, Exercise 1
// =============================================================================
// Start from the SV UART TX and add 7 assertions.

module uart_tx_asserted #(
    parameter int CLK_FREQ  = 25_000_000,
    parameter int BAUD_RATE = 115_200
)(
    input  logic       i_clk, i_reset, i_valid,
    input  logic [7:0] i_data,
    output logic       o_tx, o_busy
);
    localparam int CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam int BAUD_CNT_W   = $clog2(CLKS_PER_BIT);

    typedef enum logic [1:0] {
        S_IDLE=2'd0, S_START=2'd1, S_DATA=2'd2, S_STOP=2'd3
    } uart_state_t;

    // Power-on values (loaded by the iCE40 GSR on real hardware). Making them
    // explicit keeps state/bit_idx defined before the first reset.
    uart_state_t           state     = S_IDLE;
    logic [BAUD_CNT_W-1:0] baud_cnt  = '0;
    logic [7:0]            shift_reg = '0;
    logic [2:0]            bit_idx   = '0;

    logic baud_tick;
    assign baud_tick = (baud_cnt == BAUD_CNT_W'(CLKS_PER_BIT - 1));
    assign o_busy = (state != S_IDLE);

    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            state <= S_IDLE;
            baud_cnt <= '0; bit_idx <= '0; shift_reg <= '0;
        end else begin
            case (state)
                S_IDLE: begin
                    baud_cnt <= '0; bit_idx <= '0;
                    if (i_valid) begin
                        shift_reg <= i_data; state <= S_START;
                    end
                end
                S_START: begin
                    baud_cnt <= baud_cnt + 1;
                    if (baud_tick) begin baud_cnt <= '0; state <= S_DATA; end
                end
                S_DATA: begin
                    baud_cnt <= baud_cnt + 1;
                    if (baud_tick) begin
                        baud_cnt <= '0;
                        shift_reg <= {1'b0, shift_reg[7:1]};
                        if (bit_idx == 3'd7) state <= S_STOP;
                        else bit_idx <= bit_idx + 1;
                    end
                end
                S_STOP: begin
                    baud_cnt <= baud_cnt + 1;
                    if (baud_tick) begin baud_cnt <= '0; state <= S_IDLE; end
                end
            endcase
        end
    end

    // o_tx is driven combinationally from the current state so the line tracks
    // the bit being sent with no one-cycle registered lag. Seed it to the idle
    // level so it is defined at time 0, before the combinational block settles.
    initial o_tx = 1'b1;
    always_comb begin
        case (state)
            S_IDLE:  o_tx = 1'b1;
            S_START: o_tx = 1'b0;
            S_DATA:  o_tx = shift_reg[0];
            S_STOP:  o_tx = 1'b1;
            default: o_tx = 1'b1;
        endcase
    end

    // =================================================================
    // ASSERTIONS — Add all 7 below
    // =================================================================

    // TODO Assertion 1: TX line must be HIGH when in IDLE state
    // always_comb begin
    //     if (state == S_IDLE)
    //         assert (o_tx == 1'b1)
    //             else $error("A1: TX not high in IDLE");
    // end

    // ---- YOUR ASSERTION 1 HERE ----

    // TODO Assertion 2: o_busy must equal (state != S_IDLE)
    // ---- YOUR ASSERTION 2 HERE ----

    // TODO Assertion 3: bit_idx must be in range [0, 7]
    // ---- YOUR ASSERTION 3 HERE ----

    // TODO Assertion 4: baud_cnt must be in range [0, CLKS_PER_BIT-1]
    // ---- YOUR ASSERTION 4 HERE ----

    // TODO Assertion 5: When state == S_START, o_tx must be 0
    // ---- YOUR ASSERTION 5 HERE ----

    // TODO Assertion 6: When state == S_STOP, o_tx must be 1
    // ---- YOUR ASSERTION 6 HERE ----

    // TODO Assertion 7: If o_busy, i_valid should not be asserted
    //   (Use $warning — this is the caller's responsibility)
    // ---- YOUR ASSERTION 7 HERE ----

endmodule
