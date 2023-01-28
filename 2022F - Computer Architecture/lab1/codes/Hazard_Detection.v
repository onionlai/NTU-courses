module Hazard_Detection
(
    ID_RS1_i,
    ID_RS2_i,
    EX_Rd_i,
    EX_MemRead_i,
    PCWrite_o,
    stall_o,
    NoOp_o
);

input [4:0] ID_RS1_i;
input [4:0] ID_RS2_i;
input [4:0] EX_Rd_i;
input EX_MemRead_i;
output reg PCWrite_o;
output reg stall_o;
output reg NoOp_o;

always @(*) begin
    if (EX_MemRead_i && (ID_RS1_i == EX_Rd_i || ID_RS2_i == EX_Rd_i))
    begin
        stall_o = 1;
        PCWrite_o = 0;
        NoOp_o = 1;
    end

    else
    begin
        stall_o = 0;
        PCWrite_o = 1;
        NoOp_o = 0;
    end
end

endmodule