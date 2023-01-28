`define ITYPE 7'b0010011
// `define R-TYPE 7'b0110011

module Control(ALUOp_o, ALUSrc_o, RegWrite_o, Op_i);

output [1:0] ALUOp_o;
output ALUSrc_o, RegWrite_o;
input [6:0] Op_i;

assign ALUOp_o = (Op_i == `ITYPE) ? 2'b11 : 2'b10;
assign ALUSrc_o = (Op_i == `ITYPE) ? 1 : 0;
assign RegWrite_o = 1;

endmodule