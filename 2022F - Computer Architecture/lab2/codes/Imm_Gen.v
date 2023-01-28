`define I_TYPE_alu   7'b0010011
`define I_TYPE_load  7'b0000011
`define S_TYPE       7'b0100011
`define SB_TYPE      7'b1100011

module Imm_Gen
(
    instr_i,
    IMMdata_o
);

input [31:0] instr_i;
output reg [31:0] IMMdata_o;

always@(*) begin
    case(instr_i[6:0])
        `I_TYPE_alu:
        begin
            if (instr_i[14:12] == 3'b000)
                IMMdata_o = {{20{instr_i[31]}}, instr_i[31:20]};
            else if (instr_i[14:12] == 3'b101)
                IMMdata_o = {{27{instr_i[24]}}, instr_i[24:20]};
        end

        `I_TYPE_load:
        begin
            IMMdata_o = {{20{instr_i[31]}}, instr_i[31:20]};
        end

        `S_TYPE:
        begin
            IMMdata_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
        end

        `SB_TYPE:
        begin
            IMMdata_o = {{20{instr_i[31]}}, instr_i[31], instr_i[7], instr_i[30:25], instr_i[11:8]};
        end
    endcase
end





endmodule

    // IMMdata_o[31:12] = {20{instr_i[31]}}; // sign extend
    // case(instr_i[6:0])
    //     `I_TYPE_alu:
    //     begin
    //         if (instr_i[14:12] == 3'b000)
    //             IMMdata_o[11:0] = instr_i[31:20];
    //         else if (instr_i[14:12] == 3'b101)
    //             IMMdata_o[11:0] = {{7{instr_i[24]}}, instr_i[24:20]};
    //     end
    //     `I_TYPE_load:
    //     begin
    //         IMMdata_o[11:0] = instr_i[31:20];
    //     end

    //     `S_TYPE:
    //     begin
    //         IMMdata_o[11:5] = instr_i[31:25];
    //         IMMdata_o[4:0] = instr_i[11:7];
    //     end

    //     `SB_TYPE:
    //     begin
    //         IMMdata_o[11] = instr_i[31];
    //         IMMdata_o[10] = instr_i[7];
    //         IMMdata_o[9:4] = instr_i[30:25];
    //         IMMdata_o[3:0] = instr_i[11:8];
    //     end
    // endcase
