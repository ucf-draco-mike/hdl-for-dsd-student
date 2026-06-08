# Day 4 Lab: Sequential Logic Fundamentals

> **Week 1, Session 4** · Accelerated HDL for Digital System Design · UCF ECE

## Overview

| | |
|---|---|
| **Duration** | ~2 hours |
| **Prerequisites** | Pre-class video (50 min): clocks, edges, nonblocking assignment, flip-flops, resets, counters |
| **Deliverable** | LED blinker at ~1 Hz + counter value on 7-segment display |
| **Tools** | Icarus Verilog + GTKWave (simulation), Yosys + nextpnr (synthesis) |

## Learning Objectives

| SLO | Description |
|-----|-------------|
| 4.1 | Write `always @(posedge clk)` blocks with synchronous reset |
| 4.2 | Use nonblocking assignment (`<=`) correctly in sequential blocks |
| 4.3 | Implement D flip-flops with enable and reset |
| 4.4 | Design counter-based clock dividers |
| 4.5 | Debug sequential logic using Icarus Verilog simulation and GTKWave |
| 4.6 | Integrate sequential and combinational modules into a working system |

## Exercises

> **Checking your work.** Run `make test` from inside an exercise's `starter/` directory to compare your DUT against the reference and get a **PASS/FAIL** — no flags or unlocking. If you want to see the worked answer, it is in that exercise's `../solution/ref/`.

### Exercise 1: D Flip-Flop — Simulate First! (25 min)
Implement in `starter/w1d4_ex1_d_ff.v`, run testbench with `make ex1_sim`. Open waveforms in GTKWave. Mark the moment `i_d` changes vs. when `o_q` changes.

- **Self-check:** `cd ex1_d_ff/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Exercise 2: Loadable Register (20 min)
4-bit register with load enable. `make ex2_sim` to verify load/hold/reset behavior.

- **Self-check:** `cd ex2_register/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Exercise 3: LED Blinker (25 min) ★ KEY EXERCISE
Free-running counter with multi-speed LED output. `make ex3` to program. LED1 slowest, LED4 fastest — visually demonstrates binary counting.

- **Self-check:** `cd ex3_led_blinker/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Exercise 4: 7-Segment Counter — Week 1 Capstone (30 min) ★ CAPSTONE
Running hex counter on the display. Integrates clock division + counting + combinational decoding. `make ex4`.

- **Self-check:** `cd ex4_seg_counter/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Exercise 5: Dual-Speed Blinker (15 min)
Two independent dividers, complementary LED pairs. `make ex5`.

- **Self-check:** `cd ex5_dual_blinker/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Exercise 6 — Stretch: Up/Down Counter (if time permits)
Button-controlled counter on 7-seg. Will be bouncy without debouncing — this previews Day 5!

- **Self-check:** `cd ex6_updown_counter/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

## Deliverable Checklist

- [ ] Exercise 1: Testbench passes, waveforms examined in GTKWave
- [ ] Exercise 2: Testbench passes all 5 test cases
- [ ] Exercise 3: LEDs blink at visible rates on board
- [ ] Exercise 4: 7-seg counts 0→F at readable speed ← **primary deliverable**
- [ ] At minimum: Exercise 3 (LED blinker) working on board

## Quick Reference

```bash
# ── from labs/week1_day04/ ──
make ex1_sim # Simulate D flip-flop
make ex2_sim # Simulate register
make ex3 # Program LED blinker
make ex4 # Program 7-seg counter (capstone)
make ex5 # Program dual blinker
make ex6 # Program up/down counter (stretch)
make clean

# ── from labs/week1_day04/exN_*/starter/ ──
make test                            # run published self-checking testbench (PASS/FAIL)
```

## End of Week 1! 🎉

You went from zero HDL to a counter running on a display in 4 days. That's a real accomplishment. Next week: debouncing, testbench methodology, FSMs, and parameterization.
