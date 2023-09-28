// *******************
// Control Unit Module
// *******************
module controlunit (clk, reset, loaddata, inputdata_ready);
	input logic  clk, reset;
	output logic  loaddata;
	input logic inputdata_ready;
	
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
					if(inputdata_ready==0) begin
						nextState=s0;
						loaddata=1;
					end
					else begin
						nextState= s1;
						loaddata=0;
						end
				s1:
					if(inputdata_ready==1) begin
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
