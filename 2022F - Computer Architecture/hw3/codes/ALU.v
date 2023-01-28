`define AND 3'b000
`define OR  3'b001
`define ADD 3'b010
`define MUL 3'b011
`define SLL 3'b100
`define SRAI 3'b101
`define SUB 3'b110
`define XOR 3'b111

module ALU(
    data_o,
    Zero_o,
    data1_i,
    data2_i,
    ALUCtrl_i
);

output reg signed [31:0] data_o;
output Zero_o;
input signed [31:0] data1_i, data2_i;
input  [2:0] ALUCtrl_i;
assign Zero = (data_o == 0);

// always @(ALUCtrl_i or data1_i or data2_i) begin
always @(*) begin
    case (ALUCtrl_i)
        `AND : data_o <= data1_i & data2_i;
        `OR  : data_o <= data1_i | data2_i;
        `ADD : data_o <= data1_i + data2_i;
        `SUB : data_o <= data1_i - data2_i;
        `MUL : data_o <= data1_i * data2_i;
        `SLL : data_o <= data1_i << data2_i;
        `SRAI : data_o <= data1_i >>> data2_i[4:0];
        `XOR : data_o <= data1_i ^ data2_i;
        // default : data_o <= 0;
    endcase
end

endmodule

