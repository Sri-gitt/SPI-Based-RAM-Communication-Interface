module spi_top (
    input wire clk,                // synchronization clock signal 
	 input wire spi_mosi,           //serial communication line from master to slave  
    input wire reset,             // overall reset signal
    input wire spi_clk,           // serial clock signal for spi communication
	 input wire spi_cs,            // active low slave chip select signal 
    output  spi_miso);
	
//Signal Declarations
	  wire [15:0]parallel_in;
	  wire [15:0]incoming_data;
     wire write;						//Write strobe for the blockram
	  wire read;                  // read strobe for the blockram
     wire [3:0] address;        // address from where data is to be read or written
     wire  [7:0] data_in;       // the data to be written on a pecific address in the blockram 
	  wire [7:0]data_out;
	  wire [7:0]q;       //output from the blockram 
	  wire new_data;
	  wire data_valid;
	
   
//Instatiate the Serial to parallel converter module
serial_to_parallel_converter m1( .clk(clk) , 
                                 .reset(reset) , 
								         .spi_clk(spi_clk) ,
								         .spi_cs(spi_cs) , 
								         .spi_mosi(spi_mosi) ,
								         .parallel_out(parallel_in),
											.new_data(new_data));

//Instantiate unpacking module from SPI data
unpack_data m3( .clk(clk) , 
                .reset(reset) , 
					// .spi_cs(spi_cs) , 
					 .incoming_data(parallel_in),
					 .address(address),
					 .write(write),
					 .read(read),
					 .data_in(data_in),
					 .data_valid(new_data));
		
//Instantiate the one port block ram module
memory m2(   .clk(clk) , 
             .reset(reset) , 
				 .wr(write), 
				 .read(read), 
				 .addr(address) ,
				 .data_in(data_in) , 
				 .q(q) );
//Instantiate the parallelto serial converter tor module 
parallel_to_serial_converter m4( .clk(clk),
                               .reset(reset),
										 .spi_clk(spi_clk),
										 .spi_cs(spi_cs),
										 .spi_miso(spi_miso),
										 .q(q),
										 .read_en(read));
endmodule

