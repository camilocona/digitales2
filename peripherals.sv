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
	
	//peripheral_pulse(enter, clk, reset, pulse);
	peripheral_getoperands (clk, reset, inputdata, enterpulse, datainput_i, dataA, dataB);
	
	// Process, internal signals and assign statement to control data input / output indexes and data input ready signals
	// Data Input/Output Control
  logic [1:0] data_index; // Control para seleccionar A (00), B (01) o R (10)
  logic [3:0] byte_index; // Control para seleccionar el byte dentro de A, B o R
  logic [31:0] data_register; // Registro temporal para cargar datos

  // Process to control data input/output indexes and data input ready signals
  always_ff @(posedge clk, posedge reset) begin
    if (reset) begin
      data_index <= 2'b00; // Inicialmente seleccionar A
      byte_index <= 4'b0000; // Inicialmente seleccionar el byte 0
    end else begin
      if (loaddata) begin
        // Si loaddata está activado, cargar datos en el registro temporal
        case (byte_index)
          4'b0000: data_register[7:0] <= inputdata;
          4'b0001: data_register[15:8] <= inputdata;
          4'b0010: data_register[23:16] <= inputdata;
          4'b0011: data_register[31:24] <= inputdata;
          default: data_register <= data_register; // No debería ocurrir
        endcase
      end
	
	// Controlar la selección de A, B o R y el byte dentro de ellos
      if (loaddata && enterpulse) begin
        // Solo actualizar si loaddata y enter están activados
        case (data_index)
          2'b00: dataA[byte_index*8 +: 8] <= data_register[7:0];
          2'b01: dataB[byte_index*8 +: 8] <= data_register[7:0];
          2'b10: dataR[byte_index*8 +: 8] <= data_register[7:0];
          default: dataA[byte_index*8 +: 8] <= dataA[byte_index*8 +: 8]; // No debería ocurrir
        endcase
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
      end else begin
        // Si no estamos cargando datos,inputdata_ready es 0
        inputdata_ready <= 1'b0;
      end
    end
  end


endmodule
