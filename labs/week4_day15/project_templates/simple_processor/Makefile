# Makefile — top_cpu
PROJECT  = top_cpu
TOP      = top_cpu
PCF      = ../../go_board.pcf
SRCS     = $(wildcard *.v)
TB       = tb_top_cpu.v

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

stat: $(SRCS)
	yosys -p "synth_ice40 -top $(TOP); stat" $(SRCS)

clean:
	rm -f *.json *.asc *.bin *.vvp *.vcd *.log

.PHONY: all prog sim wave stat clean
