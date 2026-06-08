# Two-Die Electronic Dice — Specification

**Difficulty:** ★☆☆  ·  **Simplified option**  ·  Skills: **build an FSM** · **extend a testbench** · **sequential + combinational logic**

> Hold a button to spin two dice; release to let them settle on a face 1–6.

## What it does

Hold a button to spin two dice; release to let them settle on a face 1–6. The design runs on the Nandland Go Board and uses **both** 7-segment displays.

## Board I/O (Go Board)

| Signal | Role |
|--------|------|
| `SW1` | roll — hold to spin |
| `SW4` | reset |
| `LED1` | rolling indicator |
| `LED4` | heartbeat |
| `7-seg #1` | die 1 (1–6) |
| `7-seg #2` | die 2 (1–6) |

## Required behaviour

**Control FSM.** `S_IDLE` (showing a settled roll) ↔ `S_ROLL` (animating while the button is held). Releasing the button latches the current faces.

**Sequential logic.** Two free-running 1–6 counters (the “spin”); a display latch that freezes the faces when you leave `S_ROLL`.

**Combinational logic.** The next-state decode (held → spin, released → settle) and the `o_rolling` status output.

## What you build

The scaffold compiles and the testbench runs out of the box — it just sits in its reset state until you complete the `TODO` blocks in `dice_roller.v`:

1. Advance the *second* die counter so the two dice de-sync (`dice_roller.v`).
2. Fill the two FSM transitions in the next-state block.

`top_dice_roller.v` (board wiring, both displays) is already complete — your work is in `dice_roller.v`.

## Files

| File | Purpose |
|------|---------|
| `dice_roller.v` | **Core module you build** (FSM + datapath) |
| `top_dice_roller.v` | Board wiring — both 7-seg displays, LEDs, buttons (complete) |
| `tb_dice_roller.v` | Self-checking testbench — active checks + commented scenarios |
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
| **Control** | the run/settle FSM and `o_rolling` |
| **Datapath** | the two spin counters and the freeze-on-release latch |
| **Verification** | extend `tb_dice_roller.v` — see TESTPLAN.md |

Pair up on hardware bring-up — the demo is a team result.

## Deliverables

1. Working demo on the Go Board (both displays driven).
2. Completed `dice_roller.v` following course style (`i_`/`o_`/`r_`/`w_`).
3. An **extended** `tb_dice_roller.v` (the commented scenarios enabled + at least one of your own).
4. A short PPA snapshot (`make stat`: LUT / FF counts) and one or two sentences on what dominates.

## Stretch goals

- Replace the plain counters with a 16-bit LFSR seeded by how long the button was held.
- Light an LED when the two dice match (“doubles”).
- Add a slow “tumble” animation that decelerates before stopping.
- Show the *sum* of the dice on the displays instead of the two faces.
