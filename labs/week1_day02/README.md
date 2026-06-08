# Day 2 Lab: Combinational Building Blocks

> **Week 1, Session 2** · Accelerated HDL for Digital System Design · UCF ECE

## Overview

| | |
|---|---|
| **Duration** | ~2 hours |
| **Prerequisites** | Pre-class video (45 min): data types, vectors, operators, continuous assignment |
| **Deliverable** | 7-segment display showing button states as hex digit, programmed on board |
| **Tools** | Yosys, nextpnr-ice40, icepack, iceprog |

## Learning Objectives

| SLO | Description |
|-----|-------------|
| 2.1 | Declare and manipulate vectors using bit selection, concatenation, and replication |
| 2.2 | Apply bitwise, arithmetic, and reduction operators correctly |
| 2.3 | Build multiplexers using the conditional operator |
| 2.4 | Compose modules hierarchically using named port connections |
| 2.5 | Design a hex-to-7-segment decoder targeting the Go Board display |
| 2.6 | Use properly sized literals to avoid width mismatch warnings |

## Exercises

> **Checking your work.** Run `make test` from inside an exercise's `starter/` directory to compare your DUT against the reference and get a **PASS/FAIL** — no flags or unlocking. If you want to see the worked answer, it is in that exercise's `../solution/ref/`.

### Exercise 1: Vector Operations Warm-Up (20 min)
Reduction operators on a 4-bit vector → LED display. Fill in `starter/w1d2_ex1_vector_ops.v`.

- **Self-check:** `cd ex1_vector_ops/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Exercise 2: 2:1 → 4:1 Multiplexer (25 min)
Build a 4:1 mux from three 2:1 mux instances. Fill in `starter/w1d2_ex2_mux4to1.v` and `starter/w1d2_ex2_top_mux.v`. Use `make ex2_show` to visualize the netlist in Yosys.

- **Self-check:** `cd ex2_mux_hierarchy/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Exercise 3: 4-Bit Ripple-Carry Adder (25 min)
Chain four `full_adder` modules. Fill in `starter/w1d2_ex3_ripple_adder_4bit.v` and `starter/w1d2_ex3_top_adder.v`.

- **Self-check:** `cd ex3_ripple_adder/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Exercise 4: Hex-to-7-Segment Decoder (30 min)
Complete the nested conditional decoder in `starter/w1d2_ex4_hex_to_7seg.v`. Wire up the top module. Cycle through all 16 button combinations and verify each hex digit displays correctly.

- **Self-check:** `cd ex4_7seg_decoder/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Exercise 5 — Stretch: Adder + Display Integration (20 min)
Combine the adder and decoder into a single design that displays the sum on 7-seg.

- **Self-check:** `cd ex5_top_adder_display/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

## Deliverable Checklist

- [ ] Exercise 1: LEDs respond correctly to reduction operations
- [ ] Exercise 2: 4:1 mux works on board
- [ ] Exercise 3: Adder shows correct sums on LEDs
- [ ] Exercise 4: All 16 hex digits display on 7-segment
- [ ] At minimum: Exercise 4 (hex display) programmed and working

## Quick Reference

```bash
# ── from labs/week1_day02/ ──
make ex1
make ex2
make ex3
make ex4
make ex5
make ex2_show
make clean

# ── from labs/week1_day02/exN_*/starter/ ──
make test                            # run published self-checking testbench (PASS/FAIL)
```
