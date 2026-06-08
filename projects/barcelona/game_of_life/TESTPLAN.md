# 1-D Cellular Automaton (“Life”) — Test Plan (verification sheet)

A **high-level** plan, not a script. The shipped `tb_game_of_life.v` already runs and passes a few reset-state checks; your job is to grow it into real verification as you build.

## Already checked (out of the box)

- The design compiles and the testbench runs to completion.
- Reset puts the design in a known, safe state (the active `check_true` calls).

## Scenarios to add

Uncomment the `TODO` scenarios in the testbench as you implement each piece, then add your own:

| # | Scenario | What it proves |
|---|----------|----------------|
| 1 | Single step → row evolves, `o_gen` = 1 | the rule + generation counter |
| 2 | Free-run a few generations | RUN + auto advance |
| 3 | Toggle pause → evolution stops | RUN → PAUSE |
| 4 | Known rule/seed gives the expected next row | rule correctness (e.g. Rule 90) |

## Coverage checklist

Tick these off — each should be exercised by at least one test:

- [ ] Reset state (paused, seeded row, gen 0)
- [ ] Single-step one generation
- [ ] Generation counter increments
- [ ] Run/pause toggling
- [ ] Wrapped neighbourhood at the row ends

## Edge cases worth considering

- A row that is all-zeros or all-ones (stable patterns).
- The wrap-around neighbours at bit 0 and bit 7.
- Generation counter wrap at 0xFF.

## Take it further (verification extensions)

- Ask an AI tool to generate *additional* stimulus, then read the output critically and keep what adds coverage — note any corrections you made.
- Add simple `assert`-style self-checks (a `$display("FAIL ...")` + fail counter is enough).
- Seed a single live cell with Rule 90 and check the row reproduces the Sierpinski pattern over successive generations.
