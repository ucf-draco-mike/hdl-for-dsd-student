// =============================================================================
// tb_uart_tx_parity.sv -- Self-checking testbench for UART TX with Parity
// Day 14, Exercise 2
// =============================================================================
// Decodes the serial frame on each instance and verifies its structure:
//   PARITY_EN=0 : start(0) + 8 data (LSB first) + stop(1)          = 10 bits
//   PARITY_EN=1 : start(0) + 8 data + parity + stop(1)             = 11 bits
// Parity is even (XOR reduction of the data byte).
`timescale 1ns/1ps

module tb_uart_tx_parity;

    localparam int CLK_FREQ     = 25_000_000;
    localparam int BAUD_RATE    = 115_200;
    localparam int CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
    localparam int CLK_PERIOD   = 40;  // 25 MHz

    logic       clk, reset, valid;
    logic [7:0] data;
    logic       tx_no_par, busy_no_par;
    logic       tx_even,   busy_even;

    uart_tx_parity #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE), .PARITY_EN(0)
    ) uut_no_parity (
        .i_clk(clk), .i_reset(reset), .i_valid(valid), .i_data(data),
        .o_tx(tx_no_par), .o_busy(busy_no_par)
    );

    uart_tx_parity #(.CLK_FREQ(CLK_FREQ), .BAUD_RATE(BAUD_RATE), .PARITY_EN(1), .PARITY_TYPE(0)
    ) uut_even_parity (
        .i_clk(clk), .i_reset(reset), .i_valid(valid), .i_data(data),
        .o_tx(tx_even), .o_busy(busy_even)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    integer pass_count = 0, fail_count = 0;

    task automatic chk(input cond, input string msg);
        begin
            if (cond) begin pass_count++; $display("PASS: %0s", msg); end
            else      begin fail_count++; $display("FAIL: %0s", msg); end
        end
    endtask

    // Send a byte and decode both instances' frames in lock-step (they are
    // driven by the same valid, so their bit windows are aligned).
    task automatic send_and_check(input [7:0] d);
        integer i;
        logic [10:0] f_np, f_ev;   // sampled bits, index 0 = start
        begin
            data = d;
            @(posedge clk); valid = 1;
            @(posedge clk); valid = 0;

            // Align to the centre of the start bit.
            wait (tx_no_par == 1'b0);
            repeat (CLKS_PER_BIT/2) @(posedge clk);

            for (i = 0; i < 11; i = i + 1) begin
                f_np[i] = tx_no_par;
                f_ev[i] = tx_even;
                repeat (CLKS_PER_BIT) @(posedge clk);
            end

            // --- No-parity frame: start + 8 data + stop ---
            chk(f_np[0]   == 1'b0,        $sformatf("[np 0x%02h] start bit low", d));
            chk(f_np[8:1] == d,           $sformatf("[np 0x%02h] data bits", d));
            chk(f_np[9]   == 1'b1,        $sformatf("[np 0x%02h] stop bit high", d));

            // --- Even-parity frame: start + 8 data + parity + stop ---
            chk(f_ev[0]    == 1'b0,       $sformatf("[ev 0x%02h] start bit low", d));
            chk(f_ev[8:1]  == d,          $sformatf("[ev 0x%02h] data bits", d));
            chk(f_ev[9]    == (^d),       $sformatf("[ev 0x%02h] even parity bit", d));
            chk(f_ev[10]   == 1'b1,       $sformatf("[ev 0x%02h] stop bit high", d));

            wait (!busy_no_par && !busy_even);
            repeat (CLKS_PER_BIT) @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("uart_parity.vcd");
        $dumpvars(0, tb_uart_tx_parity);

        clk = 0; reset = 1; valid = 0; data = 0;
        repeat(5) @(posedge clk);
        reset = 0;
        repeat(3) @(posedge clk);

        chk(tx_no_par === 1'b1, "no-parity TX idle high");
        chk(tx_even   === 1'b1, "even-parity TX idle high");

        send_and_check(8'h41);
        send_and_check(8'h00);
        send_and_check(8'hFF);
        send_and_check(8'hAA);
        send_and_check(8'h55);

        $display("");
        $display("========================================");
        $display("  UART parity frame tests: %0d passed, %0d failed", pass_count, fail_count);
        if (fail_count == 0) $display("  All tests passed!");
        else                 $display("  *** %0d FAILURES ***", fail_count);
        $display("========================================");
        $finish;
    end

endmodule
