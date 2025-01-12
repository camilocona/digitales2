// **********
// Top Module
// ********** 
module top (
  input logic clk, nreset, nenter,
  input logic [7:0] inputdata,
  output logic [6:0] disp3, disp2, disp1, disp0
);
  // Internal signals
  logic loaddata, inputdata_ready;
  logic reset, enter;
  assign reset = ~nreset;
  assign enter = ~nenter;
  	// Internal signals 
	

  // Module instantiation: control unit
  controlunit contr0 (clk, reset, loaddata, inputdata_ready);

  // Module instantiation: datapath unit
  datapathunit dp0 (clk, reset, enter, inputdata, loaddata, inputdata_ready, disp3, disp2, disp1, disp0);

endmodule

// ********************** 
// Testbench for Top Unit
// ********************** 
module tb_topunit ();
  // Testbench signals
  logic clk;
  logic nreset;
  logic nenter;
  logic [7:0] inputdata;
  logic [6:0] disp3;
  logic [6:0] disp2;
  logic [6:0] disp1;
  logic [6:0] disp0;

  // Instantiate the top module
  top ins(clk, nreset, nenter, inputdata, disp3, disp2, disp1, disp0);
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Testbench logic
  initial begin
    // Initialize testbench signals
    nreset = 0;
    nenter = 0;
    inputdata = 8'b0;

    // Apply reset
    nreset = 1;
    #10 nreset = 0;

    // End simulation
    #100 $finish;
  end


endmodule
