// =============================================================================
// top_pattern_generator.v — Board wiring for the Light Pattern (Barcelona · STRETCH)
// =============================================================================
// Nandland Go Board I/O:
//   SW1 = run/pause     SW2 = single step (while paused)     SW4 = reset
//   LED1..3 = low 3 pattern bits        LED4 = heartbeat
//   7-seg display 1 = pattern high nibble   display 2 = pattern low nibble
//
// This top is COMPLETE — your design work is in pattern_generator.v.
// =============================================================================
module top_pattern_generator (
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

    wire w_toggle, w_step;
    edge_detect e1 (.i_clk(i_clk), .i_signal(w_db1), .o_rising(w_toggle), .o_falling(), .o_any());
    edge_detect e2 (.i_clk(i_clk), .i_signal(w_db2), .o_rising(w_step),   .o_falling(), .o_any());

    wire       w_running;
    wire [7:0] w_pattern;
    pattern_generator u_pg (
        .i_clk(i_clk), .i_rst(w_db4),
        .i_run_toggle(w_toggle), .i_step(w_step),
        .o_running(w_running), .o_pattern(w_pattern)
    );

    // TWO 7-segment displays — the 8-bit pattern as two hex digits.
    wire [6:0] w_seg1, w_seg2;
    hex_to_7seg h1 (.i_hex(w_pattern[7:4]), .o_seg(w_seg1));
    hex_to_7seg h2 (.i_hex(w_pattern[3:0]), .o_seg(w_seg2));

    assign o_led1 = w_pattern[0];
    assign o_led2 = w_pattern[1];
    assign o_led3 = w_pattern[2];
    assign o_led4 = r_hb[23];

    assign {o_segment1_a, o_segment1_b, o_segment1_c,
            o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g} = w_seg1;
    assign {o_segment2_a, o_segment2_b, o_segment2_c,
            o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g} = w_seg2;
endmodule
