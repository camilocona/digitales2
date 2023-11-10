/*
 * This module is the Datapath Unit of the ARM single-cycle processor
 */ 
module datapath(input logic clk, reset, bl,
					 input logic [1:0] RegSrc,
					 input logic RegWrite,
					 input logic [1:0] ImmSrc,
					 input logic ALUSrc,
					 input logic [2:0] ALUControl, //Corrección aquí, ALUControl estaba [1:0]
					 input logic MemtoReg,
					 input logic PCSrc,
					 output logic [3:0] ALUFlags,
					 output logic [31:0] PC,
					 input logic [31:0] Instr,
					 output logic [31:0] ALUResult, WriteData,
					 input logic [31:0] ReadData);

// Internal signals
	logic [31:0] PCNext, PCPlus4, PCPlus8;
	logic [31:0] ExtImm, SrcA, SrcB, Result, salida_mux, eleccion_pc;
	logic [3:0] RA1, RA2;
	logic [31:0] output_shift;	//Salida del shift

	
	// next PC logic
	mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext);
	flopr #(32) pcreg(clk, reset, PCNext, PC);
	adder #(32) pcadd1(PC, 32'b100, PCPlus4);
	adder #(32) pcadd2(PCPlus4, 32'b100, PCPlus8);

	// register file logic
	mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1);
	mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2);
	regfile rf(clk, RegWrite, RA1, RA2, salida_mux, eleccion_pc, PCPlus8, SrcA, WriteData);
	mux2 #(32) resmux(ALUResult, ReadData, MemtoReg, Result);
	extend ext(Instr[23:0], ImmSrc, ExtImm);
	
	// Desplazamiento y rotación
	shift despl(WriteData, Instr[11:5], output_shift);
	mux2 #(32) srcbmux(output_shift, ExtImm, ALUSrc, SrcB);
	
	// ALU logic
	alu #(32) alur(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);

	// MUX PARA B Y BL
	// MUX para el pc+4
	mux2 #(32) pc(Result,PCPlus4,bl,eleccion_pc);
	// MUX para elegir el registro 11
	mux2 #(4) reg11(Instr[15:12], 4'b1110,bl,salida_mux);
	

endmodule
