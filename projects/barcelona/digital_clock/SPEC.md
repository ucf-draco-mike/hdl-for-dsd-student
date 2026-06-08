# Seconds Clock with Set Mode — Specification

**Difficulty:** ★★☆  ·  **Stretch option**  ·  Skills: **build an FSM** · **extend a testbench** · **sequential + combinational logic**

> A 00–59 s clock with a SET mode for adjusting the time by hand.

## What it does

A 00–59 s clock with a SET mode for adjusting the time by hand. The design runs on the Nandland Go Board and uses **both** 7-segment displays.

## Board I/O (Go Board)

| Signal | Role |
|--------|------|
| `SW1` | mode (RUN ↔ SET) |
| `SW2` | +1 second (in SET) |
| `SW4` | reset |
| `LED1` | SET-mode indicator |
| `LED4` | heartbeat |
| `7-seg #1` | seconds tens digit |
| `7-seg #2` | seconds ones digit |

## Required behaviour

**Control FSM.** `S_RUN ↔ S_SET`. Timekeeping pauses while you set the clock.

**Sequential logic.** A 1 Hz divider (**provided**, paused during SET) and a 00–59 BCD counter you add.

**Combinational logic.** The mode next-state logic, `o_setting`, and the “advance one second” select (`w_step`).

## What you build

The scaffold compiles and the testbench runs out of the box — it just sits in its reset state until you complete the `TODO` blocks in `digital_clock.v`:

1. Fill the mode-toggle next-state transitions.
2. Implement the 00–59 BCD counter with carry and wrap.

`top_digital_clock.v` (board wiring, both displays) is already complete — your work is in `digital_clock.v`.

## Files

| File | Purpose |
|------|---------|
| `digital_clock.v` | **Core module you build** (FSM + datapath) |
| `top_digital_clock.v` | Board wiring — both 7-seg displays, LEDs, buttons (complete) |
| `tb_digital_clock.v` | Self-checking testbench — active checks + commented scenarios |
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
| **Control** | the RUN/SET FSM |
| **Datapath** | the seconds counter shared by real-time and set-mode ticks |
| **Verification** | extend `tb_digital_clock.v` — see TESTPLAN.md |

Pair up on hardware bring-up — the demo is a team result.

## Deliverables

1. Working demo on the Go Board (both displays driven).
2. Completed `digital_clock.v` following course style (`i_`/`o_`/`r_`/`w_`).
3. An **extended** `tb_digital_clock.v` (the commented scenarios enabled + at least one of your own).
4. A short PPA snapshot (`make stat`: LUT / FF counts) and one or two sentences on what dominates.

## Stretch goals

- Extend to a full `HH:MM` clock; toggle which pair shows on the two displays.
- Add a separate set-minutes button.
- Add a one-LED alarm at a settable time.
- Add 12/24-hour modes.
