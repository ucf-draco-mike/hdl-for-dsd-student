# Reaction-Time Game — Specification

**Difficulty:** ★★☆  ·  **Simplified option**  ·  Skills: **build an FSM** · **extend a testbench** · **sequential + combinational logic**

> Wait a random time for the light, then hit react as fast as you can. Press too early and you foul.

## What it does

Wait a random time for the light, then hit react as fast as you can. Press too early and you foul. The design runs on the Nandland Go Board and uses **both** 7-segment displays.

## Board I/O (Go Board)

| Signal | Role |
|--------|------|
| `SW1` | arm / replay |
| `SW2` | react |
| `SW4` | reset |
| `LED1` | stimulus (“press now!”) |
| `LED2` | FOUL |
| `LED4` | heartbeat |
| `7-seg #1` | reaction time, tens digit |
| `7-seg #2` | reaction time, ones digit |

## Required behaviour

**Control FSM.** `S_IDLE → S_WAIT → S_GO → S_DONE`, with a side exit to `S_FOUL` if you press during the wait.

**Sequential logic.** A 16-bit LFSR and a centisecond divider (both **provided**); the random-wait counter; and the score counter you add.

**Combinational logic.** The next-state logic and the Moore outputs (`o_light`, `o_foul`).

## What you build

The scaffold compiles and the testbench runs out of the box — it just sits in its reset state until you complete the `TODO` blocks in `reaction_timer.v`:

1. Add the `S_WAIT` transitions (early press → `S_FOUL`; wait expired → `S_GO`).
2. Add the `S_GO → S_DONE` transition on a react press.
3. Increment the centisecond score counter while in `S_GO`.

`top_reaction_timer.v` (board wiring, both displays) is already complete — your work is in `reaction_timer.v`.

## Files

| File | Purpose |
|------|---------|
| `reaction_timer.v` | **Core module you build** (FSM + datapath) |
| `top_reaction_timer.v` | Board wiring — both 7-seg displays, LEDs, buttons (complete) |
| `tb_reaction_timer.v` | Self-checking testbench — active checks + commented scenarios |
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
| **Control** | the five-state FSM and outputs |
| **Datapath** | the random-wait load/countdown and the score counter |
| **Verification** | extend `tb_reaction_timer.v` — see TESTPLAN.md |

Pair up on hardware bring-up — the demo is a team result.

## Deliverables

1. Working demo on the Go Board (both displays driven).
2. Completed `reaction_timer.v` following course style (`i_`/`o_`/`r_`/`w_`).
3. An **extended** `tb_reaction_timer.v` (the commented scenarios enabled + at least one of your own).
4. A short PPA snapshot (`make stat`: LUT / FF counts) and one or two sentences on what dominates.

## Stretch goals

- Best-of-three: average several rounds.
- Report each time over UART with `uart_tx`.
- Show the time in true decimal (BCD) instead of hex.
- Add a difficulty switch that shortens the react window.
