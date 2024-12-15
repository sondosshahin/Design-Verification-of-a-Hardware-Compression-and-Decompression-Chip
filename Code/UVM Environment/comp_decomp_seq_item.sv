`ifndef COMP_DECOMP_SEQ_ITEM_SV
`define COMP_DECOMP_SEQ_ITEM_SV

class comp_decomp_seq_item extends uvm_sequence_item;
  // data and control fields
  // only inputs are defined as rand
  bit reset;
  rand bit [1:0] command;
  rand bit [79:0] data_in;
  rand bit [7:0] compressed_in;
  bit [1:0] response;
  bit [79:0] decompressed_out;
  bit [7:0] compressed_out;

  // Utility and Field macros
  `uvm_object_utils_begin(comp_decomp_seq_item)
    `uvm_field_int(command, UVM_ALL_ON)
    `uvm_field_int(data_in, UVM_ALL_ON)
    `uvm_field_int(compressed_in, UVM_ALL_ON)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "comp_decomp_seq_item");
    super.new(name);
  endfunction

  // no needed constraints

endclass

`endif // COMP_DECOMP_SEQ_ITEM_SV
