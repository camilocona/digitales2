// ******************** 
// Datapath Unit Module
// ******************** 
module datapathunit (clk, reset, enter, inputdata,
						   loaddata, inputdata_ready,
						   disp3, disp2, disp1, disp0);
	input logic  clk, reset, enter;
	input logic  [7:0] inputdata; //switch
	input logic  loaddata; 
	output logic inputdata_ready;
	output logic [6:0] disp3, disp2, disp1, disp0; 

	// Internal signals and module instantiation for multiplier unit
	logic [31:0] dataA, dataB, dataR;
	multiplierunit  mult0 (dataA, dataB, dataR);
	
	
	// Internal signals and module instantiation for peripherals unit
	peripherals perip0 (clk, reset, enter, inputdata, loaddata, inputdata_ready, dataA, dataB, dataR, disp3, disp2, disp1, disp0);


// *************************** 
// Testbench for Datapath Unit
// *************************** 
module tb_datapathunit ();
  // Testbench signals
  logic clk;
  logic reset;
  logic enter;
  logic [7:0] inputdata;
  logic loaddata;
  logic inputdata_ready;
  logic [6:0] disp3;
  logic [6:0] disp2;
  logic [6:0] disp1;
  logic [6:0] disp0;

  // Instantiate the datapathunit module
  datapathunit dut (clk, reset,enter,inputdata,loaddata,inputdata_ready,disp3,disp2,disp1,disp0);

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Testbench logic
  initial begin
    // Initialize testbench signals
    reset = 0;
    enter = 0;
    inputdata = 8'b0;
    loaddata = 0;

    // Apply reset
    reset = 1;
    #10 reset = 0;

    // Your testbench scenarios here

    // End simulation
    #100 $finish;
  end

  // Your testbench stimulus and checks here
  // WRITE HERE YOUR TESTBENCH CODE

endmodule

  
