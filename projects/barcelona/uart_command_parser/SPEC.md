# Serial Command Parser — Specification

**Difficulty:** ★★☆  ·  **Stretch option**  ·  Skills: **build an FSM** · **extend a testbench** · **sequential + combinational logic**

> Parse two-byte serial commands — a LETTER then a DIGIT — and act on them; echo the digit back.

## What it does

Parse two-byte serial commands — a LETTER then a DIGIT — and act on them; echo the digit back. The design runs on the Nandland Go Board and uses **both** 7-segment displays.

## Board I/O (Go Board)

| Signal | Role |
|--------|------|
| `i_uart_rx / o_uart_tx` | USB-serial @ 9600 8N1 |
| `SW4` | reset |
| `LED1–3` | low 3 bits of the LED command value |
| `LED4` | heartbeat |
| `7-seg #1` | command code (1 = L, 2 = D) |
| `7-seg #2` | digit argument 0–9 |

## Required behaviour

**Control FSM.** `S_IDLE → S_ARG → S_APPLY → S_IDLE`. A letter starts a command, a digit completes it, anything else aborts.

**Sequential logic.** The state register and the datapath latches (`o_cmd`, `o_arg`, `o_leds`, echo strobe).

**Combinational logic.** The byte classifier (is-letter / is-digit) and the next-state logic.

> **Note.** The core consumes already-decoded bytes (`i_rx_data` + `i_rx_valid`), so the testbench drives it directly — no serial bit-banging. `uart_rx`/`uart_tx` are wired up in the top for the real board.

## What you build

The scaffold compiles and the testbench runs out of the box — it just sits in its reset state until you complete the `TODO` blocks in `uart_command_parser.v`:

1. Fill the `S_ARG` transitions (digit → `S_APPLY`; other → `S_IDLE`).
2. Latch the digit argument in `S_ARG`.
3. Apply the command in `S_APPLY` (drive LEDs on “L”) and echo the digit.

`top_uart_command_parser.v` (board wiring, both displays) is already complete — your work is in `uart_command_parser.v`.

## Files

| File | Purpose |
|------|---------|
| `uart_command_parser.v` | **Core module you build** (FSM + datapath) |
| `top_uart_command_parser.v` | Board wiring — both 7-seg displays, LEDs, buttons (complete) |
| `tb_uart_command_parser.v` | Self-checking testbench — active checks + commented scenarios |
| `TESTPLAN.md` | Verification plan and coverage checklist |
| `Makefile`, `go_board.pcf` | Build + flash; shared library copies included |

## Build & run

```bash
make sim      # compile + run the testbench
make stat     # yosys resource report (LUTs / FFs)
make          # synthesize the bitstream
make prog     # flash the Go Board
```

## Suggested team split (2–3)

Teams are allowed. A natural division of labour:

| Role | Owns |
|------|------|
| **Control** | the parser FSM |
| **Datapath** | the byte classifier and the command latches/echo |
| **Verification** | extend `tb_uart_command_parser.v` — see TESTPLAN.md |

Pair up on hardware bring-up — the demo is a team result.

## Deliverables

1. Working demo on the Go Board (both displays driven).
2. Completed `uart_command_parser.v` following course style (`i_`/`o_`/`r_`/`w_`).
3. An **extended** `tb_uart_command_parser.v` (the commented scenarios enabled + at least one of your own).
4. A short PPA snapshot (`make stat`: LUT / FF counts) and one or two sentences on what dominates.

## Stretch goals

- Support longer commands (e.g. a 2-digit argument).
- Add more verbs (set brightness, blink rate, reset counters).
- Send a human-readable acknowledgement string back over UART.
- Validate input and report errors over UART.
