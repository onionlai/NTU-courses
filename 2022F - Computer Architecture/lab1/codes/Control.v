`define R_TYPE       7'b0110011
`define I_TYPE_alu   7'b0010011
`define I_TYPE_load  7'b0000011
`define S_TYPE       7'b0100011
`define SB_TYPE      7'b1100011

module Control
(
    NoOp_i,
    Op_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    Branch_o
);

output reg       RegWrite_o;
output reg       MemtoReg_o;
output reg       MemRead_o;
output reg       MemWrite_o;
output reg       ALUSrc_o;
output reg       Branch_o;
output reg [1:0] ALUOp_o;
input            NoOp_i;
input      [6:0] Op_i; // opcode

always@(*) begin
    if (NoOp_i == 0) begin
        case (Op_i)
            `R_TYPE:
            begin
                ALUOp_o     = 2'b10;
                ALUSrc_o    = 0;
                RegWrite_o  = 1;
                MemtoReg_o  = 0;
                MemRead_o   = 0;
                MemWrite_o  = 0;
                Branch_o    = 0;
            end

            `I_TYPE_alu:
            begin
                ALUOp_o     = 2'b11;
                ALUSrc_o    = 1;
                RegWrite_o  = 1;
                MemtoReg_o  = 0;
                MemRead_o   = 0;
                MemWrite_o  = 0;
                Branch_o    = 0;
            end

            `I_TYPE_load:
            begin
                ALUOp_o     = 2'b00;
                ALUSrc_o    = 1;
                RegWrite_o  = 1;
                MemtoReg_o  = 1;
                MemRead_o   = 1;
                MemWrite_o  = 0;
                Branch_o    = 0;
            end

            `S_TYPE:
            begin
                ALUOp_o     = 2'b00;
                ALUSrc_o    = 1;
                RegWrite_o  = 0;
                MemtoReg_o  = 0;
                MemRead_o   = 0;
                MemWrite_o  = 1;
                Branch_o    = 0;
            end

            `SB_TYPE:
            begin
                ALUOp_o     = 2'b01;
                ALUSrc_o    = 0;
                RegWrite_o  = 0;
                MemtoReg_o  = 0;
                MemRead_o   = 0;
                MemWrite_o  = 0;
                Branch_o    = 1;
            end

            default:
            begin
                ALUOp_o     = 2'b00;
                ALUSrc_o    = 0;
                RegWrite_o  = 0;
                MemtoReg_o  = 0;
                MemRead_o   = 0;
                MemWrite_o  = 0;
                Branch_o    = 0;
            end
        endcase
    end
    else begin
        ALUOp_o     = 2'b00;
        ALUSrc_o    = 0;
        RegWrite_o  = 0;
        MemtoReg_o  = 0;
        MemRead_o   = 0;
        MemWrite_o  = 0;
        Branch_o    = 0;
    end
end



endmodule