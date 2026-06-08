# Serial Command Parser — Test Plan (verification sheet)

A **high-level** plan, not a script. The shipped `tb_uart_command_parser.v` already runs and passes a few reset-state checks; your job is to grow it into real verification as you build.

## Already checked (out of the box)

- The design compiles and the testbench runs to completion.
- Reset puts the design in a known, safe state (the active `check_true` calls).

## Scenarios to add

Uncomment the `TODO` scenarios in the testbench as you implement each piece, then add your own:

| # | Scenario | What it proves |
|---|----------|----------------|
| 1 | Send "L" then "5" | IDLE → ARG → APPLY; arg latched, LEDs driven |
| 2 | Letter latches the command code | `o_cmd` reflects L vs D |
| 3 | Non-digit after a letter aborts | ARG → IDLE, no action taken |
| 4 | Apply pulses the echo strobe | `o_tx_valid` one-shot |

## Coverage checklist

Tick these off — each should be exercised by at least one test:

- [ ] Reset state (all outputs 0)
- [ ] Letter recognised → ARG
- [ ] Digit completes the command
- [ ] Non-command bytes ignored in IDLE
- [ ] Abort on bad argument
- [ ] Echo strobe pulses once

## Edge cases worth considering

- A digit arriving in IDLE (no command pending).
- Two letters in a row (second aborts the first).
- Lower-case vs. upper-case letters (what does your classifier accept?).

## Take it further (verification extensions)

- Ask an AI tool to generate *additional* stimulus, then read the output critically and keep what adds coverage — note any corrections you made.
- Add simple `assert`-style self-checks (a `$display("FAIL ...")` + fail counter is enough).
- Drive the full top with `uart_rx` at speed in a longer testbench to confirm real serial timing.
