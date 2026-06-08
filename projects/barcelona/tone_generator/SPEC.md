# 8-Note Melody Sequencer — Specification

**Difficulty:** ★★☆  ·  **Stretch option**  ·  Skills: **build an FSM** · **extend a testbench** · **sequential + combinational logic**

> Step through an 8-note sequence, generating a square-wave tone for a piezo speaker.

## What it does

Step through an 8-note sequence, generating a square-wave tone for a piezo speaker. The design runs on the Nandland Go Board and uses **both** 7-segment displays.

## Board I/O (Go Board)

| Signal | Role |
|--------|------|
| `SW1` | play / stop |
| `SW4` | reset |
| `io_pmod_1` | square-wave output — wire a piezo speaker here |
| `LED1` | sound (flickers at the tone frequency) |
| `LED4` | heartbeat |
| `7-seg #1` | ‘A’ when playing, ‘0’ when stopped |
| `7-seg #2` | current note index 0–7 |

## Required behaviour

**Control FSM.** `S_STOP ↔ S_PLAY`. Playing advances through the note sequence.

**Sequential logic.** A square-wave generator and a per-note duration timer (both **provided**); the note sequencer you add.

**Combinational logic.** The note → half-period lookup, the play/stop next-state logic, and `o_playing`.

## What you build

The scaffold compiles and the testbench runs out of the box — it just sits in its reset state until you complete the `TODO` blocks in `tone_generator.v`:

1. Fill the note → divisor LUT (a C-major scale is given as a hint).
2. Advance the note sequencer 0 → 7 → 0 each note period.
3. Fill the play/stop next-state transitions.

`top_tone_generator.v` (board wiring, both displays) is already complete — your work is in `tone_generator.v`.

## Files

| File | Purpose |
|------|---------|
| `tone_generator.v` | **Core module you build** (FSM + datapath) |
| `top_tone_generator.v` | Board wiring — both 7-seg displays, LEDs, buttons (complete) |
| `tb_tone_generator.v` | Self-checking testbench — active checks + commented scenarios |
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
| **Control** | the play/stop FSM and sequencer |
| **Datapath / DSP** | the note LUT and the square-wave divider |
| **Verification** | extend `tb_tone_generator.v` — see TESTPLAN.md |

Pair up on hardware bring-up — the demo is a team result.

## Deliverables

1. Working demo on the Go Board (both displays driven).
2. Completed `tone_generator.v` following course style (`i_`/`o_`/`r_`/`w_`).
3. An **extended** `tb_tone_generator.v` (the commented scenarios enabled + at least one of your own).
4. A short PPA snapshot (`make stat`: LUT / FF counts) and one or two sentences on what dominates.

## Stretch goals

- Play a real melody from a ROM of {note, duration} pairs.
- Add a tempo control.
- Add octave shifts or two-voice chords (mix two square waves).
- Add rest notes (silence) to the sequence.
