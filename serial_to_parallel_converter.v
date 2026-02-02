module serial_to_parallel_converter(
    input  wire       clk, 
    input wire        spi_clk,
	 input wire        spi_cs,
    input  wire       reset,     
    input  wire      spi_mosi,
    output reg [15:0] parallel_out,   
    output reg        new_data );

    reg [15:0] shift_reg;
    reg [4:0]  bit_count;
	 reg        spi_cs_reg1, spi_cs_reg2, spi_cs_reg3;
	 reg        shift_reg_clear;

    always @(negedge spi_clk or posedge reset or posedge shift_reg_clear) begin
        if (reset) begin
            shift_reg <= 16'b0;
            parallel_out  <= 16'b0;
            bit_count <= 5'd0;
            new_data  <= 0;
        end
		  else if (shift_reg_clear == 1'b1) begin
            shift_reg <= 16'b0;
            parallel_out  <= parallel_out;
            bit_count <= 5'd0;
            new_data  <= new_data;
        end  
          else if (shift_reg_clear == 1'b0 ) begin
            // Shift in LSB first
            shift_reg <= { spi_mosi,shift_reg[15:1]};
            if (bit_count == 15) begin
				   bit_count <= 5'd0;
					 parallel_out <= {spi_mosi,shift_reg[15:1]};
					 
                new_data <= 1;
          end
			 else begin
			  bit_count <= bit_count + 1;
			  parallel_out <= parallel_out;
			new_data     <= 1'b0;
			end 
end 
     else begin
				     shift_reg <= 16'd0;
                 bit_count <= 5'd0;
					  parallel_out <= parallel_out;
             end
               
  end
       
 always @(posedge clk) begin
        if (reset) begin
            spi_cs_reg1 <= 1'b0;
				spi_cs_reg2 <= 1'b0;
				spi_cs_reg3 <= 1'b0;
				shift_reg_clear <= 1'b0;
        end 
        else begin
				spi_cs_reg1 <= spi_cs;
            spi_cs_reg2 <= spi_cs_reg1;
            spi_cs_reg3 <= spi_cs_reg2; 
				if (spi_cs_reg2 == 1'b1 && spi_cs_reg3 == 1'b0) begin
              shift_reg_clear <= 1'b1;
				end
				else begin
				  shift_reg_clear <= 1'b0;
	         end
            end				
        end

endmodule 



