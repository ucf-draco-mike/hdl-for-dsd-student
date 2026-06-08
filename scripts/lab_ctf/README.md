# Lab self-check (`make test`)

Each lab exercise's `starter/Makefile` has a `make test` target that checks
your work against the reference — no flags, keys, or unlocking. Reference
solutions ship in plaintext under each exercise's `solution/` directory.

There are two graders, both driven by `make test`:

| Grader | Used when | What it does |
|--------|-----------|--------------|
| `check_solution.sh` | You write the **DUT** | Runs the published testbench against your DUT and against the reference DUT (`solution/ref/`), and PASSes if the two produce identical output. |
| `check_solution_mutation.sh` | You write the **testbench** | Runs *your* testbench against the provided good DUT and against each seeded mutant in `solution/mutants/`, and PASSes only if your testbench distinguishes (catches) every mutant. |

`check_solution.sh` automatically delegates to the mutation grader when an
exercise ships a `solution/mutants/` directory.

## Student UX

```bash
cd labs/week1_day01/ex1_led_on/starter

# edit ex1_led_on.v, then:
make test
# → ✅ PASS — your output matches the reference.

# stuck? the worked answer is right next door:
ls ../solution/ref/
```

`make test` runs the *published* testbench; `make sim` runs the testbench that
ships in your `starter/` so you can open waveforms while you debug. They use the
same DUT.

## Exercise layout

```
labs/weekN_dayNN/exX_foo/
  starter/
    Makefile             ← make sim / test / synth / prog
    foo.v                ← you write your DUT here
    tb_foo.v             ← a working-copy testbench (for make sim / waveforms)
  solution/
    Makefile             ← reference build
    ref/foo.v            ← reference DUT (plaintext)
    tb/tb_foo.v          ← published testbench used by `make test`
    mutants/<bug>/foo.v  ← (testbench exercises only) seeded buggy DUTs
```

## How the graders decide PASS/FAIL

- **DUT exercises** — `check_solution.sh` compiles your starter sources against
  the published testbench, does the same for `solution/ref/`, and compares the
  two `vvp` runs. A self-checking testbench makes a wrong DUT diverge, so the
  outputs differ → FAIL. (A purely observational testbench that never prints DUT
  outputs degrades to a "did it compile and run" check — a property of that
  testbench, not the grader.)
- **Testbench exercises** — `check_solution_mutation.sh` runs *your* testbench
  against the good DUT (baseline) and each seeded mutant. A mutant is "caught"
  when your testbench's output differs from the baseline. PASS requires catching
  every mutant; a do-nothing testbench catches none.

Both graders also surface non-colliding `shared/lib/` helpers (e.g. `debounce.v`,
`hex_to_7seg.v`, `uart_tx.v`) so reference DUTs that instantiate them build.

## Exercises without a `make test` grader

A few exercises have no automated grader (analysis/pen-and-paper tasks, or ones
whose simulation needs iCE40 hard blocks Icarus can't model). They ship their
reference material in plaintext and are checked by inspection:

- `week3_day10/ex4_timing_exercise` — pen-and-paper, no RTL.
- `week3_day10/ex5_pll_cdc_stretch` — uses `SB_PLL40_CORE` (iCE40 hard block).
- `week3_day12/ex1_uart_rx`, `week3_day12/ex3_spi_master` — long-running sims.
- `week4_day14/ex3_ai_constraint_tb` — testbench-only, no DUT.
- `week4_day14/ex4_ppa_analysis` — analysis exercise, no testbench.
