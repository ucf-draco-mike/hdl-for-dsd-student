// =============================================================================
// uart_tx_parity.sv — UART TX with Configurable Parity (Solution)
// Day 14, Exercise 2: Constraint-Based Design with generate if
// =============================================================================
// When PARITY_EN=0: standard 10-bit frame (start + 8 data + stop)
// When PARITY_EN=1: 11-bit frame (start + 8 data + parity + stop)
//
// PARITY_TYPE=0: even parity (XOR reduction of data)
// PARITY_TYPE=1: odd parity  (inverted XOR reduction)
// =============================================================================

module uart_tx_parity #(
    parameter int CLK_FREQ    = 25_000_000,
    parameter int BAUD_RATE   = 115_200,
    parameter int PARITY_EN   = 0,
    parameter int PARITY_TYPE = 0
)(
    input  logic       i_clk,
    input  logic       i_reset,
    input  logic       i_valid,
    input  logic [7:0] i_data,
    output logic       o_tx,
    output logic       o_busy
);

    localparam int CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam int BAUD_CNT_W   = $clog2(CLKS_PER_BIT);

    typedef enum logic [2:0] {
        S_IDLE  = 3'd0,
        S_START = 3'd1,
        S_DATA  = 3'd2,
        S_PARITY= 3'd3,   // used only when PARITY_EN=1
        S_STOP  = 3'd4
    } state_t;

    state_t state;
    logic [BAUD_CNT_W-1:0] baud_cnt;
    logic [7:0] shift_reg;
    logic [2:0] bit_idx;

    logic baud_tick;
    assign baud_tick = (baud_cnt == BAUD_CNT_W'(CLKS_PER_BIT - 1));
    assign o_busy = (state != S_IDLE);

    // ----------------------------------------------------------------
    // Parity calculation — conditionally compiled with generate if.
    // ----------------------------------------------------------------
    logic parity_bit;
    generate
        if (PARITY_EN) begin : gen_parity
            if (PARITY_TYPE == 0)
                assign parity_bit = ^i_data;        // even
            else
                assign parity_bit = ~(^i_data);     // odd
        end else begin : gen_no_parity
            assign parity_bit = 1'b1;               // unused; line idles high
        end
    endgenerate

    // ----------------------------------------------------------------
    // Main FSM
    // ----------------------------------------------------------------
    always_ff @(posedge i_clk) begin
        if (i_reset) begin
            state     <= S_IDLE;
            o_tx      <= 1'b1;
            baud_cnt  <= '0;
            bit_idx   <= '0;
            shift_reg <= '0;
        end else begin
            case (state)
                S_IDLE: begin
                    o_tx <= 1'b1;
                    baud_cnt <= '0;
                    bit_idx  <= '0;
                    if (i_valid) begin
                        shift_reg <= i_data;
                        state     <= S_START;
                    end
                end

                S_START: begin
                    o_tx <= 1'b0;  // start bit
                    baud_cnt <= baud_cnt + 1;
                    if (baud_tick) begin
                        baud_cnt <= '0;
                        state    <= S_DATA;
                    end
                end

                S_DATA: begin
                    o_tx <= shift_reg[0];
                    baud_cnt <= baud_cnt + 1;
                    if (baud_tick) begin
                        baud_cnt  <= '0;
                        shift_reg <= {1'b0, shift_reg[7:1]};
                        if (bit_idx == 3'd7) begin
                            // generate if selects the post-data state at compile time
                            if (PARITY_EN) state <= S_PARITY;
                            else           state <= S_STOP;
                        end else begin
                            bit_idx <= bit_idx + 1;
                        end
                    end
                end

                S_PARITY: begin
                    o_tx <= parity_bit;   // parity bit (only reached when PARITY_EN=1)
                    baud_cnt <= baud_cnt + 1;
                    if (baud_tick) begin
                        baud_cnt <= '0;
                        state    <= S_STOP;
                    end
                end

                S_STOP: begin
                    o_tx <= 1'b1;  // stop bit
                    baud_cnt <= baud_cnt + 1;
                    if (baud_tick) begin
                        baud_cnt <= '0;
                        state    <= S_IDLE;
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule
