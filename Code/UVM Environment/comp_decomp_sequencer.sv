class comp_decomp_sequencer extends uvm_sequencer#(comp_decomp_seq_item);

  `uvm_component_utils(comp_decomp_sequencer) 

  //constructor
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass