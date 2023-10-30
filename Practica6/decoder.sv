/*
 * This module is the Decoder of the Control Unit
 */ 
module decoder(input logic [1:0] Op,
					input logic [5:0] Funct,
					input logic [3:0] Rd,
					output logic [1:0] FlagW,
					output logic PCS, RegW, MemW,
					output logic MemtoReg, ALUSrc,
					output logic [1:0] ImmSrc, RegSrc, ALUControl //ALUControl estaba de 2:0 en el solu
					output logic NoWrite;
					output logic Shift //LSL, LSR, ROR Y ASR
					output logic MOV
					output logic B);
					
	// Internal signals
	logic [9:0] controls;
	logic Branch, ALUOp;

	// Main Decoder
	always_comb
		casex(Op)
											// Data-processing immediate
			2'b00: 	if (Funct[5])	controls = 10'b0000101001;
											// Data-processing register
						else				controls = 10'b0000001001;
											// LDR
			2'b01: 	if (Funct[0])	controls = 10'b0001111000;
											// STR
						else				controls = 10'b1001110100;
											// B
			2'b10: 						controls = 10'b0110100010;
											// Unimplemented
			default: 					controls = 10'bx;
		endcase
		
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;

	// ALU Decoder
	always_comb
	
	//Valores inmediatos
		if (ALUOp) begin // which DP Instr?
			case(Funct[4:1])
				4'b0100: begin ALUControl = 3'b000; // ADD
									Shift = 1'b0;
									NoWrite = 1'b0;
							end
				4'b0010: begin ALUControl = 3'b001; // SUB
									Shift = 1'b0;
									NoWrite = 1'b0;
							end
				4'b0000: begin ALUControl = 3'b010; // AND
									Shift = 1'b0;
									NoWrite = 1'b0;
							end
				4'b1100: begin ALUControl = 3'b011; // ORR
									Shift = 1'b0;
									NoWrite = 1'b0;
							end	
				4'b1101: begin ALUControl = 3'b000; //MOV, ASR, LSL, LSR, ROR
									Shift = 1'b1;
									NoWrite = 1'b0;
							end				
				4'b0111: begin ALUControl = 3'bxxx; //B salto -> Duda
									Shift = 1'b0;
									NoWrite = 1'b0;
							end
				
				default: ALUControl = 2'bx; // unimplemented
			endcase

			// update flags if S bit is set (C & V only for arith)
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
			end 
			else begin
				ALUControl = 2'b00; // add for non-DP instructions
				FlagW = 2'b00; // don't update Flags
				Shift = 1'b0; // don’t shift
				NoWrite = 1'b0; // write result
				
			end
			
	// PC Logic
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule