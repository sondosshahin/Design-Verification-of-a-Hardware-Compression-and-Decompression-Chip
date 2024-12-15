`include "comp_decomp_env.sv"

class comp_test extends uvm_test;

  `uvm_component_utils(comp_test)
  
  comp_decomp_env env;
  comp_sequence seq;

  function new(string name = "comp_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = comp_decomp_env::type_id::create("env", this);
    seq = comp_sequence::type_id::create("seq");
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.comp_decomp_agnt.sequencer);
    phase.drop_objection(this);
  endtask : run_phase

endclass : comp_test