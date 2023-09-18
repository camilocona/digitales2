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
	end
	
	// Process: mantissa multiplier
		product = (mantisa_A * mantisa_B);
		shifted_product = product[47:24]; 
	
	if (shifted_product[23]) begin
		shifted_product = shifted_product << 1;
		exp_R = exp_R +1;
	end 
	else begin
		shifted_product = shifted_product <<2;
	
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
  multiplierunit uut (
    .dataA(dataA),
    .dataB(dataB),
    .dataR(dataR)
  );

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











// ******************* 
// Get Operands Module
// ******************* 
module peripheral_getoperands (clk, reset, inputdata, enterpulse, datainput_i, dataA, dataB);
	input logic clk, reset;
	input logic [7:0] inputdata; //switch para A y B
	input logic enterpulse; //pulso
	input logic [3:0] datainput_i; //REGISTROS DE 8 BITS 
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
	
	always @(posedge clk, posedge rst) begin
        if (rst) begin
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
				 dataA <= {dataA[23:0], datainput_i[3:0]};
				 dataB <= {dataB[23:0], datainput_i[3:0]};
              end

	
endmodule			
