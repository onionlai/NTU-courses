module MUX32 (data_o, data1_i, data2_i, select_i);

output reg [31:0] data_o;
// output [31:0] data_o; //n
//reg [31:0] tmp;
// assign data_o = tmp;

// output [31:0] data_o;
input [31:0] data1_i, data2_i;
input select_i;

always @(*) begin
    data_o <= (select_i == 0) ? data1_i : data2_i;
end
// assign data_o = (select_i == 0) ? data1_i: data2_i;


endmodule