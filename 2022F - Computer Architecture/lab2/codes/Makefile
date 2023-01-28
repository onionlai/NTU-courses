SRC=$(wildcard *.v)
OUTPUT=CPU.out

all: $(OUTPUT)

CPU.out: $(SRC)
	iverilog -o $@ $^

wave: $(OUTPUT)
	vvp $<

gtk: $(OUTPUT)
	gtkwave CPU.vcd
clean:
	rm -f $(OUTPUT) *.vcd