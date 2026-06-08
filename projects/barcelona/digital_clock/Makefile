# Makefile — top_digital_clock  (Barcelona Final Project scaffold)
# Targets:  make        -> synthesize bitstream (yosys + nextpnr + icepack)
#           make sim    -> compile + run the testbench (iverilog + vvp)
#           make wave   -> run sim then open the VCD in GTKWave
#           make stat   -> yosys resource report
#           make prog   -> flash the Go Board (iceprog)
#           make clean  -> remove build artifacts
PROJECT = top_digital_clock
TOP     = top_digital_clock
PCF     = go_board.pcf
SRCS    = $(wildcard *.v)
TB      = tb_digital_clock.v

DEVICE  = hx1k
PACKAGE = vq100

IVERILOG_FLAGS = -g2012 -Wall

all: $(PROJECT).bin

$(PROJECT).json: $(SRCS)
	yosys -p "synth_ice40 -top $(TOP) -json $@" $(filter-out $(TB),$(SRCS))

$(PROJECT).asc: $(PROJECT).json $(PCF)
	nextpnr-ice40 --$(DEVICE) --package $(PACKAGE) --pcf $(PCF) --json $< --asc $@

$(PROJECT).bin: $(PROJECT).asc
	icepack $< $@

prog: $(PROJECT).bin
	iceprog $<

# Self-checking testbench. Compiles every .v except other testbenches together
# with $(TB) so the DUT and its helper modules are all visible.
sim:
	iverilog $(IVERILOG_FLAGS) -o sim.vvp $(TB) $(filter-out $(TB),$(SRCS)) && vvp sim.vvp

wave: sim
	gtkwave *.vcd &

stat: $(SRCS)
	yosys -p "synth_ice40 -top $(TOP); stat" $(filter-out $(TB),$(SRCS))

clean:
	rm -f *.json *.asc *.bin *.vvp *.vcd *.log

.PHONY: all prog sim wave stat clean
