// ******************* 
// Get Operands Module
// ******************* 
module peripheral_getoperands (clk, reset, inputdata, enterpulse, loaddata,inputdata_ready, datainput_i, dataA, dataB, dataR,dataoutput,pos1);
	input logic clk, reset;
	input logic [7:0] inputdata; //switch para A y B
	input logic enterpulse, loaddata; //pulso y cargar datos
	
	output logic inputdata_ready;
	output logic [0:7][7:0] datainput_i; //REGISTROS DE 8 BITS //Arreglo de 4 posiciones de 8 bits c/u
	output logic [31:0] dataA, dataB; //A y B
	input logic  [31:0] dataR;
	output logic [7:0] dataoutput;
	output logic [3:0] pos1; //para el byte
	
	

	// Internal signals
	logic intPulse;
	logic [3:0] cnt;
	logic [3:0] pos;
	logic [0:3][7:0] dataoutput_i;   
	
	assign pos1=pos;
	
	assign inputdata_ready = pos[3]; //llegó a la última pos

	assign a = enterpulse; //Pulsos
	peripheral_pulse pp (enterpulse, clk, reset, intPulse);
	
	// contador del pulso para carga de datos
	always_ff @(posedge intPulse, posedge reset) begin
		if (reset)
			cnt <= 0;
		else if (cnt< 12) 
			cnt <= cnt + 1;
		else
			cnt = 0;
	end
	assign pos = cnt; 
	/*000 -0
	  001 -1
	  010 -2
	  011 -3
	  100 -4
	  101 -5
	  110 -6
	  111 -7*/
	
	always @(posedge clk, posedge reset) begin
        if (reset) begin //pone todo en cero
            datainput_i[0] <= 8'b0;//A menos significativas
            datainput_i[1] <= 8'b0;
            datainput_i[2] <= 8'b0;
            datainput_i[3] <= 8'b0;//A mas significativas
				end
				
			else begin //carga de datos
				 if(loaddata) begin
				 datainput_i[pos][7:0]=inputdata; //aux para cargar datos
				 dataoutput = inputdata;
				 end
				 
				 else if (enterpulse && ~loaddata) begin //siguiente dato a entrar
				 dataoutput = dataoutput_i[pos[2:0]][7:0];
				 end
		end
		end
	always_comb begin
				 dataoutput_i[0][7:0] <= dataR[7:0];
				 dataoutput_i[1][7:0] <= dataR[15:8];
				 dataoutput_i[2][7:0] <= dataR[23:16];
				 dataoutput_i[3][7:0] <= dataR[31:24];
				 // se utiliza para cargar un nuevo byte de datos en los bits menos significativos de dataA mientras se desplazan los bits anteriores hacia la izquierda.
				 dataA <= {datainput_i[3][7:0], datainput_i[2][7:0], datainput_i[1][7:0], datainput_i[0][7:0]}; 
				 dataB <= {datainput_i[7][7:0], datainput_i[6][7:0], datainput_i[5][7:0], datainput_i[4][7:0]}; 
	end
	endmodule
