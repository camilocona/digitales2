// *******************
// Control Unit Module
// *******************
module controlunit (clk, reset, loaddata, inputdata_ready);
	input logic  clk, reset;
	output logic  loaddata;
	input logic inputdata_ready;
	
	//Carga de datos / Multiplicacion
	typedef enum logic [2:0] {s0, s1} State;
	State currentState, nextState;

	always_ff @(posedge reset) 
		if (reset)
			currentState <= s0;
		else 
			currentState <= nextState;
			
	// Se declara la maquina de estados para la carga de datos y la multiplicacion
	always_comb begin	
			case (currentState)
				s0:
					if(inputdata_ready==0) begin //cargando datos
						nextState=s0;
						loaddata=1;
					end
					else begin
						nextState= s1; //Siguiente estado
						loaddata=0;
						end
				s1:
					if(inputdata_ready==1) begin  //datos cargados
						nextState=s1;
						loaddata=0;
					end
					else begin
						nextState= s0; 
						loaddata=1;
						
						 end
					
				default:		
					nextState = s0; 
					
			endcase
		end

endmodule
