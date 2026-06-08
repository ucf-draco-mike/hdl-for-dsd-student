// =============================================================================
// top_tone_generator.v — Board wiring for the Tone Generator (Barcelona · STRETCH)
// =============================================================================
// Nandland Go Board I/O:
//   SW1 = play/stop      SW4 = reset
//   LED1 = sound (flickers at the tone frequency)   LED4 = heartbeat
//   io_pmod_1 = square-wave output — wire a small piezo speaker here.
//   7-seg display 1 = 'A' when playing (audio), '0' when stopped
//   7-seg display 2 = current note index 0..7
//
// This top is COMPLETE — your design work is in tone_generator.v.
// =============================================================================
module top_tone_generator (
    input  wire i_clk,
    input  wire i_switch1, i_switch2, i_switch3, i_switch4,
    output wire io_pmod_1,
    output wire o_led1, o_led2, o_led3, o_led4,
    output wire o_segment1_a, o_segment1_b, o_segment1_c,
    output wire o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g,
    output wire o_segment2_a, o_segment2_b, o_segment2_c,
    output wire o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g
);
    reg [23:0] r_hb;
    always @(posedge i_clk) r_hb <= r_hb + 1'b1;

    wire w_db1, w_db4;
    debounce d1 (.i_clk(i_clk), .i_bouncy(i_switch1), .o_clean(w_db1));
    debounce d4 (.i_clk(i_clk), .i_bouncy(i_switch4), .o_clean(w_db4));

    wire w_play;
    edge_detect e1 (.i_clk(i_clk), .i_signal(w_db1), .o_rising(w_play), .o_falling(), .o_any());

    wire       w_sound, w_playing;
    wire [3:0] w_note;
    tone_generator u_tone (
        .i_clk(i_clk), .i_rst(w_db4), .i_play_toggle(w_play),
        .o_sound(w_sound), .o_playing(w_playing), .o_note(w_note)
    );

    // TWO 7-segment displays: status letter and note index.
    wire [6:0] w_seg1, w_seg2;
    hex_to_7seg h1 (.i_hex(w_playing ? 4'hA : 4'h0), .o_seg(w_seg1));
    hex_to_7seg h2 (.i_hex(w_note),                  .o_seg(w_seg2));

    assign io_pmod_1 = w_sound;
    assign o_led1 = w_sound;
    assign o_led2 = 1'b0;
    assign o_led3 = 1'b0;
    assign o_led4 = r_hb[23];

    assign {o_segment1_a, o_segment1_b, o_segment1_c,
            o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g} = w_seg1;
    assign {o_segment2_a, o_segment2_b, o_segment2_c,
            o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g} = w_seg2;
endmodule
