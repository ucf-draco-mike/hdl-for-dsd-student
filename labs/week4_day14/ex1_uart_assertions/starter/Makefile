# Makefile — uart_tx_asserted
PROJECT  = uart_tx_asserted
TOP      = uart_tx_asserted
PCF      = ../../go_board.pcf

FETCH_FROM_SOLUTION := tb_uart_tx_asserted.sv
include ../../../auto_fetch.mk

SRCS     = uart_tx_asserted.sv
TB       = tb_uart_tx_asserted.sv

DEVICE   = hx1k
PACKAGE  = vq100

IVERILOG_FLAGS = -g2012 -Wall

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
