module Adder(
    data_o,
    data1_i,
    data2_i
);

// output reg [31:0] data_o;
output [31:0] data_o;
input  [31:0] data1_i;
input  [31:0] data2_i;

// always @(data1_i or data2_i) begin
//     $display("change");
//     data_o <= data1_i + data2_i;
// end
assign data_o = data1_i + data2_i;

endmodule
