// =============================================================================
// tb_led_blinker.v -- Baseline TB for led_blinker -- verifies counter toggles (Day 4, Ex 3)
// Accelerated HDL for Digital System Design - Dr. Mike Borowczak - ECE - CECS - UCF
// =============================================================================
`timescale 1ns/1ps

module tb_led_blinker;
    parameter CLK_PERIOD = 40;  // 25 MHz

    reg  clk = 0;
    wire led1, led2, led3, led4;

    led_blinker dut (
        .i_clk(clk),
        .o_led1(led1), .o_led2(led2), .o_led3(led3), .o_led4(led4)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    // LEDs are driven from counter bits [23:20]; the fastest (bit 20) toggles
    // once every 2^20 = 1,048,576 clocks, so we must run past that to observe
    // the counter actually moving. CYCLES is chosen just above 2^20.
    localparam integer CYCLES = 1_100_000;

    integer pass_count = 0, fail_count = 0;
    reg [3:0] prev_leds;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_led_blinker);

        // Sample the LEDs at reset (counter = 0 -> all low), advance past the
        // fastest LED's first toggle, then confirm the bundle changed. This is
        // a "counter is running, not stuck" check rather than an exact count.
        prev_leds = {led1, led2, led3, led4};
        repeat (CYCLES) @(posedge clk);
        #1;

        if ({led1, led2, led3, led4} !== prev_leds) begin
            $display("PASS: LEDs changed after %0d cycles (counter running)", CYCLES);
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: LEDs never changed in %0d cycles -- counter stuck?", CYCLES);
            fail_count = fail_count + 1;
        end

        // Verify all outputs are valid logic levels
        if (led1 !== 1'bx && led2 !== 1'bx && led3 !== 1'bx && led4 !== 1'bx) begin
            $display("PASS: all LED outputs are valid logic levels");
            pass_count = pass_count + 1;
        end else begin
            $display("FAIL: one or more LED outputs are X");
            fail_count = fail_count + 1;
        end

        $display("\n=== tb_led_blinker: %0d passed, %0d failed ===", pass_count, fail_count);
        if (fail_count > 0) $display("SOME TESTS FAILED");
        else $display("ALL TESTS PASSED");
        $finish;
    end
endmodule
