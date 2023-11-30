 //Modulo para LSL, LSR, ASR y ROR

module shift (
	input logic [31:0] Entrada,
	input logic [6:0] instr,
	output logic [31:0] salida
);

	logic [1:0] control;

	assign control = instr [1:0];

	always_comb begin
		case (control)
		2'b00: salida = Entrada << instr [6:2];							//LSL
		2'b01: salida = Entrada >> instr [6:2];							//LSR
		2'b10: salida = Entrada >>> instr [6:2];							//ASR
		2'b11: salida = (Entrada >> instr[6:2]) | (Entrada << (32-instr[6:2]));	//ROR
		endcase
	end
endmodule