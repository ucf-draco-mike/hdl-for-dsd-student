# Day 12 Lab: UART RX, SPI & IP Integration

## Overview
Build the UART receiver with 16× oversampling, create a loopback test, and
explore SPI master design or IP integration.

## Prerequisites
- Working UART TX from Day 11
- Pre-class video on UART RX oversampling and SPI

## Exercises

> **Checking your work.** Run `make test` from inside an exercise's `starter/` directory to compare your DUT against the reference and get a **PASS/FAIL** — no flags or unlocking. If you want to see the worked answer, it is in that exercise's `../solution/ref/`.

| # | Exercise | Time | Key SLOs |
|---|----------|------|----------|
| 1 | UART RX Module + Testbench | 40 min | 12.1, 12.2 |
| 2 | UART Loopback on Hardware | 25 min | 12.3 |
| 3 | SPI Master Module | 30 min | 12.4, 12.5 |
| 4 | UART-Controlled LED Pattern | 15 min | 12.3 |
| 5 | UART-to-SPI Bridge (Stretch) | 15 min | 12.4, 12.5 |

### Ex 1 — UART RX

- **Note:** This exercise has no automated `make test` grader — its reference solution ships unencrypted in `solution/`.

### Ex 2 — Loopback

- **Self-check:** `cd ex2_loopback/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.

### Ex 3 — SPI Master

- **Note:** This exercise has no automated `make test` grader — its reference solution ships unencrypted in `solution/`.

## Deliverables
1. UART RX with all test bytes passing in simulation
2. **Loopback working on hardware** — type on PC, see echo (crown jewel!)
3. SPI master verified in simulation

## Build Commands Quick Reference

```bash
# ── from labs/week3_day12/exN_*/starter/ ──
make test                            # run published self-checking testbench (PASS/FAIL)
```
