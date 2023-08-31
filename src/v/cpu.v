`timescale 100 ns/1 ns
module cpu(clk, rst, write, addr, wdata, rdata);
parameter addr_width = 8;
parameter data_width = 8;
input clk;
input rst;
output write;
output [addr_width-1:0] addr;
output [data_width-1:0] wdata;
input [data_width-1:0] rdata;
reg write;
reg [addr_width-1:0] addr;
reg [data_width-1:0] wdata;
reg [addr_width-1:0] pc;
reg [data_width-1:0] a, b, ir;
`include "cpu.vh"
reg [2:0] state;
reg op_a;
always @(state or rdata or pc or a or b)
begin
	case (state)
		`move_from_mem:
		begin
			addr = rdata;
			wdata = 0;
			write = 1'b0;
			ir = 0;
		end
		`move_to_mem:
		begin
			addr = rdata;
			wdata = a;
			write = 1'b1;
			ir = 0;
		end
		default:
		begin
			addr = pc;
			wdata = 0;
			write = 1'b0;
			ir = rdata;
		end
	endcase
end
always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		pc <= 0;
		state <= `init;
	end
	else
	begin
		case (state)
			`init:
			begin
				state <= `fetch_decode;
				pc <= pc+1;
			end
			`fetch_decode: 
			begin
				case (ir)
					`mova:
					begin
						state <= `move_data;
						op_a <= 1'b1;
					end
					`movb:
					begin
						state <= `move_data;
						op_a <= 1'b0;
					end
					`movam:
					begin
						state <= `move_from_mem;
						op_a <= 1'b1;
					end
					`movbm:
					begin
						state <= `move_from_mem;
						op_a <= 1'b0;
					end
					`movm: state <= `move_to_mem;
					`add: a <= a+b;
					`sub: a <= a-b;
					`mult: a <= a*b;
					`div: a <= a/b;
					`halt: state <= `stop;
				endcase
				pc <= pc+1;
			end
			`move_data: 
			begin
				if (op_a)
					a <= rdata;
				else
					b <= rdata;
				pc <= pc+1;
				state <= `fetch_decode;
			end
			`move_from_mem: state <= `move_data;
			`move_to_mem: state <= `fetch_decode;
			default: state <= `stop;
		endcase
	end
end
endmodule
