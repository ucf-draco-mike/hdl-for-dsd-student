# 8-Note Melody Sequencer — Test Plan (verification sheet)

A **high-level** plan, not a script. The shipped `tb_tone_generator.v` already runs and passes a few reset-state checks; your job is to grow it into real verification as you build.

## Already checked (out of the box)

- The design compiles and the testbench runs to completion.
- Reset puts the design in a known, safe state (the active `check_true` calls).

## Scenarios to add

Uncomment the `TODO` scenarios in the testbench as you implement each piece, then add your own:

| # | Scenario | What it proves |
|---|----------|----------------|
| 1 | Play → `o_playing` asserts | STOP → PLAY |
| 2 | Note index advances over time | the note sequencer (0→1→2…) |
| 3 | Stop → output falls silent | PLAY → STOP and `o_sound` low |
| 4 | Note index wraps 7 → 0 | sequence looping |

## Coverage checklist

Tick these off — each should be exercised by at least one test:

- [ ] Reset state (stopped, silent, note 0)
- [ ] Play/stop toggling
- [ ] Note advances each duration
- [ ] Note wraps 7→0
- [ ] Output silent when stopped

## Edge cases worth considering

- Stopping mid-note.
- The note → divisor LUT default (unfilled entries).
- Very short vs. long `NOTE_DUR`.

## Take it further (verification extensions)

- Ask an AI tool to generate *additional* stimulus, then read the output critically and keep what adds coverage — note any corrections you made.
- Add simple `assert`-style self-checks (a `$display("FAIL ...")` + fail counter is enough).
- The audible square wave is slow to simulate — verify the *frequency* on hardware by ear, and note that as a deliberate sim/hardware split.
