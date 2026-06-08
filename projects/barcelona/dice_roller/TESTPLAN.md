# Two-Die Electronic Dice — Test Plan (verification sheet)

A **high-level** plan, not a script. The shipped `tb_dice_roller.v` already runs and passes a few reset-state checks; your job is to grow it into real verification as you build.

## Already checked (out of the box)

- The design compiles and the testbench runs to completion.
- Reset puts the design in a known, safe state (the active `check_true` calls).

## Scenarios to add

Uncomment the `TODO` scenarios in the testbench as you implement each piece, then add your own:

| # | Scenario | What it proves |
|---|----------|----------------|
| 1 | Hold the button → `o_rolling` asserts | IDLE → ROLL transition |
| 2 | Release → `o_rolling` clears, faces frozen | ROLL → IDLE + latch |
| 3 | Both faces always in 1–6 during and after a roll | value range / no illegal face |
| 4 | Two separate rolls usually differ | the dice actually randomise |

## Coverage checklist

Tick these off — each should be exercised by at least one test:

- [ ] Reset state (not rolling, legal faces)
- [ ] Enter rolling on button hold
- [ ] Leave rolling on release
- [ ] Face values stay within 1–6
- [ ] Faces freeze when settled

## Edge cases worth considering

- A one-cycle button tap (very short roll).
- Holding the button across many clocks (faces keep changing, stay legal).
- Reset asserted mid-roll.

## Take it further (verification extensions)

- Ask an AI tool to generate *additional* stimulus, then read the output critically and keep what adds coverage — note any corrections you made.
- Add simple `assert`-style self-checks (a `$display("FAIL ...")` + fail counter is enough).
- Roll many times and histogram the faces to argue the dice are reasonably fair.
