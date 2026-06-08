# Makefile — alu_sv
PROJECT  = alu_sv
TOP      = alu_sv
PCF      = ../../go_board.pcf
SRCS     = alu_sv.sv
TB       = tb_alu_sv.sv

DEVICE   = hx1k
PACKAGE  = vq100

IVERILOG_FLAGS = -g2012 -Wall

all: sim

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
	rm -f *.json *.asc *.bin *.vvp *.vcd *.log

.PHONY: all prog sim wave stat clean
