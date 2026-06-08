# Makefile — spi_master
PROJECT  = spi_master
TOP      = spi_master
PCF      = ../../go_board.pcf

# The reference testbench ships with the solution; pull it in so `make sim`
# works out of the box. You edit the DUT (spi_master.v), not the testbench.
FETCH_FROM_SOLUTION := tb_spi_master.v
include ../../../auto_fetch.mk

SRCS     = $(filter-out $(TB),$(wildcard *.v))
TB       = tb_spi_master.v

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

.PHONY: all sim wave clean
