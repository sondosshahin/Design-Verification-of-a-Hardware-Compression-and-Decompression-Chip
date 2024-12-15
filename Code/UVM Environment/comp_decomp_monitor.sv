`include "comp_decomp_seq_item.sv"  // Include the sequence item class file

class comp_decomp_monitor extends uvm_monitor;

  // Virtual Interface
  virtual comp_decomp_if vif;

  // analysis port, to send the transaction to scoreboard
  uvm_analysis_port #(comp_decomp_seq_item) item_collected_port;

  // The following property holds the transaction information currently
  comp_decomp_seq_item trans_collected;

  `uvm_component_utils(comp_decomp_monitor)

  
  real coverage;
  
  
  //coverage
  covergroup my_covergroup;  
    option.per_instance = 1;
    cmd: coverpoint trans_collected.command ; // autobins for all command values
    comp_in: coverpoint trans_collected.compressed_in {
      bins b1[] = {0, 1, [20:30] ,254, 255};
    } 
    data: coverpoint trans_collected.data_in  {			
      bins b[] = {0, 1, [500:530] };
    } 
  endgroup
  
  
  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = comp_decomp_seq_item::type_id::create("trans_collected");
    item_collected_port = new("item_collected_port", this);
    my_covergroup = new();
  endfunction : new

  // build_phase - getting the interface handle
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual comp_decomp_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase

  // run_phase - convert the signal level activity to transaction level.
  virtual task run_phase(uvm_phase phase);
    forever begin
      @(posedge vif.MONITOR.clk);
     // $display("Monitor: Captured command = %b", vif.monitor_cb.command);
      trans_collected.command = vif.monitor_cb.command;
      trans_collected.reset = vif.MONITOR.reset;
      if(vif.monitor_cb.command == 'b01) begin // compression
        //trans_collected.command = vif.monitor_cb.command;
        trans_collected.data_in = vif.monitor_cb.data_in;
        trans_collected.compressed_in = 0; // not used in compression
       // @(posedge vif.MONITOR.clk);
        @(posedge vif.MONITOR.clk); // connect outputs
        trans_collected.response = vif.monitor_cb.response;
        trans_collected.compressed_out = vif.monitor_cb.compressed_out;
      end
      if(vif.monitor_cb.command == 'b10) begin // decompression
        //trans_collected.command = vif.monitor_cb.command;
        trans_collected.compressed_in = vif.monitor_cb.compressed_in;
        trans_collected.data_in = 0; // not used in decompression
       // @(posedge vif.MONITOR.clk);
        @(posedge vif.MONITOR.clk);
        trans_collected.response = vif.monitor_cb.response;
        trans_collected.decompressed_out = vif.monitor_cb.decompressed_out;
      end
      // no operation or invalid operation
      if(vif.monitor_cb.command == 'b00 || vif.monitor_cb.command == 'b11) begin
        trans_collected.command = vif.monitor_cb.command;
       // @(posedge vif.MONITOR.clk);
        @(posedge vif.MONITOR.clk);
        trans_collected.response = vif.monitor_cb.response;
      end
      item_collected_port.write(trans_collected);
      
       my_covergroup.sample(); // method for sampling coverage
       coverage = my_covergroup.get_inst_coverage();
       $display (" Coverage = %0.2f %% \n", my_covergroup.get_inst_coverage());
    end
  endtask : run_phase

endclass : comp_decomp_monitor
