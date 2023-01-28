module EX_MEM
(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    MemRead_i,
    MemWrite_i,
    ALUresult_i,
    RS2data_i,
    Rd_i,
    RegWrite_o,
    MemtoReg_o,
    MemRead_o,
    MemWrite_o,
    ALUresult_o,
    RS2data_o,
    Rd_o
);

input clk_i;
input RegWrite_i;
input MemtoReg_i;
input MemRead_i;
input MemWrite_i;
input [31:0] ALUresult_i;
input [31:0] RS2data_i;
input [4:0] Rd_i;

output reg RegWrite_o;
output reg MemtoReg_o;
output reg MemRead_o;
output reg MemWrite_o;
output reg [31:0] ALUresult_o;
output reg [31:0] RS2data_o;
output reg [4:0] Rd_o;


always@(posedge clk_i) begin
    RegWrite_o  <= RegWrite_i;
    MemtoReg_o  <= MemtoReg_i;
    MemRead_o   <= MemRead_i;
    MemWrite_o  <= MemWrite_i;
    ALUresult_o <= ALUresult_i;
    RS2data_o   <= RS2data_i;
    Rd_o        <= Rd_i;
end

endmodule