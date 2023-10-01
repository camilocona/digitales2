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
	logic [47:0] product; // Para que de el rango de la multiplicacion
   logic [22:0] shifted_product; //mantisa R desplazamiento del producto para la mantisa
	logic caso_a, caso_b, caso_c, caso_d;
			
	// Separar los componentes de los operandos IEEE 754
    assign mantisa_A = {1'b1,dataA[22:0]};
    assign mantisa_B = {1'b1,dataB[22:0]};
    assign exp_A = dataA[30:23];
    assign exp_B = dataB[30:23];
    assign sig_A = dataA[31];
    assign sig_B = dataB[31];		
			
	// XOR para signo 
	 assign sig_R = sig_A ^ sig_B;
	
	//Suma exponentes
	always_comb begin
		exp_R = ((exp_A + exp_B)-254)+127;
		
		
	// Multiplicacion mantisa
		product = (mantisa_A * mantisa_B);
		//Correr la coma y se suma exponente
		if (product[47]) begin
			shifted_product = product[46:24];
			exp_R = exp_R +1;
		end 
		else begin //Se deja igual
		shifted_product = product [45:23];
		end
		
		dataR ={sig_R, exp_R, shifted_product};
////	//CASOS ESPECIALES	
////	
    caso_a = (dataA == 32'h00000000 || dataB == 32'h00000000); // +/- 0
    caso_b = (dataA == 32'h7F800000 || dataA == 32'hFF800000 || dataB == 32'h7F800000 || dataB == 32'hFF800000); //+/- Inf
    caso_c = (dataA == 32'h7FC00000 || dataB == 32'h7FC00000); //NaN 
caso_d = ((exp_A == 8'b11111111 && dataA[22:0] != 0) || (exp_B == 8'b11111111 && dataB[22:0] != 0)); //NaN casos

    // Asignar resultados para casos especiales

    if (caso_a) begin
if(caso_b) begin
dataR = 32'hFFFFFFFF;
end else if(caso_c) begin
dataR = 32'hFFFFFFFF;
end else if(caso_d) begin
dataR = 32'hFFFFFFFF;
end else begin
dataR = 32'h00000000; // ±0
end

    end else if (caso_b) begin
dataR = caso_c ? 32'h7FC00000 : (sig_A ^ sig_B) ? 32'hFF800000 : 32'h7F800000; // ±Inf o NaN

    end else if (caso_c) begin
dataR = 32'hFFFFFFFF; // NaN

    end else if (caso_d) begin
dataR = 32'hFFFFFFFF; // NaN

    end

end
endmodule

// ***************************** 
// Testbench for Multiplier Unit
// ***************************** 
module tb_multiplierunit();
  
  logic [31:0] dataA, dataB, dataR;
  
  multiplierunit multi(dataA, dataB, dataR);
  logic clk;


  // clock
  always #5 clk=~clk;
  initial begin
    clk = 0;

  // Inicializar las entradas
	 dataA = 32'h4119999A; // 9.6 en IEEE 754 (32 bits)
    dataB = 32'hC0ECCCCD; // -7.4 en IEEE 754 (32 bits)
	 
  // Para probar casos especiales
//  dataA = 32'h00000000; // 0.0 en IEEE 754 (32 bits)
//  dataB = 32'hFF800000; // -Inf en IEEE 754 (32 bits)

    
    #100 // Espera un poco antes de mostrar el resultado
	 $stop;
  end

endmodule
