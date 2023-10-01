// *********************** 
// Peripherals Unit Module
// *********************** 
module peripherals (clk, reset, enter, inputdata,
						  loaddata, inputdata_ready,
                    dataA, dataB, dataR, 
						  disp3, disp2, disp1, disp0);
	input logic  clk, reset, enter;
	input logic  [7:0] inputdata;
	input logic  loaddata;
	output logic inputdata_ready;
	output logic [31:0] dataA, dataB;
	input logic  [31:0] dataR;
	output logic [6:0] disp3, disp2, disp1, disp0;
	
	// Internal signals
	logic [7:0] dataoutput;
	logic [3:0]pos1;
	
	peripheral_getoperands perget(clk, reset, inputdata, enter, loaddata,inputdata_ready, datainput_i, dataA, dataB, dataR,dataoutput,pos1);
	
	logic [3:0] letra;
	logic [1:0] var1;
	
	peripheral_deco7seg d0 (dataoutput[3:0],0,disp0);	//primer display de izq a derecha
	peripheral_deco7seg d1 (dataoutput[7:4],0,disp1);	//segundo display de izq a derecha
	peripheral_deco7seg d2 (pos1[1:0],0,disp2); //tercero display de izq a derecha BYTE 
	
always_comb begin
 
 if (pos1[3:2] == 2'b00 )begin
    letra = 4'b1010;end
 else if (pos1[3:2] ==2'b01)begin
		letra = 4'b1011;end
 else if (pos1[3:2] == 2'b10)begin
		letra = 4'b1100;end
 else
 letra = 4'b1010; // Añade una asignación predeterminada en caso de que ninguna de las condiciones se cumpla
end

peripheral_deco7seg d3 (letra, 1, disp3); //cuarto display de izq a derecha LETRAS
	


endmodule

module tb_peripherals();

	logic clk, reset, enter;
	logic [7:0] inputdata;
	logic loaddata;
	logic inputdata_ready;
	logic [31:0] dataA, dataB;
	logic [31:0] dataR;
	logic [6:0] disp3, disp2, disp1, disp0;
 
	peripherals perip0 (clk, reset, enter, inputdata, loaddata, inputdata_ready, dataA, dataB, dataR, disp3, disp2, disp1, disp0);
//	

	
  // Generar un clock
  initial begin
   
    forever #5 clk = ~clk;
  end
  
  initial begin 
  clk = 0;
  reset = 0;
  enter = 0;
  loaddata=1;
  inputdata_ready=0;
  dataR= 32'hC28E147B;
  
  //dataA = 32'h4119999A
  inputdata = 8'h9A; // 32'h4119999A
  #10  //Para mantenerse durante un ciclo completo de reloj
  reset = 1;
  #10  
  reset =0;
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10; 
  inputdata = 8'h99; // 32'h4119999A
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'h19; // 32'h4119999A
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'h41; // 32'h4119999A
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  
  //dataB = 32'hC0ECCCCD
  inputdata = 8'hCD; // 32'hC0ECCCCD
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'hCC; // 32'hC0ECCCCD
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'hEC; // 32'hC0ECCCCD
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'hC0; // 32'hC0ECCCCD 
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata_ready=1;
  loaddata=0;
  #10;
  enter=1;
  #10;
  enter=0;
  #10;
  enter=1;
  #10;
  enter=0;
  #10;
  enter=1;
  #10;
  enter=0;
  #10;
  enter=1;
  #40;
	$stop;
	end
	endmodule
