module maquina #(fpga_freq=50_000_000)(clk, nreset, Up, Time, SEG,SEG1);
/* Entradas y salidas*/
	input logic clk, nreset, Up, Time;
	output logic [6:0] SEG, SEG1;
	
	/* Circuito para invertir señal de reloj */
	logic reset;
	assign reset = ~nreset;
	
	logic [3:0] Salida;
	logic clkdiv;
	
	// Generador de señal de relol clk_seconds de 1 hz.
	cntdiv_n #(fpga_freq) cntDiv (clk, reset, Time, clkdiv);
	deco7seg_hexa deco0(Salida, SEG,SEG1); 
	
	/* Definición de estados de la FSM y señales internas para estado actual y siguiente */
	typedef enum logic [2:0] {s0, s1, s2, s3, s4, s5, s6, s7} State;
	State currentState, nextState;
	
	
	/*Circuito secuencial para actualizar estado actual con el estado siguiente  */
	always_ff @(posedge clkdiv, posedge reset) 
		if (reset)
			currentState <= s0;
		else 
			currentState <= nextState;
	/* Circuito combinacional para determinar siguiente estado de la FSM */
   always_comb begin
            case (currentState)
                s0:
                        Salida = 4'b0110;
                s1:
                        Salida = 4'b1000;
                s2:
                        Salida = 4'b1010;
                s3:
                        Salida = 4'b1100;
                s4:
                        Salida = 4'b1110;
                s5:
                        Salida = 4'b0011;
                s6:
                        Salida = 4'b0101;
                s7:
                        Salida = 4'b0111;
              default:
								Salida = 4'b0110;
            endcase
        end
	always_comb begin	
			case (currentState)
				s0:
					if(~Up) begin
						nextState = s1;
						 end
					else begin
						nextState = s7;
						 end
				s1:	
					if(~Up) begin
						nextState = s2;
						 end
					else begin
						nextState = s0;
						end
				s2:	
					if(~Up) begin
						nextState = s3;
					 end
					else begin
						nextState = s1;
						 end
				s3:	
					if(~Up) begin
						nextState = s4;
						 end
					else begin
						nextState = s2;
						 end
				s4:	
					if(~Up) begin
						nextState = s5;
						 end
					else begin
						nextState = s3;
						 end
				s5:	
					if(~Up) begin
						nextState = s6;
						 end
					else begin
						nextState = s4;
						 end
				s6:	
					if(~Up) begin
						nextState = s7;
						end
					else begin
						nextState = s5;
						end
				s7:	
					if(~Up) begin
						nextState = s0;
						 end
					else begin
						nextState = s6;
						 end
						
				default:		
					nextState = s0;
			endcase
		end

endmodule

/* Módulo testbench */
module testbench();
	/* Declaración de señales y variables internas */
	logic clk, reset, Time, Up;
	logic [6:0] SEG,SEG1;
	localparam delay = 20ps;
	localparam fpga_freq=5;
	
	// Instanciar objeto
	maquina #(fpga_freq) tb (clk, reset, Up, Time, SEG,SEG1);
	
	initial begin
		clk = 0;
		reset = 0;
		Up = 1;
		Time = 0;
		#(delay*fpga_freq*8);
		reset=1;
		Up=~Up;
		Time=1;
		#(delay*fpga_freq*8);
		$stop;
	end
	
	always #(delay/2) clk = ~clk;

endmodule
