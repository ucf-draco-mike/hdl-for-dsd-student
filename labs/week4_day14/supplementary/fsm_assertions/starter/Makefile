# Makefile — traffic_asserted
PROJECT  = traffic_asserted
TOP      = traffic_asserted
PCF      = ../../../go_board.pcf

# The reference testbench ships with the solution; pull it in so `make sim`
# works out of the box. You edit the DUT (traffic_asserted.sv), not the testbench.
FETCH_FROM_SOLUTION := tb_traffic_asserted.sv
include ../../../../auto_fetch.mk

SRCS     = traffic_asserted.sv
TB       = tb_traffic_asserted.sv

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

.PHONY: all prog sim wave stat clean
