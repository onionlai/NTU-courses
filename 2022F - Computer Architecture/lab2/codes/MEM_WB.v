module MEM_WB
(
    clk_i,
    RegWrite_i,
    MemtoReg_i,
    ALUresult_i, // MEMaddr
    MEMdata_i,
    Rd_i,
    RegWrite_o,
    MemtoReg_o,
    ALUresult_o,
    MEMdata_o,
    Rd_o
);

input clk_i;
input RegWrite_i;
input MemtoReg_i;
input [31:0] ALUresult_i;
input [31:0] MEMdata_i;
input [4:0] Rd_i;

output reg RegWrite_o;
output reg MemtoReg_o;
output reg [31:0] ALUresult_o;
output reg [31:0] MEMdata_o;
output reg [4:0] Rd_o;


always @(posedge clk_i) begin
    RegWrite_o <= RegWrite_i;
    MemtoReg_o <= MemtoReg_i;
    ALUresult_o <= ALUresult_i;
    MEMdata_o <= MEMdata_i;
    Rd_o <= Rd_i;
end


endmodule