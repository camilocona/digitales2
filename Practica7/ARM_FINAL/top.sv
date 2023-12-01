/*
 * This module is the TOP of the ARM single-cycle processor
 */ 
module top(input logic clk, nreset,
			  output logic [31:0] WriteData, DataAdr,
			  output logic MemWrite,
			  input logic [9:0] switches,
			  output logic [9:0] leds);

	// Internal signals
	logic reset;
	assign reset = ~nreset;
	logic [31:0] PC, Instr, ReadData,instruD,dato_auxiliar;
	
	// Instantiate instruction memory
	imem imem(PC, Instr);
	// registro para la memoria de isntrucciones.
	flopenr #(32) Rimem(clk, reset,1'b1,Instr,instruD);
	// Registros para la memoria de isntrucciones.
	flopenr #(32) Rdmem(clk, reset, 1'b1,dato_auxiliar,ReadData);
	// Instantiate data memory (RAM + peripherals)
	dmem dmem(clk, MemWrite, DataAdr, WriteData, dato_auxiliar, switches, leds);
	// registro para antes de la memoria y que viene de la ALU
	
	// Instantiate processor
	arm arm(clk, reset, PC, instruD, MemWrite, DataAdr, WriteData, ReadData);
endmodule