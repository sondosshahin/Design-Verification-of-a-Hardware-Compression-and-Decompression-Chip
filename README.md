# Design-Verification-of-a-Hardware-Compression-and-Decompression-Chip

## ENCS5337 Chip Design Verification Course Project

### Design Block Diagram
![Capture](https://github.com/user-attachments/assets/d3bde0f5-193f-41d6-9d74-4acf76c44f48)

### Chip Input/Output Ports
![Capture](https://github.com/user-attachments/assets/ce13e296-fabe-4352-b8ce-59f733fdbb13)

### Chip Specifications
#### Compression Algorithm
The compression algorithm works as follows:
1. The chip receives the input data to be compressed on the data_in port
2. It compares this input data with the stored data in the chip’s internal memory (dictionary memory)
3. If the input data is found, the index of the stored similar data is written on the compressed_out port. This index value is the compressed version of this input data.
4. If the input data is not found, the input data is written at the last empty slot of the dictionary memory, then the index is written on the compressed_out port, and the index is incremented
5. The physical index register width is 32-bit. However, the number of bits used out of these 32 bits depends on the size of the dictionary memory. In this project, the default size of the dictionary memory is 256 locations (each location is 80-bit). Thus, we need the least significant eight bits of these 32 bits, and therefore the compressed data size is 8 bits.
6. If the internal memory is full, the output response signal indicates that there is an error.

#### Decompression Algorithm
The decompression algorithm is the reverse of the compression algorithm, and it works as follows:

1. The chip receives the compressed data on the compressed_in port
2. If the value of the received compressed data is less than or equal the current value of the index register, then the corresponding decompressed data exists in the dictionary memory at an index equals the value of the received compressed data. Then, the content of the dictionary memory at that index is written on the decompressed_out port.
3. If the value of the received compressed data is greater than the current value of the index register, then the corresponding decompressed data does not exist in the dictionary memory. Therefore, and error is reported.

### Project Deliverables
#### 1. Reference Model
#### 2. Verification Plan
#### 3. Complete UVM Verification Environment with Coverage
