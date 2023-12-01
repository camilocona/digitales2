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
	logic [1:0] FlagW,FlagWriteE,RegSrcD;
	logic PCS, RegW, MemW,PCSrcE,RegWriteE,MemWriteE, ALUSrcD,bla,MemtoRegD,PCSrc_aux1,RegWrite_aux1,MemWrite_aux1,PCSrc_aux2,RegWrite_aux2,MemWrite_aux2;
	logic [2:0] ALUControlD;
	logic [3:0] CondE;
	decoder dec(Instr[27:26], Instr[25:20], Instr[15:12],
					FlagW, PCS, RegW, MemW,
					MemtoRegD, ALUSrcD, ImmSrc, RegSrcD, ALUControlD,bla);
// registro para producir retrasos en la unidad de control que van a la condicional
flopenr #(1) controlc1(clk, reset,1'b1,PCS,PCSrcE);
flopenr #(1) controlc2(clk, reset,1'b1,RegW,RegWriteE);
flopenr #(2) controlc3(clk, reset,1'b1,FlagW,FlagWriteE);

flopenr #(1) controlc4(clk, reset,1'b1,MemW,MemWriteE);
// registros para retrasos en la unidad de contro y que van a la salida
flopenr #(3) control1(clk, reset,1'b1,ALUControlD,ALUControl);
flopenr #(2) control2(clk, reset,1'b1,RegSrcD,RegSrc);
flopenr #(1) control4(clk, reset,1'b1,ALUSrcD,ALUSrc);
flopenr #(1) control5(clk, reset,1'b1,bla,bl);
flopenr #(1) control6(clk, reset,1'b1,MemtoRegD,MemtoReg);
// Registros para retrasos de la instruccion
flopr #(4) inst(clk, reset,Instr[31:28],CondE);

	condlogic cl(clk, reset, CondE, ALUFlags,
					FlagWriteE, PCSrcE, RegWriteE, MemWriteE,
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
