module ID_EX
(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUOp_i,
    ALUSrc_i,
    RS1data_i,
    RS2data_i,
    IMMdata_i,
    funct_i,
    RS1addr_i,
    RS2addr_i,
    Rd_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUOp_o,
    ALUSrc_o,
    RS1data_o,
    RS2data_o,
    IMMdata_o,
    funct_o,
    RS1addr_o,
    RS2addr_o,
    Rd_o
);

input clk_i;
input [1:0] ALUOp_i;
input ALUSrc_i;
input RegWrite_i;
input MemtoReg_i;
input MemRead_i;
input MemWrite_i;
input [31:0] RS1data_i;
input [31:0] RS2data_i;
input [31:0] IMMdata_i;
input [9:0] funct_i;
input [4:0] RS1addr_i;
input [4:0] RS2addr_i;
input [4:0] Rd_i;

output reg [1:0] ALUOp_o;
output reg ALUSrc_o;
output reg RegWrite_o;
output reg MemtoReg_o;
output reg MemRead_o;
output reg MemWrite_o;
output reg [31:0] RS1data_o;
output reg [31:0] RS2data_o;
output reg [31:0] IMMdata_o;
output reg [9:0] funct_o;
output reg [4:0] RS1addr_o;
output reg [4:0] RS2addr_o;
output reg [4:0] Rd_o;

always@( posedge clk_i ) begin
    RegWrite_o  <= RegWrite_i;
    MemtoReg_o  <= MemtoReg_i;
    MemRead_o   <= MemRead_i;
    MemWrite_o  <= MemWrite_i;
    ALUOp_o     <= ALUOp_i;
    ALUSrc_o    <= ALUSrc_i;
    RS1data_o   <= RS1data_i;
    RS2data_o   <= RS2data_i;
    IMMdata_o   <= IMMdata_i;
    funct_o     <= funct_i;
    RS1addr_o   <= RS1addr_i;
    RS2addr_o   <= RS2addr_i;
    Rd_o        <= Rd_i;
end

endmodule