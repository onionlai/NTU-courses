module Ander
(
    data1_i,
    data2_i,
    data_o
);

output data_o;
input  data1_i;
input  data2_i;

assign data_o = data1_i & data2_i;

endmodule