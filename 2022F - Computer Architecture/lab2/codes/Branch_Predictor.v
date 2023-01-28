`define STRONGLY_NON_TAKEN  2'b00
`define WEAKLY_NON_TAKEN    2'b01
`define WEAKLY_TAKEN        2'b10
`define STRONGLY_TAKEN      2'b11


module Branch_Predictor
(
    clk_i,
    rst_i,
    ID_Branch_i,
    EX_Branch_i,
    EX_realTaken_i,
    EX_predTaken_i,
    ID_predTaken_o,
    Flush_IF_ID_o,
    Flush_ID_EX_o,
    pc_select_o,
);
input clk_i;
input rst_i;
input EX_realTaken_i;
input EX_Branch_i;
input EX_predTaken_i;
input ID_Branch_i;
output reg ID_predTaken_o;
output reg Flush_ID_EX_o;
output reg Flush_IF_ID_o;
output reg [1:0] pc_select_o;


reg [1:0] state;


always @(posedge clk_i) begin
    if (EX_Branch_i) begin
        // === update state === //
        case (state)
            `STRONGLY_NON_TAKEN:
            begin
                if (EX_realTaken_i)
                    state <= `WEAKLY_NON_TAKEN;
                else
                    state <= `STRONGLY_NON_TAKEN;
            end
            `WEAKLY_NON_TAKEN:
            begin
                if (EX_realTaken_i)
                    state <= `WEAKLY_TAKEN;
                else
                    state <= `STRONGLY_NON_TAKEN;
            end
            `WEAKLY_TAKEN:
            begin
                if (EX_realTaken_i)
                    state <= `STRONGLY_TAKEN;
                else
                    state <= `WEAKLY_NON_TAKEN;
            end
            `STRONGLY_TAKEN:
            begin
                if (EX_realTaken_i)
                    state <= `STRONGLY_TAKEN;
                else
                    state <= `WEAKLY_TAKEN;
            end
        endcase
    end
end

always @(*) begin
    ID_predTaken_o <= (state == `STRONGLY_TAKEN || state == `WEAKLY_TAKEN);

    Flush_IF_ID_o <= 0;
    Flush_ID_EX_o <= 0;
    pc_select_o <= 2'b00;
    if (EX_Branch_i && (EX_realTaken_i != EX_predTaken_i)) begin
        Flush_ID_EX_o <= 1;
        Flush_IF_ID_o <= 1;

        if (EX_realTaken_i)
            pc_select_o <= 2'b11;
        else
            pc_select_o <= 2'b10;
    end

    else if (ID_Branch_i) begin
        if (state == `STRONGLY_NON_TAKEN || state == `WEAKLY_NON_TAKEN) begin
            pc_select_o <= 2'b00;
            // ID_predTaken_o <= 0;
        end
        else begin
            pc_select_o <= 2'b01;
            Flush_IF_ID_o <= 1;
            // ID_predTaken_o <= 1;
        end
    end
end


endmodule
