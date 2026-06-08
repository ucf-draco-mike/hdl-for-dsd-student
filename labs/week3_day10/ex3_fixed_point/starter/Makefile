# Makefile — Fixed-Point Arithmetic
# Day 10, Exercise 3

SRCS     = fixed_point.v
TB       = tb_fixed_point.v
IVERILOG_FLAGS = -g2012 -Wall

sim: $(TB) $(SRCS)
	iverilog $(IVERILOG_FLAGS) -o sim.vvp $(TB) $(SRCS)
	vvp sim.vvp
	@echo "=== Simulation complete ==="

wave: sim
	gtkwave fixed_point.vcd &

stat:
	yosys -p "read_verilog $(SRCS); synth_ice40 -top fixed_point_demo; stat"

clean:
	rm -f *.json *.asc *.bin *.vvp *.vcd *.log

# Self-check — see scripts/lab_ctf/README.md
CTF_DIR := ../../../../scripts/lab_ctf

# Run the published self-checking testbench against your DUT and report
# PASS/FAIL (your output is compared to the reference in ../solution/ref/).
test:
	@bash $(CTF_DIR)/check_solution.sh

.PHONY: sim wave synth prog stat clean test all
