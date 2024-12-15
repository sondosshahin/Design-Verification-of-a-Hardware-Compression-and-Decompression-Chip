`include "comp_decomp_env.sv"

class invalid_test extends uvm_test;

  `uvm_component_utils(invalid_test)
  
  comp_decomp_env env;
  invalid_sequence seq;

  function new(string name = "invalid_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction : new

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = comp_decomp_env::type_id::create("env", this);
    seq = invalid_sequence::type_id::create("seq");
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq.start(env.comp_decomp_agnt.sequencer);
    phase.drop_objection(this);
  endtask : run_phase

endclass : invalid_test