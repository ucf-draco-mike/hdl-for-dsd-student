# Makefile — uart_rx
PROJECT  = uart_rx
TOP      = uart_rx
PCF      = ../../go_board.pcf

# tb_uart_rx.v drives the receiver with a uart_tx instance, so the transmitter
# is pulled from the shared library rather than duplicated here.
FETCH_FROM_SHARED := uart_tx.v
include ../../../auto_fetch.mk

SRCS     = uart_rx.v $(FETCH_FROM_SHARED)
TB       = tb_uart_rx.v

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
