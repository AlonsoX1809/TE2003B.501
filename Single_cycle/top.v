module top(
	input clk,
	input rst
);

	wire [31:0] PCNext;
	wire [31:0] PC;
	wire [31:0] Instr;
	wire RegWrite;
	wire [1:0] ImmSrc;
	wire ALUSrc;
	wire MemWrite;
	wire [1:0] ResultSrc;
	wire Branch;
	wire [1:0] ALUOp;
	wire Jump;
	wire [2:0] ALUControl;
	wire [31:0] WD3;
	wire [31:0] RD1;
	wire [31:0] RD2;
	wire [31:0] ImmExt;
	wire [31:0] SrcB;
	wire [31:0] ALUResult;
	wire Zero;
	wire [31:0] ReadData;
	wire [31:0] PCPlus4;
	wire [31:0] PCTarget;
	wire PCSrc;
	
	ProgramCounter mPC (
		.clk(clk),
		.rst(rst),
		.PCNext(PCNext),
		.PC(PC)
	);
	
	instruction_memory mInstMem (
		.clk(clk),
		.A(PC),
		.RD(Instr)
	);
	
	mainDecoder mMD (
		.opcode(Instr[6:0]),
		.RegWrite(RegWrite),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.MemWrite(MemWrite),
		.ResultSrc(ResultSrc),
		.Branch(Branch),
		.ALUOp(ALUOp),
		.Jump(Jump)
	);
	
	ALUdecoder mAd (
		.ALUOp(ALUOp),
		.op(Instr[5]),
		.funct3(Instr[14:12]),
		.funct7(Instr[30]),
		.Control(ALUControl)
	);
	
	RegisterFile mRF (
		.clk(clk),
		.rst(rst),
		.WD3(WD3),
		.WE3(RegWrite),
		.A1(Instr[19:15]),
		.A2(Instr[24:20]),
		.A3(Instr[11:7]),
		.RD1(RD1),
		.RD2(RD2)
	);
	
	extend mex (
		.inst(Instr),
		.ImmSrc(ImmSrc),
		.ImmExt(ImmExt)
	);
	
	 multiplexor #(.N(2)) mmux1 (
        .mux_in ({ImmExt, RD2}),   
        .mux_sel(ALUSrc),           
        .mux_out(SrcB)
    );
	
	ALU mALU(
		.A(RD1),
		.B(SrcB),
		.Control(ALUControl),
		.Result(ALUResult),
		.Zero(Zero)
	);
	
	memory_RAM #(.NBits(32), .NAddr(8)) mDM(
		.clk (clk),
		.rst_a (rst),
		.wr_en (MemWrite),
		.Data_in (RD2),
		.Data_address (ALUResult[7:0]),
		.Data_out (ReadData)
	);
	
	multiplexor #(.N(3)) mmux2 (
        .mux_in ({PCPlus4, ReadData, ALUResult}), 
        .mux_sel(ResultSrc),                       
        .mux_out(WD3)
    );
	
	
	wire [31:0] cuatro;
	assign cuatro = 32'd4;
	sumador sum4(
		.A(PC),
		.B(cuatro),
		.out(PCPlus4)
	);
	
	sumador sumPCtarget(
		.A(PC),
		.B(ImmExt),
		.out(PCTarget)
	);
	
	BranchComparator mBC(
		.Zero(Zero),
		.Branch(Branch),
		.Jump(Jump),
		.PCSrc(PCSrc)
	);
	
	multiplexor #(.N(2)) mmux3 (
        .mux_in ({PCTarget, PCPlus4}), 
        .mux_sel(PCSrc),               
        .mux_out(PCNext)
    );
	
endmodule
