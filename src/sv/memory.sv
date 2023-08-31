module memory #(addr_width = 8, data_width = 8) (input clk, write,
	input [addr_width-1:0] addr,
	input [data_width-1:0] wdata, output reg [data_width-1:0] rdata);
reg [data_width-1:0] mem [2**addr_width-1:0];
always @(posedge clk)
begin
	if (write)
		mem[addr] <= wdata;
	rdata <= mem[addr];
end
`ifdef memory_init
initial $readmemh("mem.hex", mem);
`endif
endmodule
