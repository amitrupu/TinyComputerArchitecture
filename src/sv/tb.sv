`timescale 100 ns/1 ns
module tb #(addr_width = 8, data_width = 8);
reg clk = 1'b0, rst = 1'b0;
wire write;
wire [addr_width-1:0] addr;
wire [data_width-1:0] wdata, rdata;

cpu #(addr_width, data_width) cpu_inst(.*);
memory #(addr_width, data_width) memory_inst(.*);

initial
begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

initial
begin
	$dumpvars;
`ifndef memory_init
	$readmemh("mem.hex", memory_inst.mem);
	#0 $writememh("memin.hex", memory_inst.mem);
`endif
	rst = 1'b0;
	#10 rst = 1'b1;
	#20 rst = 1'b0;
	#150;
`ifndef memory_init
	$writememh("memout.hex", memory_inst.mem);
`endif
	$finish;
end

property opcode_checker;
	reg [addr_width-1:0] prev_addr;
	disable iff (rst) 
		@(posedge clk) 
			((write == 1'b0) && (cpu_inst.state == 1) &&
			(rdata < 3 || rdata > 5), prev_addr = addr)
				|=> (addr == (prev_addr+1));
endproperty
assert property(opcode_checker) $display($time, ": satisfied");
endmodule
