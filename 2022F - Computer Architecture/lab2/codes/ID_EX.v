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
    Branch_i,
    predTaken_i,
    pc_branch_i,
    pc_default_i,
    flush_i,
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
    Rd_o,
    Branch_o,
    predTaken_o,
    pc_branch_o,
    pc_default_o
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
input Branch_i;
input predTaken_i;
input [31:0] pc_branch_i;
input [31:0] pc_default_i;
input flush_i;

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
output reg Branch_o;
output reg predTaken_o;
output reg [31:0] pc_branch_o;
output reg [31:0] pc_default_o;

always@( posedge clk_i ) begin
    if (flush_i) begin
        RegWrite_o  <= 0;
        MemtoReg_o  <= 0;
        MemRead_o   <= 0;
        MemWrite_o  <= 0;
        ALUOp_o     <= 0;
        ALUSrc_o    <= 0;
        RS1data_o   <= 0;
        RS2data_o   <= 0;
        IMMdata_o   <= 0;
        funct_o     <= 0;
        RS1addr_o   <= 0;
        RS2addr_o   <= 0;
        Rd_o        <= 0;
        Branch_o    <= 0;
        predTaken_o <= 0;
        pc_branch_o <= 0;
        pc_default_o<= 0;
    end
    else begin
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

        Branch_o    <= Branch_i;
        predTaken_o <= predTaken_i;
        pc_branch_o <= pc_branch_i;
        pc_default_o<= pc_default_i;
    end
end

endmodule