# Seconds Clock with Set Mode — Test Plan (verification sheet)

A **high-level** plan, not a script. The shipped `tb_digital_clock.v` already runs and passes a few reset-state checks; your job is to grow it into real verification as you build.

## Already checked (out of the box)

- The design compiles and the testbench runs to completion.
- Reset puts the design in a known, safe state (the active `check_true` calls).

## Scenarios to add

Uncomment the `TODO` scenarios in the testbench as you implement each piece, then add your own:

| # | Scenario | What it proves |
|---|----------|----------------|
| 1 | Enter SET, bump seconds with the button | RUN → SET + manual increment |
| 2 | Return to RUN and let time tick | SET → RUN + real-time counting |
| 3 | Ones 9 → 0 carry into tens | BCD carry |
| 4 | 59 → 00 wrap | minute boundary |

## Coverage checklist

Tick these off — each should be exercised by at least one test:

- [ ] Reset state (running, 00)
- [ ] Mode toggle RUN↔SET
- [ ] Manual set increments
- [ ] Real-time ticking
- [ ] 59→00 wrap

## Edge cases worth considering

- Setting past 59 (does it wrap or stop?).
- Toggling mode rapidly.
- Timekeeping paused during SET (no lost/extra seconds).

## Take it further (verification extensions)

- Ask an AI tool to generate *additional* stimulus, then read the output critically and keep what adds coverage — note any corrections you made.
- Add simple `assert`-style self-checks (a `$display("FAIL ...")` + fail counter is enough).
- Confirm a full minute elapses in exactly the expected number of ticks.
