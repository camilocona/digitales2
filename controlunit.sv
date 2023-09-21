// *******************
// Control Unit Module
// *******************
module controlunit (clk, reset, loaddata, inputdata_ready);
	input logic  clk, reset;
	output logic  loaddata;
	input logic inputdata_ready;

	// Internal signals for state machine
	// WRITE HERE YOUR CODE
	
	//           Carga de datos / Multiplicacion
	typedef enum logic [2:0] {s0, s1} State;
	State currentState, nextState;


	// Process (Sequential): update currentState
	always_ff @(posedge reset) 
		if (reset)
			currentState <= s0;
		else 
			currentState <= nextState;
			
	// Process (Combinational): update nextState
	always_comb begin	
			case (currentState)
				s0:
				//DUDA
					if(inputdata_ready==0) begin
						loaddata=1;
						nextState=s1;
					end
					else
						nextState= s0;
				s1:
				//DUDA
					if(inputdata_ready==1) begin
						loaddata=0;
						nextState=s0;
					end
					else 
						nextState= s1;
					
				default:		
					nextState = s0;
			endcase
		end

		//Como definir las salidas??a
	// Process (Combinational): update outputs 
	// WRITE HERE YOUR CODE
endmodule

// ************************** 
// Testbench for Control Unit
// ************************** 
module tb_controlunit ();
	// WRITE HERE YOUR CODE
endmodule
