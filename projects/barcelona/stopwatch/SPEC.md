# Two-Digit Stopwatch (00–99 s) — Specification

**Difficulty:** ★★☆  ·  **Simplified option**  ·  Skills: **build an FSM** · **extend a testbench** · **sequential + combinational logic**

> Start, stop, and reset a two-digit seconds stopwatch.

## What it does

Start, stop, and reset a two-digit seconds stopwatch. The design runs on the Nandland Go Board and uses **both** 7-segment displays.

## Board I/O (Go Board)

| Signal | Role |
|--------|------|
| `SW1` | start / stop |
| `SW4` | reset (clear to 00) |
| `LED1` | running |
| `LED4` | heartbeat |
| `7-seg #1` | seconds tens digit |
| `7-seg #2` | seconds ones digit |

## Required behaviour

**Control FSM.** `S_STOP ↔ S_RUN`. One button toggles between counting and holding.

**Sequential logic.** A 1 Hz tick divider (**provided**) and a two-digit BCD seconds counter you add.

**Combinational logic.** The run/stop next-state logic and the `o_running` output; the BCD carry is combinational inside the counter.

## What you build

The scaffold compiles and the testbench runs out of the box — it just sits in its reset state until you complete the `TODO` blocks in `stopwatch.v`:

1. Fill the run/stop next-state transitions.
2. Implement the 00–99 BCD counter: ones 0–9, carry into tens, wrap 99 → 00.

`top_stopwatch.v` (board wiring, both displays) is already complete — your work is in `stopwatch.v`.

## Files

| File | Purpose |
|------|---------|
| `stopwatch.v` | **Core module you build** (FSM + datapath) |
| `top_stopwatch.v` | Board wiring — both 7-seg displays, LEDs, buttons (complete) |
| `tb_stopwatch.v` | Self-checking testbench — active checks + commented scenarios |
| `TESTPLAN.md` | Verification plan and coverage checklist |
| `Makefile`, `go_board.pcf` | Build + flash; shared library copies included |

## Build & run

```bash
make sim      # compile + run the testbench
make stat     # yosys resource report (LUTs / FFs)
make          # synthesize the bitstream
make prog     # flash the Go Board
```

## Suggested team split (2–3)

Teams are allowed. A natural division of labour:

| Role | Owns |
|------|------|
| **Control** | the start/stop FSM |
| **Datapath** | the BCD seconds counter and carry |
| **Verification** | extend `tb_stopwatch.v` — see TESTPLAN.md |

Pair up on hardware bring-up — the demo is a team result.

## Deliverables

1. Working demo on the Go Board (both displays driven).
2. Completed `stopwatch.v` following course style (`i_`/`o_`/`r_`/`w_`).
3. An **extended** `tb_stopwatch.v` (the commented scenarios enabled + at least one of your own).
4. A short PPA snapshot (`make stat`: LUT / FF counts) and one or two sentences on what dominates.

## Stretch goals

- Add a lap/split button that freezes the display while the count keeps running.
- Add centiseconds for an `SS.cc` display.
- Switch to an `MM:SS` format.
- Log each lap over UART.
