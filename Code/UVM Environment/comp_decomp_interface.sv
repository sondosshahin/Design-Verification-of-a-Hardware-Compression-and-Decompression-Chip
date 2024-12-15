interface comp_decomp_if(input logic clk,reset);
  
  //declaring the signals
  logic [1:0] command;
  logic [79:0] data_in;
  logic [7:0] compressed_in;
  logic [7:0] compressed_out;
  logic [79:0] decompressed_out;
  logic [1:0] response;
  
  //driver clocking block
  
  //inputs & outputs ?????????
  clocking driver_cb @(posedge clk);
    default input #1 output #1;
    output command;
    output data_in;
    output compressed_in;
    input compressed_out;
    input decompressed_out; 
    input response;
  endclocking
  
  //monitor clocking block
  
    //inputs & outputs ?????????
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
    input command;
    input data_in;
    input compressed_in;
    input compressed_out;
    input decompressed_out; 
    input response;
  endclocking
  

  //driver modport
  modport DRIVER  (clocking driver_cb,input clk,reset);
  
  //monitor modport  
  modport MONITOR (clocking monitor_cb,input clk,reset);
  
endinterface