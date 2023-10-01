//Este es un módulo de SystemVerilog que implementa un generador de pulso de un solo ciclo.
module pulse(input logic d, clk, reset, 
				 output logic pulse);
	// Internal signals: outputs from each Flip Flop
	logic q1, q2; //Se definen dos señales internas llamadas q1 y q2. Estas señales representarán las salidas de dos Flip-Flops.
//En un flip-flop tipo D, la salida (q) toma el valor de la entrada de datos (d) en el flanco de subida del reloj (clk).
	// Sequential process to generate one-cycle pulse when signal d becomes 1'b1	
//Este bloque always_ff es un proceso secuencial que se ejecuta en el flanco de subida de clk o cuando reset cambia de 0 a 1.
	always_ff @(posedge clk, posedge reset) begin
		if (reset) begin //Cuando reset es activado (reset es 1), se asigna el valor 0 a q1 y q2.
			q1 <= 0;
			q2 <= 0;
		end else begin //Si reset está desactivado (reset es 0), entonces q1 toma el valor de d y q2 toma ~q1
			q1<=d;
			q2 <= ~q1;
		end
	end

//Aquí, se calcula la salida pulse como la operación AND entre q1 y q2. Esto significa que pulse será 1 solo cuando tanto q1 como q2 sean 1 al mismo tiempo.
	assign pulse = q1 & q2;    
endmodule
