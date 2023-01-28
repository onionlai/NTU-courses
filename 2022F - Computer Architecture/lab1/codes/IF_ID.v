module IF_ID
(
    clk_i,
    start_i,
    pc_i,
    stall_i,
    flush_i,
    instr_i,
    pc_o,
    instr_o
);

input clk_i;
input flush_i;
input stall_i;
input start_i;

input [31:0] instr_i;
input [31:0] pc_i;
output reg [31:0] instr_o;
output reg [31:0] pc_o;


always@(posedge clk_i) begin
    if (start_i && !stall_i) begin
        if (flush_i) begin
            instr_o <= 0;
            pc_o <= 0;
        end
        else begin
            instr_o <= instr_i;
            pc_o <= pc_i;
        end
    end
end


endmodule