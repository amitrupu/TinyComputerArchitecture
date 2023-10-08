# TinyComputerArchitecture
Tiny computer architecture having CPU and memory written in Verilog
#### Author: Amit Roy (amitrupu@gmail.com)

RTL source is in:
- src/v directory for Verilog-95
- src/sv directory for System Verilog

For Verilog-95 simulation with free Verilog simulator:
- Download and build Veriwell from <code>https://sourceforge.net/projects/veriwell</code>
- Run: <code>make program=<program_suffix> out=\<suffix></code>

For System Verilog simulation with Synopsys VCS, run: <code>make compile=sim</code>

To simulate using Icarus Verilog, run: <code>make compile=sim.iverilog</code>


