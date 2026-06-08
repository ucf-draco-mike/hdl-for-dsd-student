# Day 9 Lab: Memory — RAM, ROM & Block RAM

## Overview
Today you'll work with on-chip memory: ROM for lookup tables and pattern
storage, RAM for read/write data, and the iCE40's block RAM (EBR) resources.
You'll learn to initialize memory from `.hex` files and write testbenches that
verify memory operations with proper handling of synchronous read latency.

## Prerequisites
- Completed Day 8 lab (hierarchical design)
- Pre-class video on ROM, RAM, and iCE40 memory resources watched

## Exercises

> **Checking your work.** Run `make test` from inside an exercise's `starter/` directory to compare your DUT against the reference and get a **PASS/FAIL** — no flags or unlocking. If you want to see the worked answer, it is in that exercise's `../solution/ref/`.

| # | Exercise | Time | Key SLOs |
|---|----------|------|----------|
| 1 | ROM Pattern Sequencer | 30 min | 9.1, 9.5, 9.6 |
| 2 | Synchronous RAM — Write/Read | 30 min | 9.2, 9.3, 9.4 |
| 3 | Initialized RAM with `$readmemh` | 25 min | 9.2, 9.6 |
| 4 | Dual-Display Pattern Player (stretch) | 20 min | 9.5, 9.6 |
| 5 | Register File (stretch) | 20 min | 9.2 |

### Ex 1 — ROM Pattern Sequencer

- **Self-check:** `cd ex1_rom_sequencer/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 2 — Sync RAM

- **Self-check:** `cd ex2_sync_ram/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 3 — Initialized RAM

- **Self-check:** `cd ex3_initialized_ram/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 4 — Dual Display

- **Self-check:** `cd ex4_dual_display/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 5 — Register File

- **Self-check:** `cd ex5_register_file/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

## Key Concepts
- `case`-based ROM vs. array + `$readmemh` ROM
- Async read → LUT inference. Sync read → block RAM inference
- Single-port synchronous RAM with read-before-write behavior
- iCE40 HX1K: 16 EBR blocks × 4 Kbit = 64 Kbit total block RAM
- One-cycle read latency is the #1 source of memory bugs

## Deliverables
- [ ] ROM pattern sequencer displaying on LEDs and 7-seg (Ex 1)
- [ ] RAM write/read verified with self-checking testbench (Ex 2)
- [ ] Initialized RAM with `.hex` file verified (Ex 3)
- [ ] `make stat` output showing block RAM inference for Ex 2

## Build Commands Quick Reference

```bash
# ── from labs/week3_day09/exN_*/starter/ ──
make test                            # run published self-checking testbench (PASS/FAIL)
```
