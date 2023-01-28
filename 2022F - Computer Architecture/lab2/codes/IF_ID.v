module IF_ID
(
    clk_i,
    rst_i,
    pc_i,
    stall_i,
    flush_i,
    instr_i,
    pc_default_i, // next pc default (= pc_o + 4)
    pc_o,
    instr_o,
    pc_default_o
);

input clk_i;
input flush_i;
input stall_i;
input rst_i;
input [31:0] pc_default_i;

input [31:0] instr_i;
input [31:0] pc_i;
output reg [31:0] instr_o;
output reg [31:0] pc_o;
output reg [31:0] pc_default_o;


always@(posedge clk_i or posedge rst_i) begin
    if (!stall_i) begin
        if (flush_i) begin
            instr_o <= 0;
            pc_o <= 0;
            pc_default_o <= 0;
        end
        else begin
            instr_o <= instr_i;
            pc_o <= pc_i;
            pc_default_o <= pc_default_i;
        end
    end
end


endmodule