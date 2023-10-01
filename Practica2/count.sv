module count (na, clk, nreset, Salida);
	input logic na, clk, nreset;
	output logic [1:0] Salida; //Contador de los pulsos para el ALU control, para saber en que posición va
	
	
	// Internal signals
	logic a, reset, intPulse;
	logic [1:0] cnt;
	
	// Parallel circuits
	assign reset = ~nreset;
	assign a = ~na; //Pulsos activo bajo
	pulse p0 (a, clk, reset, intPulse);
	//deco7seg_hexa deco0 (cnt, disp);
	
	// Counter process. Activates each time intPulse is 1'b1
	always_ff @(posedge clk, posedge reset) begin
		if (reset)
			cnt <= 0;
		else if (intPulse)
			cnt <= cnt + 1;
	end
	assign Salida = cnt;
	
endmodule
