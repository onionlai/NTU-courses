module CPU
(
    clk_i,
    rst_i,
    start_i
);

// Ports
input       clk_i;
input       rst_i;
input       start_i;

// Wires
// wires in IF stage:
wire [31:0] pc;
wire [31:0] pc_next;
wire [31:0] pc_default;
wire [31:0] pc_branch;
wire [31:0] IF_instr;

// wires in or go out from ID stage & hazard detection unit:
wire [31:0] ID_instr;
wire [31:0] ID_pc;
wire [31:0] ID_IMMdata;
wire [31:0] ID_IMMdata_shift;
wire [31:0] ID_RS1data;
wire [31:0] ID_RS2data;
wire        ID_RegWrite;
wire        ID_MemtoReg;
wire        ID_MemRead;
wire        ID_MemWrite;
wire [1:0]  ID_ALUOp;
wire        ID_ALUSrc;
wire        ID_Branch;

wire        PCWrite;
wire        Stall;
wire        Flush;
wire        NoOp;

// wires in or go out from EX stage & forwarding unit:
wire        EX_RegWrite;
wire        EX_MemtoReg;
wire        EX_MemRead;
wire        EX_MemWrite;
wire [1:0]  EX_ALUOp;
wire        EX_ALUSrc;
wire [31:0] EX_RS1data;
wire [31:0] EX_RS2data;
wire [31:0] EX_IMMdata;
wire [9:0]  EX_funct;
wire [4:0]  EX_RS1addr;
wire [4:0]  EX_RS2addr;
wire [4:0]  EX_Rd;
wire [31:0] EX_forward_RS2data;
wire [31:0] EX_ALUdata1;
wire [31:0] EX_ALUdata2;
wire [31:0] EX_ALUresult;
wire [2:0]  EX_ALUCtrl;
wire [1:0]  ForwardA;
wire [1:0]  ForwardB;

// wires in MEM stage:
wire        MEM_RegWrite;
wire        MEM_MemtoReg;
wire        MEM_MemRead;
wire        MEM_MemWrite;
wire [31:0] MEM_ALUresult;
wire [31:0] MEM_RS2data;
wire [31:0] MEM_MEMdata;
wire [4:0]  MEM_Rd;

// wires in or go out from WB stage:
wire        WB_RegWrite;
wire        WB_MemtoReg;
wire [31:0] WB_ALUresult;
wire [31:0] WB_MEMdata;
wire [4:0]  WB_Rd;
wire [31:0] WB_WRdata;

// Modules
// -- IF -- //
MUX32 PC_MUX
(
    .data1_i    (pc_default),
    .data2_i    (pc_branch),
    .select_i   (Flush),
    .data_o     (pc_next)
);

PC PC
(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .PCWrite_i  (PCWrite),
    .pc_i       (pc_next),
    .pc_o       (pc)
);

Adder Add_PC
(
    .data1_i    (pc),
    .data2_i    (32'd4),
    .data_o     (pc_default)
);

Instruction_Memory Instruction_Memory
(
    .addr_i     (pc),
    .instr_o    (IF_instr)
);

IF_ID IF_ID
(
    .clk_i      (clk_i),
    .start_i    (start_i),
    .pc_i       (pc),
    .stall_i    (Stall),
    .flush_i    (Flush),
    .instr_i    (IF_instr),
    .pc_o       (ID_pc),
    .instr_o    (ID_instr)
);
// -- ID -- //
Left_Shifter Left_Shifter
(
    .data_i     (ID_IMMdata),
    .data_o     (ID_IMMdata_shift)
);

Adder Add_Branch_PC
(
    .data1_i    (ID_IMMdata_shift),
    .data2_i    (ID_pc),
    .data_o     (pc_branch)
);

Hazard_Detection Hazard_Detection
(
    .ID_RS1_i       (ID_instr[19:15]),
    .ID_RS2_i       (ID_instr[24:20]),
    .EX_Rd_i        (EX_Rd),
    .EX_MemRead_i   (EX_MemRead),
    .PCWrite_o      (PCWrite),
    .stall_o        (Stall),
    .NoOp_o         (NoOp)
);

Control Control
(
    .NoOp_i     (NoOp),
    .Op_i       (ID_instr[6:0]),
    .RegWrite_o (ID_RegWrite),
    .MemtoReg_o (ID_MemtoReg),
    .MemRead_o  (ID_MemRead),
    .MemWrite_o (ID_MemWrite),
    .ALUOp_o    (ID_ALUOp),
    .ALUSrc_o   (ID_ALUSrc),
    .Branch_o   (ID_Branch)
);

Registers Registers
(
    .clk_i      (clk_i),
    .RS1addr_i  (ID_instr[19:15]),
    .RS2addr_i  (ID_instr[24:20]),
    .RDaddr_i   (WB_Rd),
    .RDdata_i   (WB_WRdata),
    .RegWrite_i (WB_RegWrite),
    .RS1data_o  (ID_RS1data),
    .RS2data_o  (ID_RS2data)
);

Branch Branch
(
    .RS1data_i  (ID_RS1data),
    .RS2data_i  (ID_RS2data),
    .branch_i   (ID_Branch),
    .result_o   (Flush)
);

Imm_Gen Imm_Gen
(
    .instr_i    (ID_instr),
    .IMMdata_o  (ID_IMMdata)
);


ID_EX ID_EX
(
    .clk_i      (clk_i),
    .RegWrite_i (ID_RegWrite),
    .MemtoReg_i (ID_MemtoReg),
    .MemRead_i  (ID_MemRead),
    .MemWrite_i (ID_MemWrite),
    .ALUOp_i    (ID_ALUOp),
    .ALUSrc_i   (ID_ALUSrc),
    .RS1data_i  (ID_RS1data),
    .RS2data_i  (ID_RS2data),
    .IMMdata_i  (ID_IMMdata),
    .funct_i    ({ID_instr[31:25], ID_instr[14:12]}),
    .RS1addr_i  (ID_instr[19:15]),
    .RS2addr_i  (ID_instr[24:20]),
    .Rd_i       (ID_instr[11:7]),
    .RegWrite_o (EX_RegWrite),
    .MemtoReg_o (EX_MemtoReg),
    .MemRead_o  (EX_MemRead),
    .MemWrite_o (EX_MemWrite),
    .ALUOp_o    (EX_ALUOp),
    .ALUSrc_o   (EX_ALUSrc),
    .RS1data_o  (EX_RS1data),
    .RS2data_o  (EX_RS2data),
    .IMMdata_o  (EX_IMMdata),
    .funct_o    (EX_funct),
    .RS1addr_o  (EX_RS1addr),
    .RS2addr_o  (EX_RS2addr),
    .Rd_o       (EX_Rd)
);

// -- EX -- //
MUX32_4 RS1_MUX
(
    .data1_i    (EX_RS1data),
    .data2_i    (WB_WRdata),
    .data3_i    (MEM_ALUresult),
    .data4_i    (),
    .select_i   (ForwardA),
    .data_o     (EX_ALUdata1)
);

MUX32_4 RS2_MUX
(
    .data1_i    (EX_RS2data),
    .data2_i    (WB_WRdata),
    .data3_i    (MEM_ALUresult),
    .data4_i    (),
    .select_i   (ForwardB),
    .data_o     (EX_forward_RS2data)
);

MUX32 ALUSrc_MUX
(
    .data1_i    (EX_forward_RS2data),
    .data2_i    (EX_IMMdata),
    .select_i   (EX_ALUSrc),
    .data_o     (EX_ALUdata2)
);

ALU ALU
(
    .data1_i    (EX_ALUdata1),
    .data2_i    (EX_ALUdata2),
    .ALUCtrl_i  (EX_ALUCtrl),
    .data_o     (EX_ALUresult)
);

ALU_Control ALU_Control
(
    .funct_i    (EX_funct),
    .ALUOp_i    (EX_ALUOp),
    .ALUCtrl_o  (EX_ALUCtrl)
);

Forwarding_Unit Forwarding_Unit
(
    .EX_RS1_i       (EX_RS1addr),
    .EX_RS2_i       (EX_RS2addr),
    .WB_Rd_i        (WB_Rd),
    .WB_RegWrite_i  (WB_RegWrite),
    .MEM_Rd_i       (MEM_Rd),
    .MEM_RegWrite_i (MEM_RegWrite),
    .ForwardA_o     (ForwardA),
    .ForwardB_o     (ForwardB)
);

EX_MEM EX_MEM
(
    .clk_i          (clk_i),
    .RegWrite_i     (EX_RegWrite),
    .MemtoReg_i     (EX_MemtoReg),
    .MemRead_i      (EX_MemRead),
    .MemWrite_i     (EX_MemWrite),
    .ALUresult_i    (EX_ALUresult),
    .RS2data_i      (EX_forward_RS2data),
    .Rd_i           (EX_Rd),
    .RegWrite_o     (MEM_RegWrite),
    .MemtoReg_o     (MEM_MemtoReg),
    .MemRead_o      (MEM_MemRead),
    .MemWrite_o     (MEM_MemWrite),
    .ALUresult_o    (MEM_ALUresult),
    .RS2data_o      (MEM_RS2data),
    .Rd_o           (MEM_Rd)
);
// -- MEM -- //

MEM_WB MEM_WB
(
    .clk_i         (clk_i),
    .RegWrite_i    (MEM_RegWrite),
    .MemtoReg_i    (MEM_MemtoReg),
    .ALUresult_i   (MEM_ALUresult),
    .MEMdata_i     (MEM_MEMdata),
    .Rd_i          (MEM_Rd),
    .RegWrite_o    (WB_RegWrite),
    .MemtoReg_o    (WB_MemtoReg),
    .ALUresult_o   (WB_ALUresult),
    .MEMdata_o     (WB_MEMdata),
    .Rd_o          (WB_Rd)
);

Data_Memory Data_Memory
(
    .clk_i      (clk_i),
    .addr_i     (MEM_ALUresult),
    .MemRead_i  (MEM_MemRead),
    .MemWrite_i (MEM_MemWrite),
    .data_i     (MEM_RS2data),
    .data_o     (MEM_MEMdata)
);

// -- WB -- //


MUX32 MUX_ALUSrc(
    .data1_i    (WB_ALUresult),
    .data2_i    (WB_MEMdata),
    .select_i   (WB_MemtoReg),
    .data_o     (WB_WRdata)
);


endmodule

