module Left_Shifter
(
    data_i,
    data_o
);

input [31:0] data_i;
output [31:0] data_o;

parameter shift = 1;

assign data_o = data_i << shift;

endmodule
