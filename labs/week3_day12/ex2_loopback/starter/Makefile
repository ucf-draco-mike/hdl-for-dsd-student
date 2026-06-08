# Makefile — top_uart_loopback
PROJECT  = top_uart_loopback
TOP      = top_uart_loopback
PCF      = ../../go_board.pcf

FETCH_FROM_SHARED   := uart_tx.v uart_rx.v hex_to_7seg.v
FETCH_FROM_SOLUTION := tb_top_uart_loopback.v
include ../../../auto_fetch.mk

SRCS     = top_uart_loopback.v $(FETCH_FROM_SHARED)
TB       = tb_top_uart_loopback.v

DEVICE   = hx1k
PACKAGE  = vq100

IVERILOG_FLAGS = -g2012 -Wall

all: $(PROJECT).bin

$(PROJECT).json: $(SRCS)
	yosys -p "synth_ice40 -top $(TOP) -json $@" $(SRCS)

$(PROJECT).asc: $(PROJECT).json $(PCF)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --pcf $(PCF) --json $< --asc $@

$(PROJECT).bin: $(PROJECT).asc
	icepack $< $@

prog: $(PROJECT).bin
	iceprog $<

sim: $(TB) $(SRCS)
	iverilog $(IVERILOG_FLAGS) -o sim.vvp $(TB) $(filter-out $(TB),$(SRCS))
	vvp sim.vvp
	@echo "=== Simulation complete ==="

wave: sim
	gtkwave *.vcd &

stat: $(SRCS)
	yosys -p "synth_ice40 -top $(TOP); stat" $(SRCS)

clean:
	rm -f *.json *.asc *.bin *.vvp *.vcd *.log

# Self-check — see scripts/lab_ctf/README.md
CTF_DIR := ../../../../scripts/lab_ctf

# Run the published self-checking testbench against your DUT and report
# PASS/FAIL (your output is compared to the reference in ../solution/ref/).
test:
	@bash $(CTF_DIR)/check_solution.sh

.PHONY: sim wave synth prog stat clean test all
