module alu (A,B,clk,nreset,na,ALUFlags, SEG ,SEG1,SEG2,pulse);
				input logic [4:0] A,B;
				input logic clk,nreset;
				input logic na;
				//na es pulso
				output logic [3:0] ALUFlags;
				output logic [6:0] SEG, SEG1,SEG2;  // SEG2 es en el deco el negativo -
				output logic [3:0] pulse; // Led ALUFlags del pulso
				
logic cout,cout2;				
logic [4:0]	B_inversor; //Complemento a 2 de B
logic zero, negative, carry_out, overflow;
logic [4:0] salidaALU; // Resultado de la operacion
logic [1:0] ALUControl; //SELECCION DE OPERACIONES DEL ALU (ALUControl)
logic [4:0] suma,resultadocomp; //Variable para el signo negativo

//MAIN
count count0(na, clk, nreset, ALUControl);
deco7seg_hexa deco0(resultadocomp, SEG,SEG1); 

//Complemento a 2 de B
always_comb begin 
 if( ALUControl == 2'b01) 
	B_inversor = ~B;
else
	B_inversor = B;
end
 		
assign {cout2,suma} = {1'b0,A} + {1'b0,B_inversor} + ALUControl[0];
// Operaciones 
always_comb begin
cout=0;
    case(ALUControl) 
        2'b00: begin  //SUMA
							salidaALU =suma;
							cout=cout2;
                        pulse  = 4'b0001;
                        end
        2'b01: begin  salidaALU =suma;// A+(-B) RESTA
                      cout=cout2;

								pulse  = 4'b0010;
                        end
        2'b10: begin {cout,salidaALU} = A & B; //AND
                        pulse  = 4'b0100;
								
                        end
        2'b11: begin {cout,salidaALU} = A | B; //OR
                        pulse  = 4'b1000;
			end
    default: begin salidaALU =suma;
							cout=cout2;
						pulse  = 4'b0001;	// 
                        end
    endcase
    end

assign zero = (salidaALU == 5'b00000); 
assign negative = (salidaALU[4] == 1 & ALUControl==1'b0)  ; //asignando el número negativo al primer bit
assign carry_out = (~ALUControl[1]&cout); // Carry 
					//SUMA O RESTA(RANGO)         //XNOR (SI SON = ES 1)    XOR (SI SON != ES 1)                 XOR
assign overflow = (~ALUControl[1]) & (~ (A[4] ^ B[4] ^ ALUControl[0])) &(A[4] ^ salidaALU[4]); //Cuando arece desbordamiento (positivo o negativo)  RANGOS 

assign ALUFlags = {negative, zero, carry_out, overflow};


//MOSTRAR EL MENOS EN EL TERCER DISPLAY 
always_comb begin 
if((ALUControl[1] ==  1'b0)  & salidaALU[4]==1) begin
	resultadocomp=~salidaALU+1;
	SEG2 = 7'b0111111; end
	
else begin
	resultadocomp=salidaALU;
	SEG2 = 7'b1111111; end   //Tercer display apagado
	end
	
endmodule

module testbench();
	logic clk,reset,na;
	logic [6:0] SEG,SEG1,SEG2;
	logic [4:0] A,B;
	logic [3:0] ALUFlags,pulse;
   
	localparam delay = 20ns; //Porque es el periodo de mi clock
	alu tb(A,B,clk,reset,na,ALUFlags, SEG ,SEG1,SEG2,pulse);
	//A,B,clk,nreset,na,ALUFlags, SEG ,SEG1,SEG2,pulse
	initial begin 
		A= 5'b00110;
		B= 5'b00100;
	
		clk = 0;
		na=1; //boton
		reset = 0;
		#(delay);
		reset=1;
		#(delay*20);
		na=0;
		#(delay*2);
		na=1;
		#(delay*20); //para simular 20 ciclos de reloj
		

		na=0;
		reset = 1;
		#(delay*2);
		na=1;
		#(delay*20); //para simular 20 ciclos de reloj
		

		na=0;
		reset = 1;
		#(delay*2);
		na=1;
		#(delay*20); //para simular 20 ciclos de reloj

		$stop;
	end
	
	always #(delay/2) clk = ~clk;
	
	
endmodule


//Carry (Acarreo): Se produce un carry cuando la suma de dos bits resulta en un valor que requiere un bit adicional para ser representado correctamente.
// 00001+00001=00010 
//Overflow (Desbordamiento): Ocurre cuando el resultado de una operación aritmética no puede ser representado correctamente en el número de bits asignados para la representación. 
//10000+10000=100000->6 bits (Overflow)
