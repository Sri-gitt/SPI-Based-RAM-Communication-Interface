module parallel_to_serial_converter(
    input  wire       clk,        // system clock for BRAM
    input  wire       reset,
    input  wire       spi_clk,    // SPI clock
    input  wire       spi_cs,     // Chip select active low
    input  wire       read_en,    // 1-cycle pulse from unpack (clk domain)
    input  wire [7:0] q,          // BRAM output
    output reg        spi_miso
);
parameter PROCESS_DELAY = 4;

    reg [4:0] cycle_cnt = 0;
    reg [7:0] piso_shift = 0;
    reg       active = 0;

    // SPI clock domain for shifting
   always @(negedge spi_clk) begin
       if (reset) begin
            cycle_cnt   <= 0;
            piso_shift  <= 0;
            spi_miso    <= 0;
            active      <= 0;
        end 
        else 
            // Start new transaction if a read_en  arrives 
            if (read_en) begin
               active     <= 1;
                cycle_cnt  <= 0;
              
          end

           if (active) begin
               cycle_cnt <= cycle_cnt + 1;

                // Load RAM data after processing delay
                if (cycle_cnt == PROCESS_DELAY) begin
                    piso_shift <= q;
                end

                // Shift out data MSB first
              
					if (cycle_cnt > PROCESS_DELAY) begin
                    spi_miso   <= piso_shift[7];
                    piso_shift <= {piso_shift[6:0], 1'b0};
                end

               if (cycle_cnt == 14) begin
                   active <= 0;
               end
          

            end
        end
   
endmodule


