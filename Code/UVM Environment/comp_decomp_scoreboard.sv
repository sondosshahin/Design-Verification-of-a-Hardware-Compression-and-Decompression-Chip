`include "uvm_macros.svh"
`include "comp_decomp_seq_item.sv"  // Include the sequence item class file

class comp_decomp_scoreboard extends uvm_scoreboard;

  // Internal data structures to store transactions
  comp_decomp_seq_item pkt_qu[$];
  
  // Memory array for reference model
  logic [79:0] mem [255:0];
  logic [7:0] index;

  // Analysis port for receiving transactions
  uvm_analysis_imp#(comp_decomp_seq_item, comp_decomp_scoreboard) item_collected_export;

  // UVM component utilities
  `uvm_component_utils(comp_decomp_scoreboard)

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_export = new("item_collected_export", this);
  endfunction : new

  // Build phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Initialize memory
    foreach (mem[i]) begin
      mem[i] = 80'b0;
    end
    index = 0;

  endfunction: build_phase

  // Write function to store collected transactions
  virtual function void write(comp_decomp_seq_item pkt);
    pkt_qu.push_back(pkt);
  endfunction : write

  // Run phase to process and compare transactions
  virtual task run_phase(uvm_phase phase);
    comp_decomp_seq_item mem_pkt;
    
    forever begin
      wait(pkt_qu.size() > 0);
      mem_pkt = pkt_qu.pop_front();
      compare(mem_pkt);
    end
  endtask : run_phase

  // Function to compare DUT outputs with reference model outputs
  virtual function void compare(comp_decomp_seq_item dut_pkt);
    // Internal reference model variables
    logic [79:0] ref_decompressed_out;
    logic [1:0] ref_response;
    logic [7:0] ref_compressed_out;
    

    if (dut_pkt.reset == 1) begin
      $display("reset = %h   resetting the dictionary and index", dut_pkt.reset);
    end
    
    $display("dut command: %b", dut_pkt.command);
    // Reference model logic
    if (dut_pkt.command == 2'b00) begin
      ref_response = 2'b00;
    end
    if (dut_pkt.command == 2'b01) begin
      // Compression logic
      ref_compressed_out = compress(dut_pkt.data_in, index);
      ref_response = 2'b01;
    end else if (dut_pkt.command == 2'b10) begin
      // Decompression logic
      ref_decompressed_out = decompress(dut_pkt.compressed_in, index);
      if (ref_decompressed_out == 0) begin
        ref_response = 2'b11;
      end else begin
      ref_response = 2'b10;
      end
    end else if (dut_pkt.command == 2'b11) begin
      ref_response = 2'b11; // Invalid command
    end
    

    
    $display("reference response: %b", ref_response);
    $display("dut response: %b", dut_pkt.response);
    
    // Compare outputs
    if (dut_pkt.response !== ref_response) begin
      `uvm_error("scoreboard", $sformatf("Response mismatch: DUT = %b, REF = %b", dut_pkt.response, ref_response));
    end
    if (dut_pkt.command == 2'b01 && dut_pkt.compressed_out !== ref_compressed_out) begin
      `uvm_error("scoreboard", $sformatf("Compressed output mismatch: DUT = %h, REF = %h", dut_pkt.compressed_out, ref_compressed_out));
    end
    if (dut_pkt.command == 2'b10 && dut_pkt.decompressed_out !== ref_decompressed_out) begin
      `uvm_error("scoreboard", $sformatf("Decompressed output mismatch: DUT = %h, REF = %h", dut_pkt.decompressed_out, ref_decompressed_out));
    end
    else if (dut_pkt.response == ref_response) begin
      $display("success: dut respone = %b, ref response = %b", dut_pkt.response, ref_response);
      $display("success: data in  = %h", dut_pkt.data_in);
      $display("success: index  = %h", dut_pkt.compressed_out);
      
      $display("success: data out  = %h", dut_pkt.decompressed_out);
      
    end
  endfunction : compare

  // Reference model compression function
  function logic [7:0] compress(input logic [79:0] data_in, input logic [7:0] index);
//     logic [7:0] local_index;
    bit found;
    
    found = 0;
    for (index = 0; index < 256; index++) begin
      if (mem[index] == data_in) begin
        // Data found in the memory
        return index;
      end
      else if (mem[index] == 0) begin
        // First empty slot
        mem[index] = data_in;
        return index;
      end
    end
    
    // If we reach here, memory is full
    return 8'hFF;
  endfunction : compress

  // Reference model decompression function
  function logic [79:0] decompress(input logic [7:0] compressed_in, input logic [7:0] index);
    if (mem[compressed_in] != 0) begin
      return mem[compressed_in];
    end else begin
      $display("data not found at this index");
    return 0;
    end
  endfunction : decompress

endclass : comp_decomp_scoreboard
