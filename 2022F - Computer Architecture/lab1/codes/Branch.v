module Branch
(
    RS1data_i,
    RS2data_i,
    branch_i,
    result_o
);

input [31:0] RS1data_i;
input [31:0] RS2data_i;
input        branch_i;
output       result_o;

assign result_o = branch_i && (RS1data_i == RS2data_i) ? 1 : 0;

endmodule