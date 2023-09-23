// ******************* 
// Get Operands Module
// ******************* 
module peripheral_getoperands (clk, reset, inputdata, enterpulse, datainput_i, dataA, dataB);
	input logic clk, reset;
	input logic [7:0] inputdata; //switch para A y B
	input logic enterpulse; //pulso
	output logic [3:0] datainput_i; //REGISTROS DE 8 BITS 
	output logic [31:0] dataA, dataB; //A y B

	// Internal signals
	logic intPulse;
	logic [2:0] cnt;
	logic [2:0] pos;
	
	// Parallel circuits
	assign a = enterpulse; //Pulsos
	peripheral_pulse pp (enterpulse, clk, reset, intPulse);
	//deco7seg_hexa deco0 (cnt, disp);
	
	// Counter process. Activates each time intPulse is 1'b1
	always_ff @(posedge clk, posedge reset) begin
		if (reset)
			cnt <= 0;
		else if (intPulse)
			cnt <= cnt + 1;
	end
	assign pos = cnt; //No se a que variable asignarle el conteo
	
	/*000 -0
	  001 -1
	  010 -2
	  011 -3
	  100 -4
	  101 -5
	  110 -6
	  111 -7*/
	
	always @(posedge clk, posedge reset) begin
        if (reset) begin
            dataA <= 32'b0;
            dataB <= 32'b0;
            datainput_i[0] <= 8'b0;//A menos significativas
            datainput_i[1] <= 8'b0;
            datainput_i[2] <= 8'b0;
            datainput_i[3] <= 8'b0;//A mas significativas
				end
			else begin
				 if(enterpulse) begin
				 datainput_i[pos]=inputdata;
				 end
				 // se utiliza para cargar un nuevo byte de datos en los bits menos significativos de operand_A mientras se desplazan los bits anteriores hacia la izquierda.
				 dataA <= {dataA[23:0], datainput_i[3:0]}; 
				 dataB <= {dataB[23:0], datainput_i[3:0]}; 
				 end
		end
endmodule
						
