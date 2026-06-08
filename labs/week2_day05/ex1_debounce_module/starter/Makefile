# Auto-generated Makefile
TOP      = debounce
SRCS     = debounce.v
TB       = tb_debounce.v
PCF      = ../../go_board.pcf
DEVICE   = hx1k
PACKAGE  = vq100
IVFLAGS  = -g2012 -Wall

sim: $(TB) $(SRCS)
	iverilog $(IVFLAGS) -o sim.vvp $(TB) $(SRCS)
	vvp sim.vvp

wave: sim
	gtkwave *.vcd &

synth: $(SRCS)
	yosys -p "synth_ice40 -top $(TOP) -json $(TOP).json" $(SRCS)

prog: synth
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --pcf $(PCF) --json $(TOP).json --asc $(TOP).asc --freq 25
	icepack $(TOP).asc $(TOP).bin
	iceprog $(TOP).bin

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
