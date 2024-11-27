all: visualize

visualize: simulate
	gtkwave test.fst

simulate: compile
	vvp test.vvp -fst

compile:
	iverilog -otest.vvp tb.v Register_File.v

clean:
	rm -f test.fst test.vpp