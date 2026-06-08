// =============================================================================
// top_dice_roller.v — Board wiring for the Two-Die Dice (Barcelona Final Project)
// =============================================================================
// Nandland Go Board I/O:
//   SW1  = roll   (hold to spin)        SW4 = reset
//   LED1 = rolling indicator            LED4 = heartbeat
//   7-seg display 1 = die 1 (1..6)      7-seg display 2 = die 2 (1..6)
//
// This top is COMPLETE — your design work is in dice_roller.v. It is here so
// you can synthesize and flash the board from day one (`make`, `make prog`).
// =============================================================================
module top_dice_roller (
    input  wire i_clk,
    input  wire i_switch1, i_switch2, i_switch3, i_switch4,
    output wire o_led1, o_led2, o_led3, o_led4,
    output wire o_segment1_a, o_segment1_b, o_segment1_c,
    output wire o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g,
    output wire o_segment2_a, o_segment2_b, o_segment2_c,
    output wire o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g
);
    // Heartbeat — proves the board is alive even before the design works.
    reg [23:0] r_hb;
    always @(posedge i_clk) r_hb <= r_hb + 1'b1;

    // Debounce the two switches we use (SW1 = roll, SW4 = reset).
    wire w_roll, w_rst;
    debounce d_roll (.i_clk(i_clk), .i_bouncy(i_switch1), .o_clean(w_roll));
    debounce d_rst  (.i_clk(i_clk), .i_bouncy(i_switch4), .o_clean(w_rst));

    // Core design under test.
    wire [3:0] w_die1, w_die2;
    wire       w_rolling;
    dice_roller u_dice (
        .i_clk(i_clk), .i_rst(w_rst), .i_roll(w_roll),
        .o_die1(w_die1), .o_die2(w_die2), .o_rolling(w_rolling)
    );

    // TWO 7-segment displays — one die per display.
    wire [6:0] w_seg1, w_seg2;
    hex_to_7seg h1 (.i_hex(w_die1), .o_seg(w_seg1));
    hex_to_7seg h2 (.i_hex(w_die2), .o_seg(w_seg2));

    assign o_led1 = w_rolling;
    assign o_led2 = 1'b0;
    assign o_led3 = 1'b0;
    assign o_led4 = r_hb[23];

    assign {o_segment1_a, o_segment1_b, o_segment1_c,
            o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g} = w_seg1;
    assign {o_segment2_a, o_segment2_b, o_segment2_c,
            o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g} = w_seg2;
endmodule
