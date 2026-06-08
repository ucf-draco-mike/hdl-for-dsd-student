// =============================================================================
// top_uart_command_parser.v — Board wiring for the Command Parser (Barcelona · STRETCH)
// =============================================================================
// Nandland Go Board I/O:
//   i_uart_rx / o_uart_tx = USB-serial @ 9600 8N1 (use a terminal at 9600 baud)
//   Send two-byte commands: "L5", "D7", ...
//   LED1..3 = low 3 bits of the LED command value     LED4 = heartbeat
//   7-seg display 1 = command code (1=L, 2=D)   display 2 = digit argument
//
// This top is COMPLETE — your design work is in uart_command_parser.v.
// uart_rx/uart_tx are reused from the shared course library.
// =============================================================================
module top_uart_command_parser (
    input  wire i_clk,
    input  wire i_uart_rx,
    output wire o_uart_tx,
    input  wire i_switch1, i_switch2, i_switch3, i_switch4,
    output wire o_led1, o_led2, o_led3, o_led4,
    output wire o_segment1_a, o_segment1_b, o_segment1_c,
    output wire o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g,
    output wire o_segment2_a, o_segment2_b, o_segment2_c,
    output wire o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g
);
    reg [23:0] r_hb;
    always @(posedge i_clk) r_hb <= r_hb + 1'b1;

    // UART receiver → decoded bytes.
    wire [7:0] w_rx_data;
    wire       w_rx_valid;
    uart_rx #(.CLK_FREQ(25_000_000), .BAUD_RATE(9600)) u_rx (
        .i_clk(i_clk), .i_rx(i_uart_rx),
        .o_data(w_rx_data), .o_valid(w_rx_valid), .o_error()
    );

    // Command parser core.
    wire [3:0] w_cmd, w_arg, w_leds;
    wire [7:0] w_tx_data;
    wire       w_tx_valid;
    uart_command_parser u_parser (
        .i_clk(i_clk), .i_rst(i_switch4),
        .i_rx_data(w_rx_data), .i_rx_valid(w_rx_valid),
        .o_cmd(w_cmd), .o_arg(w_arg), .o_leds(w_leds),
        .o_tx_data(w_tx_data), .o_tx_valid(w_tx_valid)
    );

    // UART transmitter → echo bytes back to the terminal.
    uart_tx #(.CLK_FREQ(25_000_000), .BAUD_RATE(9600)) u_tx (
        .i_clk(i_clk), .i_data(w_tx_data), .i_valid(w_tx_valid),
        .o_tx(o_uart_tx), .o_busy(), .o_done()
    );

    // TWO 7-segment displays: command code and argument.
    wire [6:0] w_seg1, w_seg2;
    hex_to_7seg h1 (.i_hex(w_cmd), .o_seg(w_seg1));
    hex_to_7seg h2 (.i_hex(w_arg), .o_seg(w_seg2));

    assign o_led1 = w_leds[0];
    assign o_led2 = w_leds[1];
    assign o_led3 = w_leds[2];
    assign o_led4 = r_hb[23];

    assign {o_segment1_a, o_segment1_b, o_segment1_c,
            o_segment1_d, o_segment1_e, o_segment1_f, o_segment1_g} = w_seg1;
    assign {o_segment2_a, o_segment2_b, o_segment2_c,
            o_segment2_d, o_segment2_e, o_segment2_f, o_segment2_g} = w_seg2;
endmodule
