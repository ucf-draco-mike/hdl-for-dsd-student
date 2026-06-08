# LFSR Light Pattern — Specification

**Difficulty:** ★☆☆  ·  **Stretch option**  ·  Skills: **build an FSM** · **extend a testbench** · **sequential + combinational logic**

> An 8-bit LFSR light show you can run, pause, and single-step.

## What it does

An 8-bit LFSR light show you can run, pause, and single-step. The design runs on the Nandland Go Board and uses **both** 7-segment displays.

## Board I/O (Go Board)

| Signal | Role |
|--------|------|
| `SW1` | run / pause |
| `SW2` | single step (while paused) |
| `SW4` | reset |
| `LED1–3` | low 3 pattern bits |
| `LED4` | heartbeat |
| `7-seg #1` | pattern high nibble |
| `7-seg #2` | pattern low nibble |

## Required behaviour

**Control FSM.** `S_PAUSE ↔ S_RUN`. Running marches automatically; paused steps on the button.

**Sequential logic.** A speed divider (**provided**) and the 8-bit LFSR you add.

**Combinational logic.** The run/pause next-state logic, `o_running`, and the advance select (`w_adv`).

## What you build

The scaffold compiles and the testbench runs out of the box — it just sits in its reset state until you complete the `TODO` blocks in `pattern_generator.v`:

1. Fill the run/pause next-state transitions.
2. Implement one LFSR step (taps 7,5,4,3 → x⁸+x⁶+x⁵+x⁴+1).

`top_pattern_generator.v` (board wiring, both displays) is already complete — your work is in `pattern_generator.v`.

## Files

| File | Purpose |
|------|---------|
| `pattern_generator.v` | **Core module you build** (FSM + datapath) |
| `top_pattern_generator.v` | Board wiring — both 7-seg displays, LEDs, buttons (complete) |
| `tb_pattern_generator.v` | Self-checking testbench — active checks + commented scenarios |
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
| **Control** | the run/pause FSM and step select |
| **Datapath** | the LFSR feedback and register |
| **Verification** | extend `tb_pattern_generator.v` — see TESTPLAN.md |

Pair up on hardware bring-up — the demo is a team result.

## Deliverables

1. Working demo on the Go Board (both displays driven).
2. Completed `pattern_generator.v` following course style (`i_`/`o_`/`r_`/`w_`).
3. An **extended** `tb_pattern_generator.v` (the commented scenarios enabled + at least one of your own).
4. A short PPA snapshot (`make stat`: LUT / FF counts) and one or two sentences on what dominates.

## Stretch goals

- Add a switch to pick between several patterns (Knight Rider, blink, walking-one).
- Add a speed-select that changes `STEP_DIV` live.
- Drive the pattern from a ROM sequence instead of an LFSR.
- Mirror the pattern across both 7-seg displays as a bar graph.
