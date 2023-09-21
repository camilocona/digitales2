// **********************
// Multiplier Unit Module
// **********************
module multiplierunit (dataA, dataB, dataR);
	input logic [31:0] dataA, dataB;
	output logic [31:0] dataR;

	// Internal signals to perform the multiplication
	logic [22:0] mantisa_A, mantisa_B, mantisa_R;
	logic [7:0] exp_A, exp_B, exp_R;
	logic sig_A, sig_B, sig_R;
	logic [46:0] product; // Cambiado de 47 a 46 bits
   logic [46:0] shifted_product; //desplazamiento del producto para la mantisa
			
	// Separar los componentes de los operandos IEEE 754
    assign mantisa_A = {1'b1,dataA[22:0]};
    assign mantisa_B = {1'b1,dataB[22:0]};
    assign exp_A = dataA[30:23]; //DUDA +127
    assign exp_B = dataB[30:23];
    assign sig_A = dataA[31];
    assign sig_B = dataB[31];		
			
	// Process: sign XORer
	assign sig_R = sig_A ^ sig_B;
	
	// Process: exponent adder
	always_comb begin
		exp_R = exp_A + exp_B;
		 if(exp_R > 127)
			exp_R= exp_R - 127;
		 else
			exp_R=exp_R;
	
	
	// Process: mantissa multiplier
		product = (mantisa_A * mantisa_B);
		shifted_product = product[47:24]; 
	
	if (shifted_product[23]) begin
		shifted_product = shifted_product << 1;
		exp_R = exp_R +1;
	end 
	else begin
	shifted_product = shifted_product <<2;
	//CASOS ESPECIALES	
	caso_a=(dataA ==32'h00000000 | dataB == 32'h00000000);
	caso_b=(dataA== 32'h7F800000 | dataA == 32'hFF800000 | dataB == 32'h7F800000 | dataB == 32'hFF800000 );
	caso_c=(dataA ==32'h7FC00000 | dataB == 32'h7FC00000);
	caso_d=((dataA >= 32'h7F800000 && dataA <= 32'hFFFFFFFF) | dataB >= 32'h7F800000 && dataB <= 32'hFFFFFFFF );end
	//ASIGNAR RESULTADOS PARA CASOS ESPECIALES
	if (caso_a) begin
		dataR = 32'h00000000; // Más o menos cero
	end else if (caso_b) begin
		dataR = caso_c ? 32'h7FC00000 : (sig_A ^ sig_B) ? 32'hFF800000 : 32'h7F800000; //Más o menos inf o NaN
	end else if (caso_c) begin
		dataR = 32'h7FC00000; //NaN
	end else if (caso_d) begin
		dataR = 32'h7FC00000; //NaN
	end 
	end
endmodule

// ***************************** 
// Testbench for Multiplier Unit
// ***************************** 
module tb_multiplierunit();

  // Definir constantes y señales
  logic [31:0] dataA, dataB, dataR;
  // Asegúrate de que las señales internas se inicialicen correctamente
  logic clk, rst;

  // Instanciar el módulo bajo prueba
  multiplierunit multi(dataA, dataB, dataR);

  // Generar un clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Inicializar las entradas
  initial begin
    rst = 0;
    dataA = 32'h3F800000; // 1.0 en IEEE 754 (32 bits)
    dataB = 32'h40000000; // 2.0 en IEEE 754 (32 bits)

    // Esperar un poco antes de aplicar el reset
    #10 rst = 1;
    #10 rst = 0;

    // Esperar un poco antes de mostrar el resultado
    #100 $stop;
  end

  // Mostrar resultados
  always @(posedge clk) begin
    $display("dataA = %h, dataB = %h, dataR = %h", dataA, dataB, dataR);
  end

endmodule	
