# 3-Button Combination Lock — Specification

**Difficulty:** ★★☆  ·  **Simplified option**  ·  Skills: **build an FSM** · **extend a testbench** · **sequential + combinational logic**

> Unlock the door by pressing three buttons in the secret order; a wrong press resets you and logs an attempt.

## What it does

Unlock the door by pressing three buttons in the secret order; a wrong press resets you and logs an attempt. The design runs on the Nandland Go Board and uses **both** 7-segment displays.

## Board I/O (Go Board)

| Signal | Role |
|--------|------|
| `SW1 / SW2 / SW3` | code buttons (index 0 / 1 / 2) |
| `SW4` | reset / clear |
| `LED1` | UNLOCKED |
| `LED2` | wrong attempt(s) logged |
| `LED4` | heartbeat |
| `7-seg #1` | wrong-attempt count |
| `7-seg #2` | correct digits so far |

## Required behaviour

**Control FSM.** `S_IDLE → S_ONE → S_TWO → S_OPEN`. A correct press advances; a wrong press drops back to `S_IDLE`. `S_OPEN` stays unlocked until reset.

**Sequential logic.** The state register and a saturating wrong-attempt counter.

**Combinational logic.** A button priority-encoder, the next-state logic with a `w_wrong` flag, the `o_step` decode, and `o_unlocked`.

## What you build

The scaffold compiles and the testbench runs out of the box — it just sits in its reset state until you complete the `TODO` blocks in `combo_lock.v`:

1. Fill the three next-state transitions (`S_IDLE`, `S_ONE`, `S_TWO`), setting `w_wrong` on a bad press.

`top_combo_lock.v` (board wiring, both displays) is already complete — your work is in `combo_lock.v`.

## Files

| File | Purpose |
|------|---------|
| `combo_lock.v` | **Core module you build** (FSM + datapath) |
| `top_combo_lock.v` | Board wiring — both 7-seg displays, LEDs, buttons (complete) |
| `tb_combo_lock.v` | Self-checking testbench — active checks + commented scenarios |
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
| **Control** | the four-state next-state logic and the wrong-press flag |
| **Datapath** | the button encoder, attempt counter, and step/unlock outputs |
| **Verification** | extend `tb_combo_lock.v` — see TESTPLAN.md |

Pair up on hardware bring-up — the demo is a team result.

## Deliverables

1. Working demo on the Go Board (both displays driven).
2. Completed `combo_lock.v` following course style (`i_`/`o_`/`r_`/`w_`).
3. An **extended** `tb_combo_lock.v` (the commented scenarios enabled + at least one of your own).
4. A short PPA snapshot (`make stat`: LUT / FF counts) and one or two sentences on what dominates.

## Stretch goals

- Add a lockout timer that freezes input for a few seconds after N wrong attempts.
- Make the code length a parameter (4- or 5-press combinations).
- Add a “program new code” mode entered with a button chord.
- Add a silent *duress* code that opens but lights a hidden alarm LED.
