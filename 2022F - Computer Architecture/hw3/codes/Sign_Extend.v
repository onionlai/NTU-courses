module Sign_Extend(data_o, data_i);

input      [11:0] data_i;
// output reg [31:0] data_o;
output [31:0] data_o;

// always @(data_i) begin
//     data_o <= { {20{data_i[11]}}, data_i };
// end
assign data_o = { {20{data_i[11]}}, data_i};
endmodule
