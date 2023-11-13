
module shift (
	input logic [31:0] entrada,
	input logic [6:0] instruccion,
	output logic [31:0] salida
);

	logic [1:0] control;

	assign control = instruccion [1:0];

	always_comb begin
		case (control)
		2'b00: salida = entrada << instruccion [6:2];							 //LSL
		2'b01: salida = entrada >> instruccion [6:2];							 //LSR
		2'b10: salida = entrada >>> instruccion [6:2];							 //ASR
		2'b11: salida = (entrada >> instruccion [6:2]) | (entrada << (32-instruccion[6:2]));	 //ROR
		endcase
	end
endmodule