# Reaction-Time Game — Test Plan (verification sheet)

A **high-level** plan, not a script. The shipped `tb_reaction_timer.v` already runs and passes a few reset-state checks; your job is to grow it into real verification as you build.

## Already checked (out of the box)

- The design compiles and the testbench runs to completion.
- Reset puts the design in a known, safe state (the active `check_true` calls).

## Scenarios to add

Uncomment the `TODO` scenarios in the testbench as you implement each piece, then add your own:

| # | Scenario | What it proves |
|---|----------|----------------|
| 1 | Arm, wait for the light, react | WAIT → GO → DONE; a finite time is recorded |
| 2 | Press during the wait window | WAIT → FOUL (early-press detection) |
| 3 | Score is zero before GO and counts up during GO | the centisecond counter |
| 4 | Replay returns cleanly to IDLE | DONE/FOUL → IDLE on arm |

## Coverage checklist

Tick these off — each should be exercised by at least one test:

- [ ] Reset state (light off, no foul, value 0)
- [ ] Random wait then stimulus
- [ ] Reaction measured in centiseconds
- [ ] Early-press foul
- [ ] Replay / re-arm

## Edge cases worth considering

- Reacting on the exact cycle the light turns on.
- Never reacting (does the score saturate?).
- Arming again immediately after a foul.

## Take it further (verification extensions)

- Ask an AI tool to generate *additional* stimulus, then read the output critically and keep what adds coverage — note any corrections you made.
- Add simple `assert`-style self-checks (a `$display("FAIL ...")` + fail counter is enough).
- Run several rounds with different LFSR seeds and confirm the wait length varies.
