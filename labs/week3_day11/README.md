# Day 11 Lab: UART Transmitter

## Overview
Build and verify a complete UART TX module, then send "HELLO" from the
Go Board to your PC terminal.

## Prerequisites
- Pre-class video on UART protocol and TX architecture
- Working debounce module from Day 5
- Working hex_to_7seg from Day 2

## Exercises

> **Checking your work.** Run `make test` from inside an exercise's `starter/` directory to compare your DUT against the reference and get a **PASS/FAIL** — no flags or unlocking. If you want to see the worked answer, it is in that exercise's `../solution/ref/`.

| # | Exercise | Time | Key SLOs |
|---|----------|------|----------|
| 1 | Baud Rate Generator | 15 min | 11.2 |
| 2 | UART TX Module + Testbench | 40 min | 11.3, 11.4 |
| 3 | Hardware Verification | 25 min | 11.5 |
| 4 | Multi-Character Sender | 20 min | 11.3, 11.5 |
| 5 | Parity Support (Stretch) | 15 min | 11.3 |

### Ex 1 — Baud Rate Generator

- **Self-check:** `cd ex1_baud_gen/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 2 — UART TX Module

- **Self-check:** `cd ex2_uart_tx/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 3 — Hardware Verification

- **Self-check:** `cd ex3_hardware_verify/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

## Deliverables
1. Baud generator verified in simulation
2. UART TX with self-checking protocol-aware testbench (all tests pass)
3. "HELLO" received on PC terminal emulator

## Terminal Setup
| Platform | Command |
|----------|---------|
| Linux | `screen /dev/ttyUSB0 115200` |
| macOS | `screen /dev/cu.usbserial-* 115200` |
| Windows | PuTTY → COMx, 115200, 8N1 |

## Build Commands Quick Reference

```bash
# ── from labs/week3_day11/exN_*/starter/ ──
make test                            # run published self-checking testbench (PASS/FAIL)
```
