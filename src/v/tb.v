`timescale 100 ns/1 ns
module tb;
parameter addr_width = 8;
parameter data_width = 8;
reg clk, rst;
wire write;
wire [addr_width-1:0] addr;
wire [data_width-1:0] wdata, rdata;
integer i, fd;

cpu #(addr_width, data_width) cpu_inst(clk, rst, write, addr, wdata, rdata);
memory #(addr_width, data_width) memory_inst(clk, write, addr, wdata, rdata);

initial
begin
	clk = 1'b0;
	forever #5 clk = ~clk;
end

task writememh;
input [1023:0] filename;
begin
	fd = $fopen(filename);
	for (i=0; i < (1<<addr_width); i=i+1)
		$fwrite(fd, "%d: %h\n", i, memory_inst.mem[i]);
	$fclose(fd);
end
endtask

initial
begin
	$dumpvars;
	$readmemh("mem.hex", memory_inst.mem);
	writememh("memin.hex");
	rst = 1'b0;
	#10 rst = 1'b1;
	#20 rst = 1'b0;
	#300;
	writememh("memout.hex");
	$finish;
end

endmodule
