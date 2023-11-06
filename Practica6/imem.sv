/*
 * This module is the Instruction Memory of the ARM single-cycle processor
 */ 
/*module imem(input logic [31:0] a, output logic [31:0] rd);
	// Internal array for the memory (Only 64 32-words)
	logic [31:0] RAM[63:0];

	// The following line loads the program instruction
	// Be careful to have a program longer than the memory available
	initial
		// Uncomment only the following line to load the code from the book (testbench)
		//$readmemh("C:/Digitales2/ARM-SingleCycle/imem_tb_from_book.dat",RAM);
		
		// Uncomment only the following line to load the code given to check peripherals
		// $readmemh("imem_to_test_peripherals.dat",RAM);
		
		// Uncomment only the following line to load the code made by the students
		// $readmemh("imem_made_by_students.dat",RAM);

	assign rd = RAM[a[31:2]]; // word aligned
endmodule*/
