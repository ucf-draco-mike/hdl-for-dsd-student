// =============================================================================
// top_digital_clock.v — Board wiring for the Seconds Clock (Barcelona · STRETCH)
// =============================================================================
// Nandland Go Board I/O:
//   SW1 = mode (RUN ↔ SET)   SW2 = +1 second (in SET)   SW4 = reset
//   LED1 = SET-mode indicator      LED4 = heartbeat
//   7-seg display 1 = seconds tens   display 2 = seconds ones
//
// This top is COMPLETE — your design work is in digital_clock.v.
// =============================================================================
module top_digital_clock (
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

    wire w_mode, w_inc;
    edge_detect e1 (.i_clk(i_clk), .i_signal(w_db1), .o_rising(w_mode), .o_falling(), .o_any());
    edge_detect e2 (.i_clk(i_clk), .i_signal(w_db2), .o_rising(w_inc),  .o_falling(), .o_any());

    wire       w_setting;
    wire [3:0] w_tens, w_ones;
    digital_clock u_clk (
        .i_clk(i_clk), .i_rst(w_db4), .i_mode(w_mode), .i_inc(w_inc),
        .o_setting(w_setting), .o_tens(w_tens), .o_ones(w_ones)
    );

    // TWO 7-segment displays — tens and ones of the seconds count.
    wire [6:0] w_seg1, w_seg2;
    hex_to_7seg h1 (.i_hex(w_tens), .o_seg(w_seg1));
    hex_to_7seg h2 (.i_hex(w_ones), .o_seg(w_seg2));

    assign o_led1 = w_setting;
    assign o_led2 = 1'b0;
    assign o_led3 = 1'b0;
    assign o_led4 = r_hb[23];

    assign {o_segment1_a, o_segment1_b, o_segment1_c,
            o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g} = w_seg1;
    assign {o_segment2_a, o_segment2_b, o_segment2_c,
            o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g} = w_seg2;
endmodule
