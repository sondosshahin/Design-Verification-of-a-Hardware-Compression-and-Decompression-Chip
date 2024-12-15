module reference (
  input clk, reset,
  input [1:0] command,
  input [79:0] data_in,
  input [7:0] compressed_in,
  output reg [1:0] response,
  output reg [79:0] decompressed_out,
  output reg [7:0] compressed_out
);

  // Internal variables
  reg [79:0] mem [255:0];
  reg [31:0] index;	
  
  bit isfull; 	//flag to check if the memory is full
  
  bit exit;		//used in the loop
  
  //initializing the memory and index register to zeros at the start 
  int i;
  initial begin  
    for (i = 0; i < 256; i++) begin
      mem[i] = 80'b0;
    end
    index = 8'b0;
  end 
  
  
  always @(posedge clk) begin
    if (reset == 1'b1) begin	//reset the memory and index reg
      for (i = 0; i < 256; i++) begin
        mem[i] = 80'b0;
      end
      index = 8'b0;
    end
    
    case(command)
      2'b00: response = 2'b00;		//no operation
      2'b01: begin 					//compression
        exit = 0;
            
        for (index = 0; index < 256 && !exit ; index++) begin
          if (mem[index] == data_in) begin	//data found in the memory
            compressed_out = index[7:0];
            response = 2'b01;
            exit = 1;
          end
          else if (mem[index] == 0) begin		//first empty slot
            mem[index] = data_in;
            compressed_out = index[7:0];
            isfull = 0;		//memory has empty slots            
            response = 2'b01;
            exit = 1;
          end
          else if (i == 255 & mem[i] != 0) begin	//no empty slots in the memory
        	isfull = 1;	
        	response = 2'b11;	//memory is full, issue an error
     	  end 
                    
        end 
      		 end 
      
      2'b10: begin 				//decompression
        if (compressed_in <= index[7:0]) begin  
          decompressed_out = mem[compressed_in];
          response = 2'b10;
         end
         else begin
           response = 2'b11;
              end

      		 end 
      
      
      2'b11: response = 2'b11;		//error - invalid command
      default: response = 2'b11;
    endcase
    
    
  
    
    
  end	//end of the always block
    
endmodule
