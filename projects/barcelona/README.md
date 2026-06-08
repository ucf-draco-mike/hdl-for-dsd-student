# Barcelona Final Project — Scaffolds

Self-contained starter projects for the Barcelona-edition final project. Each
one is small enough to finish in the build-day window, and every option
exercises the same three skills:

1. **Build out an FSM** — a real control state machine, not just a counter.
2. **Extend a testbench** — the shipped testbench runs and self-checks; you grow it.
3. **Implement sequential *and* combinational logic** — usually as part of the FSM.

> **Teams are welcome.** Work in groups of 2–3. Each project's `SPEC.md` suggests
> a Control / Datapath / Verification split so everyone owns a piece. The demo is
> a team result.

Every option drives **both** of the Go Board's 7-segment displays — look at
[`shared/pcf/go_board.pcf`](../../shared/pcf/go_board.pcf): there are two
(`o_segment1_*` and `o_segment2_*`).

## Pick a project

### Simplified options (start here)

| Project | Difficulty | One-liner |
|---------|:----------:|-----------|
| [`dice_roller/`](dice_roller/) | ★☆☆ | Hold to spin two dice; release to settle on 1–6. |
| [`combo_lock/`](combo_lock/) | ★★☆ | Open a lock by pressing three buttons in the secret order. |
| [`reaction_timer/`](reaction_timer/) | ★★☆ | Wait for the light, then react as fast as you can. |
| [`stopwatch/`](stopwatch/) | ★★☆ | Start/stop a two-digit 00–99 s stopwatch. |

### Stretch options (more moving parts)

| Project | Difficulty | One-liner |
|---------|:----------:|-----------|
| [`digital_clock/`](digital_clock/) | ★★☆ | A 00–59 s clock with a SET mode to adjust the time. |
| [`pattern_generator/`](pattern_generator/) | ★☆☆ | An LFSR light show you can run, pause, and single-step. |
| [`tone_generator/`](tone_generator/) | ★★☆ | Play an 8-note melody on a piezo speaker (PMOD). |
| [`uart_command_parser/`](uart_command_parser/) | ★★☆ | Parse two-byte serial commands and act on them. |
| [`game_of_life/`](game_of_life/) | ★★★ | 1-D cellular automaton (Wolfram rule) on a wrapped 8-cell row. |

You may also propose your own — it just has to exercise the three skills above.

## What's in each directory

```
<project>/
├── SPEC.md           ← specification sheet: behaviour, I/O, what to build, team split
├── TESTPLAN.md       ← verification sheet: scenarios, coverage checklist, extensions
├── <project>.v       ← the core module YOU build (FSM + datapath, with TODOs)
├── top_<project>.v   ← board wiring (both 7-seg displays, LEDs, buttons) — complete
├── tb_<project>.v    ← self-checking testbench: active checks + commented scenarios
├── Makefile          ← make sim / stat / (synth) / prog
├── go_board.pcf      ← pin map (symlink to shared/pcf/go_board.pcf)
└── *.v               ← library copies (debounce, hex_to_7seg, …) — self-contained
```

The scaffold **compiles and the testbench runs from day one** — it just sits in
its reset state until you fill the `TODO` blocks. That means `make sim` works
immediately and you build up from a known-good baseline.

## Get going

```bash
cp -r projects/barcelona/combo_lock ~/my_project   # copy your pick
cd ~/my_project
make sim     # runs the testbench (passes the reset checks out of the box)
# ... open SPEC.md, fill the TODOs in combo_lock.v, uncomment TESTPLAN scenarios ...
make         # synthesize    →    make prog    # flash the board
```

Read **`SPEC.md`** first (what to build), then **`TESTPLAN.md`** (how to prove
it works). The full project brief — timeline, deliverables, rubric, team
policy — is on the website: <https://hdl4dsd.com/barcelona-project/>.
