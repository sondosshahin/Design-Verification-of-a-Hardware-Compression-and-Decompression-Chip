// comp_decomp_sequence - random stimulus 
class comp_decomp_sequence extends uvm_sequence#(comp_decomp_seq_item);
  
  `uvm_object_utils(comp_decomp_sequence)
  
  //Constructor
  function new(string name = "comp_decomp_sequence");
    super.new(name);
  endfunction
  
  `uvm_declare_p_sequencer(comp_decomp_sequencer)
  
  // create, randomize and send the item to driver
  virtual task body();
    repeat(4)
    begin
    req = comp_decomp_seq_item::type_id::create("req");
    wait_for_grant();
    req.reset = 0;
    req.randomize();
    send_request(req);
    wait_for_item_done();
   end 
    
    req = comp_decomp_seq_item::type_id::create("req");
    req.command = 2'b10;
    req.compressed_in = 0;
    req.reset = 0;
    start_item(req);
    finish_item(req);
    
    req = comp_decomp_seq_item::type_id::create("req");
    req.command = 2'b10;
    req.compressed_in = 1;
    req.reset = 0;
    start_item(req);
    finish_item(req);
    
    req = comp_decomp_seq_item::type_id::create("req");
    req.command = 2'b10;
    req.compressed_in = 3;
    req.reset = 0;
    start_item(req);
    finish_item(req);
    
    req = comp_decomp_seq_item::type_id::create("req");
    req.reset = 1;
    req.command = 0;
    start_item(req);
    finish_item(req);
    
  endtask
endclass



// compression sequence  
class comp_sequence extends uvm_sequence#(comp_decomp_seq_item);
  
  `uvm_object_utils(comp_sequence)
  
  //Constructor
  function new(string name = "comp_sequence");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_do_with(req,{req.command==01;})
  endtask
endclass



// decompression sequence 
class decomp_sequence extends uvm_sequence#(comp_decomp_seq_item);
  
  `uvm_object_utils(decomp_sequence)
    
  //Constructor
  function new(string name = "decomp_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.command==10;})
  endtask
endclass




// no operation sequence 
class noop_sequence extends uvm_sequence#(comp_decomp_seq_item);
  
  `uvm_object_utils(noop_sequence)
   
  //Constructor
  function new(string name = "noop_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.command==00;})
  endtask
endclass




// invalid sequence  
class invalid_sequence extends uvm_sequence#(comp_decomp_seq_item);
  
  `uvm_object_utils(invalid_sequence)
   
  //Constructor
  function new(string name = "invalid_sequence");
    super.new(name);
  endfunction
  
  virtual task body();
    `uvm_do_with(req,{req.command==11;})
  endtask
endclass
