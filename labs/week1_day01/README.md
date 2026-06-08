# Day 1 Lab: Welcome to Hardware Thinking

> **Week 1, Session 1** · Accelerated HDL for Digital System Design · UCF ECE

## Overview

| | |
|---|---|
| **Duration** | ~2 hours |
| **Prerequisites** | Pre-class video (40 min): HDL vs. software, synthesis vs. simulation, module anatomy, digital logic refresher |
| **Deliverable** | Buttons-to-LEDs with at least one logic modification, programmed on Go Board |
| **Tools** | Yosys, nextpnr-ice40, icepack, iceprog, Icarus Verilog, GTKWave |

## Learning Objectives

| SLO | Description |
|-----|-------------|
| 1.1 | Explain why `assign` statements execute concurrently, not sequentially |
| 1.3 | Write a syntactically correct Verilog module with ANSI-style ports |
| 1.4 | Execute the full iCE40 toolchain: Yosys → nextpnr → icepack → iceprog |
| 1.5 | Use a `.pcf` file to map HDL signals to physical Go Board pins |
| 1.6 | Predict and verify the behavior of active-high LEDs and buttons |

## Before You Start: Your Working Environment

Every exercise assumes you are working from inside the **course repo**
with the **Nix dev shell active**. If this is your first time, complete
the [Toolchain Setup Guide](../../docs_src/setup.md) first.

**At the start of every lab session, do these four things:**

```bash
# 1. Open a terminal (on Windows: open the Ubuntu/WSL2 terminal).

# 2. cd into your local clone of the course repo.
cd ~/hdl-for-dsd        # adjust if you cloned elsewhere

# 3. Activate the course toolchain (skip if you set up direnv).
nix develop
# You should see the "HDL for Digital System Design — Environment" banner.

# 4. cd into today's lab directory. Every `make exN` command in this
#    lab is run from here.
cd labs/week1_day01
```

Plug in the Go Board now, before running any `make exN prog` targets.

## Exercises

### Setup Verification (15 min)

With the Nix shell active and the Go Board connected, confirm every
tool reports a version. Run each command from `labs/week1_day01/`:

```bash
yosys --version
nextpnr-ice40 --version
icepack -h        # icepack/iceprog have no --version; -h prints usage
iceprog -h
iverilog -V
gtkwave --version
```

If anything reports `command not found`, you are almost certainly
**outside the Nix shell** — re-run `nix develop` from the repo root.
Don't proceed with a broken toolchain.

---

### How to check your work

Each exercise ships a self-checking testbench and a plaintext reference
solution under `solution/`. The starter `Makefile` adds one target:

- `make test` — compiles your DUT against the published testbench and reports
  **PASS/FAIL** by comparing your output to the reference. **Run it from the
  exercise's `starter/` directory.** No keys, flags, or unlocking.

If you get stuck, the worked answer is in each exercise's `../solution/ref/`.

Full background: `scripts/lab_ctf/README.md`.

---

### Simulate before you program (optional but recommended)

Every Day 1 exercise ships a plaintext testbench under
`exN_*/solution/tb/`. From `labs/week1_day01/`:

```bash
make exN_sim     # compile your starter DUT against the published tb, run vvp
make exN_wave    # same, then open the resulting VCD in GTKWave
```

If you drop your own `tb_<top_module>.v` into the exercise's `starter/`
directory, that one wins; otherwise the published testbench is used
automatically. This is the same testbench `make test` runs — using it via `make sim` lets you inspect waveforms as you
debug.

---

### Exercise 1: LED On — The Simplest Possible Design (20 min)

**Goal:** Write, synthesize, and program the absolute minimum Verilog design. Confirm the full toolchain works end-to-end.

- Open `ex1_led_on/starter/ex1_led_on.v` — the module is complete, just review it
- From `labs/week1_day01/`, build and program: `make ex1`
- **Verify on hardware:** LED1 on the Go Board should be lit
- **Self-check:** `cd ex1_led_on/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.
- **Reflection:** What did Yosys actually synthesize here? Run `make ex1_stat` (from `labs/week1_day01/`) to check LUT usage

---

### Exercise 2: Buttons to LEDs — Wires in Hardware (25 min)

**Goal:** Use `assign` to create combinational connections between inputs and outputs.

- Open `ex2_buttons_to_leds/starter/ex2_buttons_to_leds.v` — direct mapping provided
- **Simulate first:** `make ex2_sim` (or `make ex2_wave` for GTKWave) — sweeps all 16 input combos against your DUT
- From `labs/week1_day01/`, build and program: `make ex2`
- **Verify on hardware:** Each button controls its corresponding LED
- **Self-check:** `cd ex2_buttons_to_leds/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.
- **Quick check:** Are any LUTs used? Why or why not?

---

### Exercise 3: Logic Between Buttons and LEDs (30 min)

**Goal:** Implement concurrent combinational logic with multiple independent `assign` statements.

- Open `ex3_button_logic/starter/ex3_button_logic.v` — fill in the `TODO` assignments
- Predict the truth tables **on paper first**, then verify on hardware
- From `labs/week1_day01/`, build and program: `make ex3`
- **Self-check:** `cd ex3_button_logic/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.
- **Discussion:** All four `assign` statements are active simultaneously

| sw1 | sw2 | LED1 (AND) | LED3 (XOR) | LED4 (NOT) |
|-----|-----|-----------|-----------|-----------|
| released | released | ? | ? | ? |
| released | pressed | ? | ? | ? |
| pressed | released | ? | ? | ? |
| pressed | pressed | ? | ? | ? |

---

### Exercise 4: Active-Low Thinking (20 min)

**Goal:** Develop a clean boundary pattern for readable designs.

- Open `ex4_active_low_clean/starter/ex4_active_low_clean.v` — fill in the `TODO` sections
- The pattern: name inputs clearly at the boundary, keep internal logic readable, drive outputs directly
- From `labs/week1_day01/`, build and program: `make ex4`
- **Self-check:** `cd ex4_active_low_clean/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.
- **Compare:** Does this produce more or fewer LUTs than Exercise 3? Run `make ex4_stat`

---

### Exercise 5 — Stretch: Makefile & XOR Pattern (10 min)

**Goal:** Automate the build flow and experiment with more gate combinations.

- Open `ex5_xor_pattern/starter/ex5_xor_pattern.v` — add creative logic combinations
- The day-level `Makefile` in `labs/week1_day01/` dispatches to each exercise's own `Makefile`; open both and skim how `make ex5` becomes `make -C ex5_xor_pattern/starter prog`
- From `labs/week1_day01/`, build and program: `make ex5`
- **Self-check:** `cd ex5_xor_pattern/starter && make test` — passes when your output matches the reference
- **(Optional) Reference:** the worked answer is in `../solution/ref/`.
- **Challenge:** Can you make all 4 LEDs display a unique pattern based on the 4 buttons?

---

## Deliverable Checklist

- [ ] Toolchain verified — all tools report version
- [ ] Exercise 1: LED1 lit on board, `make test` passes
- [ ] Exercise 2: All 4 buttons control corresponding LEDs, `make test` passes
- [ ] Exercise 3: Truth table filled in, verified on hardware, `make test` passes
- [ ] Exercise 4: Active-low pattern implemented and working, `make test` passes
- [ ] At minimum: Exercise 3 or 4 programmed on board with logic modifications

## Quick Reference

All commands run inside the Nix shell (`nix develop` from the repo
root). Programming and stat targets run from the **day directory**;
test targets run from inside an **exercise's `starter/`
directory**.

```bash
cd ~/hdl-for-dsd && nix develop      # once per terminal session

# ── from labs/week1_day01/ ──
make ex1                             # build and program Exercise 1
make ex2                             # build and program Exercise 2
make ex3                             # build and program Exercise 3
make ex4                             # build and program Exercise 4
make ex5                             # build and program Exercise 5 (stretch)
make exN_sim                         # simulate (uses solution/tb/ if no local tb)
make exN_wave                        # simulate + open VCD in GTKWave
make ex1_stat                        # show resource usage for Exercise 1
make clean                           # remove all build artifacts

# ── from labs/week1_day01/exN_*/starter/ ──
make test                            # run published self-checking testbench (PASS/FAIL)
```

`make exN SOLUTION=1` (from the day directory) runs the reference DUT
through the full toolchain. It reads from `solution/ref/`. Plain `make exN`
against your starter runs your own code.
