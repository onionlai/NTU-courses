`define AND 3'b000
`define ADD 3'b010
`define MUL 3'b011
`define SLL 3'b100
`define SRAI 3'b101
`define SUB 3'b110
`define XOR 3'b111

module ALU
(
    data1_i,
    data2_i,
    ALUCtrl_i,
    data_o,
    zero_o,
);

input signed [31:0] data1_i;
input signed [31:0] data2_i;
input        [2:0]  ALUCtrl_i;
output reg signed  [31:0] data_o;
output zero_o;

assign zero_o = (data_o == 0);

always @(*) begin
    case (ALUCtrl_i)
        `AND : data_o <= data1_i & data2_i;
        `ADD : data_o <= data1_i + data2_i;
        `SUB : data_o <= data1_i - data2_i;
        `MUL : data_o <= data1_i * data2_i;
        `SLL : data_o <= data1_i << data2_i;
        `SRAI : data_o <= data1_i >>> data2_i[4:0];
        `XOR : data_o <= data1_i ^ data2_i;
    endcase
end

endmodule

