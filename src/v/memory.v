`timescale 100 ns/1 ns
module memory(clk, write, addr, wdata, rdata);
parameter addr_width = 8;
parameter data_width = 8;
input clk;
input write;
input [addr_width-1:0] addr;
input [data_width-1:0] wdata;
output [data_width-1:0] rdata;
reg [data_width-1:0] rdata;
reg [data_width-1:0] mem [0:1<<addr_width-1];
always @(posedge clk)
begin
	if (write)
		mem[addr] <= wdata;
	rdata <= mem[addr];
end
endmodule
