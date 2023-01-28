`define AND 3'b000
`define ADD 3'b010
`define MUL 3'b011
`define SLL 3'b100
`define SRAI 3'b101
`define SUB 3'b110
`define XOR 3'b111

module ALU_Control
(
    ALUCtrl_o,
    funct_i,
    ALUOp_i
);

input       [9:0] funct_i;
input       [1:0] ALUOp_i;
output reg  [2:0] ALUCtrl_o;

always @(*) begin
    if (ALUOp_i[1:0] == 2'b11) // I-type
        case(funct_i [2:0]) // funct3
            3'b000: ALUCtrl_o <= `ADD;
            3'b101: ALUCtrl_o <= `SRAI;
        endcase

    else if (ALUOp_i[1:0] == 2'b00) // ld, sd
        ALUCtrl_o <= `ADD;

    else if (ALUOp_i[1:0] == 2'b01) // beq
        ALUCtrl_o <= `SUB;

    else // R-type
        case(funct_i)
            10'b0000000111: ALUCtrl_o <= `AND;
            10'b0000000100: ALUCtrl_o <= `XOR;
            10'b0000000001: ALUCtrl_o <= `SLL;
            10'b0000000000: ALUCtrl_o <= `ADD;
            10'b0100000000: ALUCtrl_o <= `SUB;
            10'b0000001000: ALUCtrl_o <= `MUL;
        endcase
end

endmodule