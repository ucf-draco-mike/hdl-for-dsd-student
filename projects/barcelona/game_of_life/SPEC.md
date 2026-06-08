# 1-D Cellular Automaton (“Life”) — Specification

**Difficulty:** ★★★  ·  **Stretch option**  ·  Skills: **build an FSM** · **extend a testbench** · **sequential + combinational logic**

> “Life” on a wrapped row of 8 cells: each generation, a Wolfram rule decides every cell’s next state.

## What it does

“Life” on a wrapped row of 8 cells: each generation, a Wolfram rule decides every cell’s next state. The design runs on the Nandland Go Board and uses **both** 7-segment displays.

## Board I/O (Go Board)

| Signal | Role |
|--------|------|
| `SW1` | run / pause |
| `SW2` | single step (while paused) |
| `SW4` | reset (reseed) |
| `LED1` | running |
| `LED2 / LED3` | generation count bits 0 / 1 |
| `LED4` | heartbeat |
| `7-seg #1` | cells [7:4] |
| `7-seg #2` | cells [3:0] |

## Required behaviour

**Control FSM.** `S_PAUSE ↔ S_RUN`. Running evolves automatically; paused advances one generation per button press.

**Sequential logic.** A generation timer (**provided**), the row register (load **provided**), and the generation counter you add.

**Combinational logic.** The next-generation rule — a combinational function of each cell’s 3-cell wrapped neighbourhood — and the next-state logic.

## What you build

The scaffold compiles and the testbench runs out of the box — it just sits in its reset state until you complete the `TODO` blocks in `game_of_life.v`:

1. Implement the next-generation rule: index `RULE` by `{left, centre, right}` for each of the 8 cells.
2. Count generations (wraps at 0xFF).
3. Fill the run/pause next-state transitions.

`top_game_of_life.v` (board wiring, both displays) is already complete — your work is in `game_of_life.v`.

## Files

| File | Purpose |
|------|---------|
| `game_of_life.v` | **Core module you build** (FSM + datapath) |
| `top_game_of_life.v` | Board wiring — both 7-seg displays, LEDs, buttons (complete) |
| `tb_game_of_life.v` | Self-checking testbench — active checks + commented scenarios |
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
| **Datapath** | the neighbourhood rule and the generation counter |
| **Verification** | extend `tb_game_of_life.v` — see TESTPLAN.md |

Pair up on hardware bring-up — the demo is a team result.

## Deliverables

1. Working demo on the Go Board (both displays driven).
2. Completed `game_of_life.v` following course style (`i_`/`o_`/`r_`/`w_`).
3. An **extended** `tb_game_of_life.v` (the commented scenarios enabled + at least one of your own).
4. A short PPA snapshot (`make stat`: LUT / FF counts) and one or two sentences on what dominates.

## Stretch goals

- Seed the row from the switches before running.
- Make the Wolfram rule selectable at runtime (90, 110, 30, …).
- Scroll generations onto a VGA display to draw the Sierpinski triangle.
- Step up to a true 2-D Conway grid stored in block RAM (a serious extension).
