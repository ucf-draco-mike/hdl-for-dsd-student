// =============================================================================
// tb_uart_command_parser.v — Testbench for the command FSM (Barcelona · STRETCH)
// =============================================================================
// The core consumes decoded bytes, so we drive i_rx_data + i_rx_valid directly
// (no serial bit-banging). Active checks pass on the bare skeleton (reset only).
// UNCOMMENT the TODO scenarios once the ARG transitions and latches work.
//
//   Run it:  make sim
// =============================================================================
`timescale 1ns / 1ps

module tb_uart_command_parser;

    reg        clk = 0, rst = 0;
    reg  [7:0] rx_data = 8'd0;
    reg        rx_valid = 0;
    wire [3:0] cmd, arg, leds;
    wire [7:0] tx_data;
    wire       tx_valid;

    uart_command_parser uut (
        .i_clk(clk), .i_rst(rst),
        .i_rx_data(rx_data), .i_rx_valid(rx_valid),
        .o_cmd(cmd), .o_arg(arg), .o_leds(leds),
        .o_tx_data(tx_data), .o_tx_valid(tx_valid)
    );

    always #20 clk = ~clk;

    integer tests = 0, fails = 0;
    task check_true;
        input [255:0] label;
        input         cond;
        begin
            tests = tests + 1;
            if (cond !== 1'b1) begin
                fails = fails + 1;
                $display("FAIL: %0s", label);
            end else
                $display("PASS: %0s", label);
        end
    endtask

    // Present one decoded byte to the parser.
    task send_byte;
        input [7:0] b;
        begin
            @(negedge clk); rx_data = b; rx_valid = 1'b1;
            @(negedge clk); rx_valid = 1'b0;
            @(negedge clk);                  // let the FSM settle
        end
    endtask

    initial begin
        $dumpfile("tb_uart_command_parser.vcd");
        $dumpvars(0, tb_uart_command_parser);

        rst = 1; @(negedge clk); @(negedge clk); rst = 0; @(negedge clk);

        // ---- Active checks: idle after reset ----
        check_true("reset: cmd == 0",  cmd  == 4'd0);
        check_true("reset: arg == 0",  arg  == 4'd0);
        check_true("reset: leds == 0", leds == 4'd0);

        // ---- TODO: uncomment as you build the FSM + latches ----
        // // "L5" → LED command with argument 5
        // send_byte("L");
        // check_true("after 'L': cmd == 1", cmd == 4'd1);
        // send_byte("5");
        // @(negedge clk);                    // allow S_APPLY to run
        // check_true("after '5': arg == 5",  arg  == 4'd5);
        // check_true("after 'L5': leds == 5", leds == 4'd5);
        //
        // // A non-digit after a letter aborts the command (leds unchanged).
        // send_byte("D");
        // send_byte("X");                    // not a digit
        // check_true("'DX' aborts: leds still 5", leds == 4'd5);
        //
        // // TODO (your idea): check the echo strobe (tx_valid) pulses on apply.

        $display("");
        $display("==== uart_command_parser: %0d/%0d checks passed ====", tests - fails, tests);
        if (fails == 0) $display("RESULT: PASS"); else $display("RESULT: FAIL");
        $finish;
    end
endmodule
