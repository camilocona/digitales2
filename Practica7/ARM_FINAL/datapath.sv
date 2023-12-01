/*
 * This module is the Datapath Unit of the ARM single-cycle processor
 */ 
module datapath(input logic clk, reset,bl,
					 input logic [1:0] RegSrc,
					 input logic RegWrite,
					 input logic [1:0] ImmSrc,
					 input logic ALUSrc,
					 input logic [2:0] ALUControl,
					 input logic MemtoReg,
					 input logic PCSrc,
					 output logic [3:0] ALUFlags,
					 output logic [31:0] PC,
					 input logic [31:0] Instr,
					 output logic [31:0] ALUResult, WriteData,
					 input logic [31:0] ReadData);
	// Internal signals
	logic [31:0] PCNext, PCPlus4, PCPlus8;
	logic [31:0] ExtImm, SrcA, SrcB, Result,salida_mux,pc_choice,SrcA_aux,salida_rd2,salida_pc1,salida_pc2,salida_pc3;
	logic [3:0] RA1, RA2,salida_ins,salida_ins1,salida_ins2,salida_ins3, salida_extend;
	logic [31:0] Salida_shift,ALUResult_aux, WriteData_aux,ALUResult_aux1;	//Salida del shift
	// next PC logic
	mux2 #(32) pcmux(PCPlus4, Result, PCSrc, PCNext); //1
	flopr #(32) pcreg2(clk, reset, PCNext, PC);
	adder #(32) pcadd1(PC, 32'b100, PCPlus4); //2

	// register file logic
	mux2 #(4) ra1mux(Instr[19:16], 4'b1111, RegSrc[0], RA1); //3
	mux2 #(4) ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], RA2); //4
	regfile rf(~clk, RegWrite, RA1, RA2, salida_mux, pc_choice, PCPlus4, SrcA, WriteData_aux);
	
	// registro para retraso de aluresult au va hacia el mux
	flopenr #(32) retraso_alu(clk, reset,1'b1,ALUResult,ALUResult_aux1);
	
	mux2 #(32) resmux(ALUResult_aux1, ReadData, MemtoReg, Result);//10
	
	
	extend ext(Instr[23:0], ImmSrc, ExtImm); //9
	//registro para la salida del extend
	flopenr #(32) ectend(clk, reset,1'b1,ExtImm,salida_extend);
	// Registro a la salida B del registerfile.
	
	
	flopenr #(32) pcreg(clk, reset,1'b1,WriteData_aux,salida_rd2);
	
	
	// para implementar la rotacion y desplazamientos
	shift desplazamiento (salida_rd2, Instr[11:5], Salida_shift); //6
	
	// Registros para retraso en la señal del mux de la alu
	
	assign WriteData=salida_rd2;
	
	// mux antes de la entrada a la alu
	mux2 #(32) srcbmux(Salida_shift, salida_extend, ALUSrc, SrcB);
	//Registro a la entrada de la ALU
	flopenr #(32) pcreg1(clk, reset,1'b1,SrcA,SrcA_aux);
	// ALU logic
	alu #(32) alu(SrcA_aux, SrcB, ALUControl, ALUResult_aux, ALUFlags); //8
	
// aca instancio los mux para implementaqr el bl y b
	// mux para el pc+4
	mux2 #(32) pc(Result,PCPlus4,bl,pc_choice);//12
	// mux para elegir el registro 14
	mux2 #(4) reg14(salida_ins3, salida_pc3,bl,salida_mux); //13
	// registros para retrasar el valor de instrcuccion 15:12
	flopenr #(4) instr1(clk, reset,1'b1,Instr[15:12],salida_ins);
	flopenr  #(4) instr2(clk, reset,1'b1,salida_ins,salida_ins2);
	flopenr  #(4) instr3(clk, reset,1'b1,salida_ins2,salida_ins3);
	//registros para retrasar el valor de pc+4
	flopenr  #(4) PC1(clk, reset,1'b1,4'b1110,salida_pc1);
	flopenr  #(4) PC2(clk, reset,1'b1,salida_pc1,salida_pc2);
	flopenr  #(4) PC3(clk, reset,1'b1,salida_pc2,salida_pc3);
	// Registros para la salida de la ALU
	
	
	flopenr  #(32) alu_aux(clk, reset,1'b1,ALUResult_aux,ALUResult);
	//registros 
endmodule