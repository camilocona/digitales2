// **********************
// Multiplier Unit Module
// **********************
module multiplierunit (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// Internal signals to perform the multiplication
	logic [23:0] mantisa_A, mantisa_B;
	logic [22:0] mantisa_R;
	logic [7:0] exp_A, exp_B, exp_R;
	logic sig_A, sig_B, sig_R;
	logic [47:0] product; // Cambiado de 47 a 46 bits
   logic [22:0] shifted_product; //mantisa R desplazamiento del producto para la mantisa
	logic caso_a, caso_b, caso_c, caso_d;
			
	// Separar los componentes de los operandos IEEE 754
    assign mantisa_A = {1'b1,dataA[22:0]};
    assign mantisa_B = {1'b1,dataB[22:0]};
    assign exp_A = dataA[30:23];
    assign exp_B = dataB[30:23];
    assign sig_A = dataA[31];
    assign sig_B = dataB[31];		
			
	// Process: sign XORer
	 assign sig_R = sig_A ^ sig_B;
	
	// Process: exponent adder
	always_comb begin
		exp_R = ((exp_A + exp_B)-254)+127;
//		 if(exp_R > 127) begin 
//			exp_R= exp_R - 127;
//		 end else
//			exp_R=exp_R;
			
	// Process: mantissa multiplier	
		product = (mantisa_A * mantisa_B);
		//shifted_product = product[47:24];  //mantisa R
		
		if (product[47]) begin
			shifted_product = product[46:24];
			exp_R = exp_R +1;
		end 
		else begin
		shifted_product = product [45:23];
		end
		
		dataR ={sig_R, exp_R, shifted_product};
////	//CASOS ESPECIALES	
////	
//	caso_a=(dataA ==32'h00000000 || dataB == 32'h00000000);
//	caso_b=(dataA== 32'h7F800000 || dataA == 32'hFF800000 || dataB == 32'h7F800000 || dataB == 32'hFF800000 );
//	caso_c=(dataA ==32'h7FC00000 || dataB == 32'h7FC00000);
//	caso_d=((exp_A == 8'h11111111 && dataA[22:0] != 0) || exp_B == 8'h11111111 && dataB[22:0] != 0 );
////	//ASIGNAR RESULTADOS PARA CASOS ESPECIALES
////	
//	if (caso_a) begin
//		dataR = 32'h7FC00000;	// Más o menos cero	end
//		if (caso_b) begin
//		dataR = 32'h7FC00000;
//	end else if (caso_c) begin
//		dataR = 32'h00000000;
//		end else begin
//			dataR= 32'h00000000;
//		end
//		end else if (caso_b) begin
//		dataR = caso_c ? 32'h00000000 : (sig_A ^ sig_B) ? 32'h7F800000;
//	end else if (caso_c) begin
//		dataR = 32'h7FC00000; //NaN
//	end else if (caso_d) begin
//		dataR = 32'h7FC00000; //NaN
//end 

end
endmodule

// ***************************** 
// Testbench for Multiplier Unit
// ***************************** 
module tb_multiplierunit();
  // Definir constantes y señales
  logic [31:0] dataA, dataB, dataR;
  // Asegúrate de que las señales internas se inicialicen correctamente
  multiplierunit multi(dataA, dataB, dataR);
  logic clk;

  // Instanciar el módulo bajo prueba


  // Generar un clock
  always #5 clk=~clk;
  initial begin
    clk = 0;

  // Inicializar las entradas
    dataA = 32'h41480000; // 12.5 en IEEE 754 (32 bits)
    dataB = 32'hC0A66666; // -5.2 en IEEE 754 (32 bits)
	//C2820000

    // Esperar un poco antes de mostrar el resultado
    #100 
	 $stop;
  end

endmodule
