# Makefile — AI Constraint-Based Testbench
# Day 14, Exercise 3
#
# Students: set TOP, SRCS, and TB to your project module files.

TOP    ?= your_module
SRCS   ?= your_module.sv
TB     ?= tb_your_module.sv
IVERILOG_FLAGS = -g2012 -Wall

# If the testbench isn't present yet, print guidance instead of dying with a
# cryptic "No rule to make target" error. Once $(TB) exists, sim runs normally.
sim:
	@if [ ! -f "$(TB)" ]; then \
		echo ""; \
		echo "[sim] Testbench $(TB) not found in $$(pwd)."; \
		echo "      Create $(TB): a module that instantiates $(TOP), drives"; \
		echo "      stimulus, dumps a VCD, and calls \$$finish. Then re-run: make sim"; \
		echo ""; \
		exit 0; \
	fi; \
	echo "iverilog $(IVERILOG_FLAGS) -o sim.vvp $(TB) $(filter-out $(TB),$(SRCS))"; \
	iverilog $(IVERILOG_FLAGS) -o sim.vvp $(TB) $(filter-out $(TB),$(SRCS)) && vvp sim.vvp && echo "=== Simulation complete ==="

wave: sim
	gtkwave *.vcd &

clean:
	rm -f *.vvp *.vcd *.log

.PHONY: sim wave clean
