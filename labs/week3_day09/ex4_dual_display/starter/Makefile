# Makefile — dual_rom
PROJECT  = dual_rom
TOP      = dual_rom
PCF      = ../../go_board.pcf

# The reference testbench ships with the solution; pull it in so `make sim`
# works out of the box. You edit the DUT (dual_rom.v), not the testbench.
FETCH_FROM_SOLUTION := tb_dual_rom.v
include ../../../auto_fetch.mk

SRCS     = $(filter-out $(TB),$(wildcard *.v))
TB       = tb_dual_rom.v

DEVICE   = hx1k
PACKAGE  = vq100

IVERILOG_FLAGS = -g2012 -Wall

.DEFAULT_GOAL := all
all: sim

sim: $(TB) $(SRCS)
	iverilog $(IVERILOG_FLAGS) -o sim.vvp $(TB) $(filter-out $(TB),$(SRCS))
	vvp sim.vvp
	@echo "=== Simulation complete ==="

wave: sim
	gtkwave *.vcd &

clean:
	rm -f *.json *.asc *.bin *.vvp *.vcd *.log

# Self-check — see scripts/lab_ctf/README.md
CTF_DIR := ../../../../scripts/lab_ctf

# Run the published self-checking testbench against your DUT and report
# PASS/FAIL (your output is compared to the reference in ../solution/ref/).
test:
	@bash $(CTF_DIR)/check_solution.sh

.PHONY: sim wave synth prog stat clean test all
