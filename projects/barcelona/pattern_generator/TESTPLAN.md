# LFSR Light Pattern — Test Plan (verification sheet)

A **high-level** plan, not a script. The shipped `tb_pattern_generator.v` already runs and passes a few reset-state checks; your job is to grow it into real verification as you build.

## Already checked (out of the box)

- The design compiles and the testbench runs to completion.
- Reset puts the design in a known, safe state (the active `check_true` calls).

## Scenarios to add

Uncomment the `TODO` scenarios in the testbench as you implement each piece, then add your own:

| # | Scenario | What it proves |
|---|----------|----------------|
| 1 | Single step while paused changes the pattern | manual advance |
| 2 | Run free → pattern keeps changing | RUN + auto advance, LFSR never sticks at 0 |
| 3 | Toggle pause → pattern holds | RUN → PAUSE |
| 4 | Pattern is periodic (LFSR cycles) | LFSR correctness |

## Coverage checklist

Tick these off — each should be exercised by at least one test:

- [ ] Reset state (paused, seed value)
- [ ] Run/pause toggling
- [ ] Single-step while paused
- [ ] LFSR never reaches all-zeros
- [ ] Auto-advance while running

## Edge cases worth considering

- Single-stepping right up to a pause/run toggle.
- Letting the LFSR run a full period.
- Reset re-seeds to a non-zero value.

## Take it further (verification extensions)

- Ask an AI tool to generate *additional* stimulus, then read the output critically and keep what adds coverage — note any corrections you made.
- Add simple `assert`-style self-checks (a `$display("FAIL ...")` + fail counter is enough).
- Log the LFSR sequence and confirm it visits many distinct values before repeating.
