module unpack_data(
    input  wire        clk,        // synchronization clock signal 
    input  wire        reset,      // overall reset signal            
    input  wire [15:0] incoming_data,  // serial data from slave to master
	 input  wire        data_valid,
    output reg         write,      // Write strobe for the blockram
    output reg         read,       // Read  strobe for the blockram
    output reg  [3:0]  address,    // block RAM address
    output reg  [7:0]  data_in     // data to be written to block RAM
	
);
   
	 reg data_valid_reg1, data_valid_reg2;


    always @(posedge clk) begin
        if (reset) begin
            read       <= 1'b0;
            write      <= 1'b0;
            address    <= 4'd0;
            data_in    <= 8'd0;
				data_valid_reg1 <= 1'b0;
				data_valid_reg2 <= 1'b0;
           
        end else begin
            // Default outputs for pulse
            write <= 1'b0;
            read  <= 1'b0;

            // Extract command, address, and data
            address <= incoming_data[7:4];
            data_in <= incoming_data[15:8];
				data_valid_reg1 <= data_valid;
				data_valid_reg2 <= data_valid_reg1;

				if ((incoming_data[3:0] == 4'b0001) && (data_valid_reg1 == 1'b1) && (data_valid_reg2 == 1'b0)) // write operation
				begin
				  write <= 1'b1; 
				  end
				  else
				  begin
				 write <= 1'b0;
				  end 
			  if ((incoming_data[3:0]  == 4'b0010) && (data_valid_reg1 == 1'b1) && (data_valid_reg2 == 1'b0)) // read operation
				begin
				  read <= 1'b1;
				  end
				  else
				  begin
				  read <= 1'b0;
				  end 
				
    end
	 end 
endmodule
 