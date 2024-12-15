`include "comp_decomp_agent.sv"
`include "comp_decomp_scoreboard.sv"

class comp_decomp_env extends uvm_env;

  // agent and scoreboard instance
  comp_decomp_agent      comp_decomp_agnt;
  comp_decomp_scoreboard comp_decomp_scb;

  `uvm_component_utils(comp_decomp_env)

  // constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  // build_phase - create the components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    comp_decomp_agnt = comp_decomp_agent::type_id::create("comp_decomp_agnt", this);
    comp_decomp_scb  = comp_decomp_scoreboard::type_id::create("comp_decomp_scb", this);
  endfunction : build_phase

  // connect_phase - connecting monitor and scoreboard port
  function void connect_phase(uvm_phase phase);
    comp_decomp_agnt.monitor.item_collected_port.connect(comp_decomp_scb.item_collected_export);
  endfunction : connect_phase

endclass : comp_decomp_env