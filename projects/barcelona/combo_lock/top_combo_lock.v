// =============================================================================
// top_combo_lock.v — Board wiring for the Combination Lock (Barcelona Project)
// =============================================================================
// Nandland Go Board I/O:
//   SW1/SW2/SW3 = code buttons (indices 0/1/2)   SW4 = reset / clear
//   LED1 = UNLOCKED      LED2 = wrong attempt(s) logged     LED4 = heartbeat
//   7-seg display 1 = wrong-attempt count   7-seg display 2 = correct digits so far
//
// This top is COMPLETE — your design work is in combo_lock.v. Debounced button
// presses are converted to single-cycle pulses with edge_detect.
// =============================================================================
module top_combo_lock (
    input  wire i_clk,
    input  wire i_switch1, i_switch2, i_switch3, i_switch4,
    output wire o_led1, o_led2, o_led3, o_led4,
    output wire o_segment1_a, o_segment1_b, o_segment1_c,
    output wire o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g,
    output wire o_segment2_a, o_segment2_b, o_segment2_c,
    output wire o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g
);
    // Heartbeat
    reg [23:0] r_hb;
    always @(posedge i_clk) r_hb <= r_hb + 1'b1;

    // Debounce all four switches.
    wire w_db1, w_db2, w_db3, w_db4;
    debounce d1 (.i_clk(i_clk), .i_bouncy(i_switch1), .o_clean(w_db1));
    debounce d2 (.i_clk(i_clk), .i_bouncy(i_switch2), .o_clean(w_db2));
    debounce d3 (.i_clk(i_clk), .i_bouncy(i_switch3), .o_clean(w_db3));
    debounce d4 (.i_clk(i_clk), .i_bouncy(i_switch4), .o_clean(w_db4));

    // Code buttons → single-cycle press pulses.
    wire w_p1, w_p2, w_p3;
    edge_detect e1 (.i_clk(i_clk), .i_signal(w_db1), .o_rising(w_p1), .o_falling(), .o_any());
    edge_detect e2 (.i_clk(i_clk), .i_signal(w_db2), .o_rising(w_p2), .o_falling(), .o_any());
    edge_detect e3 (.i_clk(i_clk), .i_signal(w_db3), .o_rising(w_p3), .o_falling(), .o_any());

    // SW4 is a level reset.
    wire w_rst = w_db4;

    // Core design under test.
    wire       w_unlocked;
    wire [3:0] w_step, w_attempts;
    combo_lock u_lock (
        .i_clk(i_clk), .i_rst(w_rst),
        .i_btn({w_p3, w_p2, w_p1}),     // bit0 = SW1, bit1 = SW2, bit2 = SW3
        .o_unlocked(w_unlocked),
        .o_step(w_step),
        .o_attempts(w_attempts)
    );

    // TWO 7-segment displays.
    wire [6:0] w_seg1, w_seg2;
    hex_to_7seg h1 (.i_hex(w_attempts), .o_seg(w_seg1));  // left: wrong attempts
    hex_to_7seg h2 (.i_hex(w_step),     .o_seg(w_seg2));  // right: correct so far

    assign o_led1 = w_unlocked;
    assign o_led2 = (w_attempts != 4'd0);
    assign o_led3 = 1'b0;
    assign o_led4 = r_hb[23];

    assign {o_segment1_a, o_segment1_b, o_segment1_c,
            o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g} = w_seg1;
    assign {o_segment2_a, o_segment2_b, o_segment2_c,
            o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g} = w_seg2;
endmodule
