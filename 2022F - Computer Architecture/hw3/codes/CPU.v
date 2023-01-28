module CPU
(
    clk_i,
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] instr, pc, pc_next;
wire zero;
wire [1:0] ALUOp;
wire [2:0] ALUCtrl;
wire ALUSrc, RegWrite;
wire [31:0] RS1data, RS2data;
wire [31:0] IMMdata;
wire [31:0] ALUrst;
wire [31:0] ALUdata2_i;


Control Control(
    .ALUOp_o    (ALUOp),
    .ALUSrc_o   (ALUSrc),
    .RegWrite_o (RegWrite),
    .Op_i       (instr[6:0])
);

Adder Add_PC(
    .data_o     (pc_next),
    .data1_i    (pc),
    .data2_i    (32'd4)
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (pc_next),
    .pc_o       (pc)
);

Instruction_Memory Instruction_Memory(
    .addr_i     (pc),
    .instr_o    (instr)
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i   (instr[19:15]),
    .RS2addr_i   (instr[24:20]),
    .RDaddr_i   (instr[11:7]),
    .RDdata_i   (ALUrst),
    .RegWrite_i (RegWrite),
    .RS1data_o   (RS1data),
    .RS2data_o   (RS2data)
);

MUX32 MUX_ALUSrc(
    .data_o     (ALUdata2_i),
    .data1_i    (RS2data),
    .data2_i    (IMMdata),
    .select_i   (ALUSrc)
);

Sign_Extend Sign_Extend(
    .data_o     (IMMdata),
    .data_i     (instr[31:20])
);

ALU ALU(
    .data_o     (ALUrst),
    .Zero_o     (zero),
    .data1_i    (RS1data),
    .data2_i    (ALUdata2_i),
    .ALUCtrl_i  (ALUCtrl)
);

ALU_Control ALU_Control(
    .funct_i    ({instr[31:25], instr[14:12]}),
    .ALUOp_i    (ALUOp),
    .ALUCtrl_o  (ALUCtrl)
);

endmodule

