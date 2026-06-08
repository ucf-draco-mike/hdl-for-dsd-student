// =============================================================================
// top_reaction_timer.v — Board wiring for the Reaction Timer (Barcelona Project)
// =============================================================================
// Nandland Go Board I/O:
//   SW1 = arm / replay      SW2 = react      SW4 = reset
//   LED1 = stimulus ("press now!")   LED2 = FOUL   LED4 = heartbeat
//   7-seg display 1 = reaction time, tens digit   display 2 = ones digit
//
// This top is COMPLETE — your design work is in reaction_timer.v.
// =============================================================================
module top_reaction_timer (
    input  wire i_clk,
    input  wire i_switch1, i_switch2, i_switch3, i_switch4,
    output wire o_led1, o_led2, o_led3, o_led4,
    output wire o_segment1_a, o_segment1_b, o_segment1_c,
    output wire o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g,
    output wire o_segment2_a, o_segment2_b, o_segment2_c,
    output wire o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g
);
    reg [23:0] r_hb;
    always @(posedge i_clk) r_hb <= r_hb + 1'b1;

    wire w_db1, w_db2, w_db4;
    debounce d1 (.i_clk(i_clk), .i_bouncy(i_switch1), .o_clean(w_db1));
    debounce d2 (.i_clk(i_clk), .i_bouncy(i_switch2), .o_clean(w_db2));
    debounce d4 (.i_clk(i_clk), .i_bouncy(i_switch4), .o_clean(w_db4));

    wire w_arm, w_react;
    edge_detect e1 (.i_clk(i_clk), .i_signal(w_db1), .o_rising(w_arm),   .o_falling(), .o_any());
    edge_detect e2 (.i_clk(i_clk), .i_signal(w_db2), .o_rising(w_react), .o_falling(), .o_any());

    wire       w_light, w_foul;
    wire [7:0] w_value;
    reaction_timer u_rt (
        .i_clk(i_clk), .i_rst(w_db4),
        .i_arm(w_arm), .i_react(w_react),
        .o_light(w_light), .o_foul(w_foul), .o_value(w_value)
    );

    // TWO 7-segment displays — the reaction time as two hex digits.
    wire [6:0] w_seg1, w_seg2;
    hex_to_7seg h1 (.i_hex(w_value[7:4]), .o_seg(w_seg1));
    hex_to_7seg h2 (.i_hex(w_value[3:0]), .o_seg(w_seg2));

    assign o_led1 = w_light;
    assign o_led2 = w_foul;
    assign o_led3 = 1'b0;
    assign o_led4 = r_hb[23];

    assign {o_segment1_a, o_segment1_b, o_segment1_c,
            o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g} = w_seg1;
    assign {o_segment2_a, o_segment2_b, o_segment2_c,
            o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g} = w_seg2;
endmodule
