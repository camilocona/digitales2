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
	
	// Internal signals and module instantiation for pulse generation
	logic [7:0] dataoutput;
	//peripheral_pulse(enter, clk, reset, pulse);
	peripheral_getoperands perget(clk, reset, inputdata, enter, loaddata,inputdata_ready, datainput_i, dataA, dataB, dataR,dataoutput);
	
	// Process, internal signals and assign statement to control data input / output indexes and data input ready signals
	// Data Input/Output Control
  logic [1:0] data_index; // Control para seleccionar A (00), B (01) o R (10)
  logic [3:0] byte_index; // Control para seleccionar el byte dentro de A, B o R
  logic [31:0] data_register; // Registro temporal para cargar datos


  // Process to control data input/output indexes and data input ready signals
 /* always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
      data_index <= 2'b00; // Inicialmente seleccionar A
      byte_index <= 4'b0000; // Inicialmente seleccionar el byte 0
    end else begin
      if (enter && loaddata) begin
        // Si loaddata está activado, cargar datos en el registro temporal
        case (byte_index)
          4'b0000: data_register[7:0] <= inputdata;
          4'b0001: data_register[15:8] <= inputdata;
          4'b0010: data_register[23:16] <= inputdata;
          4'b0011: data_register[31:24] <= inputdata;
          default: data_register <= data_register; // No debería ocurrir
        endcase
    //  end
	// Controlar la selección de A, B o R y el byte dentro de ellos
   //   if (enter && loaddata) begin //-> Aquí hay una duda
        // Solo actualizar si loaddata y enter están activados
        case (data_index)
		  //Esto indica que se está asignando un rango de 8 bits consecutivos, comenzando desde el resultado de byte_index * 8.
		  // si byte_index es 2, la expresión byte_index*8 sería igual a 16. Entonces, la asignación sería dataA[16 +: 8], que asigna los bits del 16 al 23 de data_register al rango de bits 16
          2'b00: begin 
			 dataA[byte_index*8 +: 8] <= data_register[7:0];  // Si data_index es 2'b00, esta línea asigna los bits 7:0 de data_register a un segmento específico de dataA.
			 end 			
          2'b01: begin 
			 dataB[byte_index*8 +: 8] <= data_register[7:0];// Si data_index es 2'b01, esta línea asigna los bits 7:0 de data_register a un segmento específico de dataB. 
			 end
          2'b10: begin 
			 dataR[byte_index*8 +: 8] <= data_register[7:0]; // Si data_index es 2'b10, esta línea asigna los bits 7:0 de data_register a un segmento específico de dataR.
			 end
          default: dataA[byte_index*8 +: 8] <= dataA[byte_index*8 +: 8];// En caso de que data_index no coincida con ninguno de los casos anteriores, esta línea es una asignación trivial y no debería ocurrir en condiciones normales.
			endcase
			end
			
			
        byte_index <= byte_index + 1; // Avanzar al siguiente byte
        if (byte_index == 4'b0100) begin
          // Si llegamos al último byte, cambiar de registro
          byte_index <= 4'b0000;
          data_index <= data_index + 1; 
          if (data_index == 2'b11) begin
            // Si llegamos a R, indicar que los datos están listos (default)
            inputdata_ready <= 1'b1;
          end
        end
   
		else begin
        // Si no estamos cargando datos,inputdata_ready es 0
        inputdata_ready <= 1'b0;
      end
    end
  end */
//  assign inputdata_ready = 0;

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
	
	peripheral_deco7seg d1 (dataoutput_i[3:0],0,SEG);	//Menos significativos
	peripheral_deco7seg d2 (dataoutput_i[7:4],0,SEG);	//
	peripheral_deco7seg d3 (pos[1:0],0,SEG);
	
	if (pos[3:2]=='00')
		peripheral_deco7seg d4 (,1,SEG);
	
	//00 a
	//01 b
	//10 r
	peripheral_deco7seg d4 ();	
	
  // Generar un clock
//  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin 
 
  reset = 0;
  enter = 0;
  loaddata=1;
  inputdata_ready=0;
  dataR= 32'hC2820000;
  inputdata = 8'h00; // 32'h3F800000
  #10
  reset = 1;
  #10
  reset =0;
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'h00; // 32'h3F800000
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'h80; // 32'h3F800000
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'h3F; // 32'h3F800000
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  
  //32'hA1BE867D   B
  inputdata = 8'h7D; // 32'h3F800000
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'h86; // 32'h3F800000
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'hBE; // 32'h3F800000
  enter =1;
  #10; //Para mantenerse durante un ciclo completo de reloj
  enter=0;
  #10;
  inputdata = 8'hA1; // 32'h3F800000
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

