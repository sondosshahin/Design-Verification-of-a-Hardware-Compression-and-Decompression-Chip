`define DRIV_IF vif.DRIVER.driver_cb

class comp_decomp_driver extends uvm_driver #(comp_decomp_seq_item);

  // Virtual Interface
  virtual comp_decomp_if vif;
  
  `uvm_component_utils(comp_decomp_driver)
    
  // Constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new


  // build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
     if(!uvm_config_db#(virtual comp_decomp_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase


  // run phase
  virtual task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      $display("Driver: Received command = %b", req.command);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase
  
  
  // drive - transaction level to signal level
  // drives the value's from seq_item to interface signals
  virtual task drive();
    @(posedge vif.DRIVER.clk);
    
    `DRIV_IF.command <= req.command;
    //$display("Driver: Driving command = %b", req.command);
    
    if(req.command == 'b01) begin //  compression
      `DRIV_IF.data_in <= req.data_in;
      $display("Driver: Driving data_in = %h", req.data_in);
      @(posedge vif.DRIVER.clk);
    end
    else if(req.command == 'b10) begin //decompression
      `DRIV_IF.compressed_in <= req.compressed_in;
      $display("Driver: Driving compressed_in = %h", req.compressed_in);
      @(posedge vif.DRIVER.clk);
    end
    
    if(req.command == 'b00 || req.command == 'b11) begin
      @(posedge vif.DRIVER.clk);
    end
    @(posedge vif.DRIVER.clk);
  endtask : drive
endclass : comp_decomp_driver