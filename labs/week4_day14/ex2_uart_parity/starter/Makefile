# Makefile — UART TX Parity Extension
# Day 14, Exercise 2

SRCS     = uart_tx_parity.sv
TB       = tb_uart_tx_parity.sv
PCF      = ../../go_board.pcf
DEVICE   = hx1k
PACKAGE  = vq100
IVERILOG_FLAGS = -g2012 -Wall

sim: $(TB) $(SRCS)
	iverilog $(IVERILOG_FLAGS) -o sim.vvp $(TB) $(SRCS)
	vvp sim.vvp
	@echo "=== Simulation complete ==="

wave: sim
	gtkwave uart_parity.vcd &

# PPA comparison: synthesize both configurations
stat_no_parity:
	@echo "=== PARITY_EN=0 ==="
	yosys -p "read_verilog -sv -DPARITY_EN=0 $(SRCS); synth_ice40 -top uart_tx_parity; stat"

stat_even_parity:
	@echo "=== PARITY_EN=1, PARITY_TYPE=0 (even) ==="
	yosys -p "read_verilog -sv $(SRCS); synth_ice40 -top uart_tx_parity; stat"

stat_both: stat_no_parity stat_even_parity

clean:
	rm -f *.json *.asc *.bin *.vvp *.vcd *.log

# Self-check — see scripts/lab_ctf/README.md
CTF_DIR := ../../../../scripts/lab_ctf

# Run the published self-checking testbench against your DUT and report
# PASS/FAIL (your output is compared to the reference in ../solution/ref/).
test:
	@bash $(CTF_DIR)/check_solution.sh

.PHONY: sim wave synth prog stat clean test all
