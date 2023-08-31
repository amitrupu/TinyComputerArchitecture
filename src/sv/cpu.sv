module cpu #(addr_width = 8, data_width = 8) (input clk, rst, output reg write,
	output reg [addr_width-1:0] addr,
	output reg [data_width-1:0] wdata, input [data_width-1:0] rdata);
typedef enum {
	nop = 0, mova, movb, movam, movbm, movm, add, sub, mult, div, halt
} opcode_type;
typedef enum {
	init = 0, fetch_decode, move_data, move_from_mem, move_to_mem, stop
} state_type;
reg [addr_width-1:0] pc;
reg [data_width-1:0] a, b, ir;
state_type state;
reg op_a;
always_comb
begin
	case (state)
		move_from_mem:
		begin
			addr = rdata;
			wdata = 0;
			write = 1'b0;
			ir = 0;
		end
		move_to_mem:
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
always_ff @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		pc <= 0;
		state <= init;
	end
	else
	begin
		case (state)
			init:
			begin
				state <= fetch_decode;
				pc <= pc+1;
			end
			fetch_decode: 
			begin
				case (ir)
					mova:
					begin
						state <= move_data;
						op_a <= 1'b1;
					end
					movb:
					begin
						state <= move_data;
						op_a <= 1'b0;
					end
					movam:
					begin
						state <= move_from_mem;
						op_a <= 1'b1;
					end
					movbm:
					begin
						state <= move_from_mem;
						op_a <= 1'b0;
					end
					movm: state <= move_to_mem;
					add: a <= a+b;
					sub: a <= a-b;
					mult: a <= a*b;
					div: a <= a/b;
					halt: state <= stop;
				endcase
				pc <= pc+1;
			end
			move_data: 
			begin
				if (op_a)
					a <= rdata;
				else
					b <= rdata;
				pc <= pc+1;
				state <= fetch_decode;
			end
			move_from_mem: state <= move_data;
			move_to_mem: state <= fetch_decode;
			default: state <= stop;
		endcase
	end
end
endmodule
