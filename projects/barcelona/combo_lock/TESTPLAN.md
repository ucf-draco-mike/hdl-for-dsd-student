# 3-Button Combination Lock — Test Plan (verification sheet)

A **high-level** plan, not a script. The shipped `tb_combo_lock.v` already runs and passes a few reset-state checks; your job is to grow it into real verification as you build.

## Already checked (out of the box)

- The design compiles and the testbench runs to completion.
- Reset puts the design in a known, safe state (the active `check_true` calls).

## Scenarios to add

Uncomment the `TODO` scenarios in the testbench as you implement each piece, then add your own:

| # | Scenario | What it proves |
|---|----------|----------------|
| 1 | Enter the correct 3-press code | IDLE → ONE → TWO → OPEN unlock path |
| 2 | Reset after unlocking | OPEN re-locks on reset |
| 3 | Wrong first press | attempt counter increments, stays at step 0 |
| 4 | Wrong press mid-sequence | drops back to start; re-entry still unlocks |

## Coverage checklist

Tick these off — each should be exercised by at least one test:

- [ ] Reset state (locked, step 0, attempts 0)
- [ ] Each correct-digit transition
- [ ] Unlock on the full code
- [ ] Wrong press logs an attempt and resets progress
- [ ] Attempt counter saturates (does not wrap)

## Edge cases worth considering

- Pressing two buttons in the same cycle (priority encoder behaviour).
- Many wrong attempts in a row (counter saturation).
- Reset while open vs. mid-entry.

## Take it further (verification extensions)

- Ask an AI tool to generate *additional* stimulus, then read the output critically and keep what adds coverage — note any corrections you made.
- Add simple `assert`-style self-checks (a `$display("FAIL ...")` + fail counter is enough).
- Sweep all 27 possible 3-press sequences and check only the secret one opens.
