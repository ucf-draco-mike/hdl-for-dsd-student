# Two-Digit Stopwatch (00–99 s) — Test Plan (verification sheet)

A **high-level** plan, not a script. The shipped `tb_stopwatch.v` already runs and passes a few reset-state checks; your job is to grow it into real verification as you build.

## Already checked (out of the box)

- The design compiles and the testbench runs to completion.
- Reset puts the design in a known, safe state (the active `check_true` calls).

## Scenarios to add

Uncomment the `TODO` scenarios in the testbench as you implement each piece, then add your own:

| # | Scenario | What it proves |
|---|----------|----------------|
| 1 | Toggle start → `o_running` asserts and the count climbs | STOP → RUN + counting |
| 2 | Toggle stop → count holds | RUN → STOP |
| 3 | Ones 9 → 0 carries into tens | BCD carry |
| 4 | 99 → 00 wrap | top-of-range wrap |

## Coverage checklist

Tick these off — each should be exercised by at least one test:

- [ ] Reset state (stopped, 00)
- [ ] Start/stop toggling
- [ ] One-second increments
- [ ] Ones→tens carry
- [ ] 99→00 wrap

## Edge cases worth considering

- Stop and resume (does it pick up where it left off?).
- Reset while running.
- Rapid start/stop toggles.

## Take it further (verification extensions)

- Ask an AI tool to generate *additional* stimulus, then read the output critically and keep what adds coverage — note any corrections you made.
- Add simple `assert`-style self-checks (a `$display("FAIL ...")` + fail counter is enough).
- Free-run long enough to walk every tens digit 0–9.
