# Day 10 Lab: Numerical Architectures & Design Trade-offs

## Overview
Today you'll compare adder and multiplier architectures, implement a sequential
multiplier, work with fixed-point arithmetic, and produce your first structured
PPA comparison table. These are the same analysis habits you'll use in the
final project report.

## Prerequisites
- Completed Day 9 lab (memory)
- Pre-class videos on timing essentials, numerical architectures, and PPA watched
- Reuse your `hex_to_7seg.v` from Day 2 and `full_adder.v` from Day 2

## Exercises

> **Checking your work.** Run `make test` from inside an exercise's `starter/` directory to compare your DUT against the reference and get a **PASS/FAIL** — no flags or unlocking. If you want to see the worked answer, it is in that exercise's `../solution/ref/`.

| # | Exercise | Time | Key SLOs |
|---|----------|------|----------|
| 1 | Adder Architecture Comparison | 30 min | 10.1, 10.4 |
| 2 | Shift-and-Add Multiplier | 30 min | 10.2, 10.4 |
| 3 | Fixed-Point Arithmetic | 20 min | 10.3 |
| 4 | Timing Constraint Exercise | 10 min | 10.5 |
| 5 | PLL & CDC (Stretch) | 15 min | 10.5 |

### Ex 1 — Adder Comparison

- **Self-check:** `cd ex1_adder_comparison/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 2 — Shift-and-Add Multiplier

- **Self-check:** `cd ex2_shift_add_multiplier/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 3 — Fixed Point

- **Self-check:** `cd ex3_fixed_point/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 4 — Timing Exercise

- **Note:** This exercise has no automated `make test` grader — it's a paper/analysis worksheet with no `make test` target, so there's no flag to capture.

### Ex 5 — PLL & CDC (Stretch)

- **Note:** This exercise has no automated `make test` grader — its reference solution ships unencrypted in `solution/`.

## Deliverables
1. **Adder/multiplier PPA comparison table** with real data (LUTs, FFs, Fmax)
2. **Working shift-and-add multiplier** on FPGA with testbench
3. **Fixed-point demo** showing correct Q4.4 multiplication result on 7-seg

## PPA Comparison Table Template

| Module | Configuration | LUTs | FFs | Fmax (MHz) | Notes |
|--------|---------------|------|-----|------------|-------|
| Adder | Ripple-carry, 8-bit | | | | Manual chain |
| Adder | Ripple-carry, 16-bit | | | | Manual chain |
| Adder | Behavioral `+`, 8-bit | | | | Tool-chosen |
| Adder | Behavioral `+`, 16-bit | | | | Tool-chosen |
| Multiplier | Combinational `*`, 8-bit | | | | 1 cycle |
| Multiplier | Shift-and-add, 8-bit | | | | 8 cycles |

## Shared Resources
- `go_board.pcf` — Pin constraint file
- Reuse your `hex_to_7seg.v` and `full_adder.v` from previous labs

## Build Commands Quick Reference

```bash
# ── from labs/week3_day10/exN_*/starter/ ──
make test                            # run published self-checking testbench (PASS/FAIL)
```
