`include "comp_decomp_interface.sv"
`include "comp_decomp_test.sv"
//`include "comp_test.sv"
//`include "decomp_test.sv"
//`include "noop_test.sv"
//`include "invalid_test.sv"

module tbench_top;

  // Clock and reset signal declaration
  bit clk = 0;
  bit reset;

  // Clock generation
  always #5 clk = ~clk;

  // Reset Generation
  initial begin
    reset = 1;
    #10 reset = 0;
  end

  // Interface instance
  comp_decomp_if intf(clk, reset);

  // DUT instance
  compression_decompression DUT (
    .clk(intf.clk),
    .reset(intf.reset),
    .command(intf.command),
    .data_in(intf.data_in),
    .compressed_in(intf.compressed_in),
    .compressed_out(intf.compressed_out),
    .decompressed_out(intf.decompressed_out),
    .response(intf.response)
  );

  // Enable wave dump
  initial begin
    uvm_config_db#(virtual comp_decomp_if)::set(uvm_root::get(), "*", "vif", intf);
    $dumpfile("dump.vcd"); 
    $dumpvars;
  end

  // Calling test
  initial begin 
    run_test ("comp_decomp_test");
    //run_test ("comp_test");
    //run_test ("decomp_test");
    //run_test ("noop_test");
    //run_test ("invalid_test");
  end

endmodule
