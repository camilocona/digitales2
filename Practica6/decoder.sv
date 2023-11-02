/*
 * This module is the Decoder of the Control Unit
 */ 
module decoder(input logic [1:0] Op,
					input logic [5:0] Funct,
					input logic [3:0] Rd,
					output logic [1:0] FlagW,
					output logic PCS, RegW, MemW,
					output logic MemtoReg, ALUSrc,
					output logic [1:0] ImmSrc, RegSrc,
					output logic [2:0]ALUControl,
					output logic Shift);	//ALUControl estaba de 2:0 en el solu
					//output logic NoWrite;
					//output logic Shift //LSL, LSR, ROR Y ASR
					//output logic MOV
					//output logic B;
					
	// Internal signals
	logic [9:0] controls;
	logic Branch, ALUOp;

	// Main Decoder
	always_comb
		casex(Op)
											// Data-processing immediate
			2'b00: 	if (Funct[5])	controls = 11'b00001010010;
											// Data-processing register
						else				controls = 11'b00000010010;
											// LDR
			2'b01: 	if (Funct[0])	controls = 11'b00011110000;
											// STR
						else				controls = 11'b10011101000;
											// B 
			2'b10: 	if (~Funct[4])	controls = 11'b01101000100; 
											//BL
						else				controls = 11'b01101000101;
											
			default: 					controls = 11'bx;
		endcase
		
		
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp,bl} = controls;

	// ALU Decoder
	always_comb
	
	//Valores inmediatos
		if (ALUOp) begin // which DP Instr?
			case(Funct[4:1])
				4'b0100: begin ALUControl = 3'b000; // ADD
							Shift = 1'b0;
							end
				4'b0010: begin ALUControl = 3'b001; // SUB
							Shift = 1'b0;
							end
				4'b0000: begin ALUControl = 3'b010; // AND
							Shift = 1'b0;
							end
				4'b1100: begin ALUControl = 3'b011; // ORR
							Shift = 1'b0;
							end
				4'b1101: begin ALUControl = 3'b100; 
							Shift = 1'b1;
							end
				default: begin ALUControl = 3'bx;
							Shift = 1'b0;
							end
							
					endcase
							// 

			// update flags if S bit is set (C & V only for arith)
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & (ALUControl == 3'b000 | ALUControl == 3'b001);
			end 
			else begin
				ALUControl = 3'b000; // add for non-DP instructions
				FlagW = 2'b00; // don't update Flags
				//Shift = 1'b0; // don’t shift
				//NoWrite = 1'b0; // write result
				
			end
			
	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule


