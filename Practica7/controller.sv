/*
 * This module is the Control Unit of ARM single-cycle processor
 */ 
module controller(input logic clk, reset,
						input logic [31:12] Instr,
						input logic [3:0] ALUFlags,
						output logic [1:0] RegSrc,
						output logic RegWrite,
						output logic [1:0] ImmSrc,
						output logic ALUSrc,
						output logic [2:0] ALUControl,
						output logic MemWrite, MemtoReg,
						output logic PCSrc,
						output logic bl);
	logic [1:0] FlagW,salida3,RegSrca,ImmSrca;
	logic PCS, RegW, MemW,salida1,salida2,salida4,sa1, ALUSrca,bla,MemtoRega,PCSrc_aux1,RegWrite_aux1,MemWrite_aux1,PCSrc_aux2,RegWrite_aux2,MemWrite_aux2;
	logic [2:0] alucon;
	logic [3:0] instrua;
	decoder dec(Instr[27:26], Instr[25:20], Instr[15:12],
					FlagW, PCS, RegW, MemW,
					MemtoRega, ALUSrca, ImmSrc, RegSrca, alucon,bla);
// registro para producir retrasos en la unidad de control que van a la condicional
flopenr #(1) controlc1(clk, reset,1'b1,PCS,salida1);
flopenr #(1) controlc2(clk, reset,1'b1,RegW,salida2);
flopenr #(2) controlc3(clk, reset,1'b1,FlagW,salida3);
flopenr #(1) controlc4(clk, reset,1'b1,MemW,salida4);
// registros para retrasos en la unidad de contro y que van a la salida
flopenr #(3) control1(clk, reset,1'b1,alucon,ALUControl);
flopenr #(2) control2(clk, reset,1'b1,RegSrca,RegSrc);
flopenr #(1) control4(clk, reset,1'b1,ALUSrca,ALUSrc);
flopenr #(1) control5(clk, reset,1'b1,bla,bl);
flopenr #(1) control6(clk, reset,1'b1,MemtoRega,MemtoReg);
// Registros para retrasos ne la inst4ruccion
flopr #(4) inst(clk, reset,Instr[31:28],instrua);

	condlogic cl(clk, reset, instrua, ALUFlags,
					salida3, salida1, salida2, salida4,
					PCSrc_aux1, RegWrite_aux1, MemWrite_aux1);
	//Registros para retrasar la salida de la condicion del condicional logic.
	flopenr #(1) cond1(clk, reset,1'b1,RegWrite_aux1,RegWrite_aux2);
	flopenr #(1) cond2(clk, reset,1'b1,PCSrc_aux1,PCSrc_aux2);
	flopenr #(1) cond3(clk, reset,1'b1,MemWrite_aux1,MemWrite_aux2);
	//segundo retraso en la condicion
	flopenr #(1) cond21(clk, reset,1'b1,RegWrite_aux2,RegWrite);
	flopenr #(1) cond22(clk, reset,1'b1,PCSrc_aux2,PCSrc);
	flopenr #(1) cond23(clk, reset,1'b1,MemWrite_aux2,MemWrite);
endmodule
