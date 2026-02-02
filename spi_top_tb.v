`timescale 1ns/1ps

module spi_top_tb;

    reg clk;
    reg reset;
    reg spi_clk;
	 reg spi_clk_temp;
    reg spi_cs;
    reg spi_mosi;
    wire spi_miso;
    integer j;
    integer i;
	// integer k;
    //reg [7:0] read_val;

    // DUT
    spi_top dut (
        .clk(clk),
        .reset(reset),
        .spi_clk(spi_clk),
        .spi_cs(spi_cs),
        .spi_mosi(spi_mosi),
        .spi_miso(spi_miso)
    );

    // 100 MHz clk
    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // 100 MHz SPI clk temp
    initial begin
        spi_clk_temp = 1;
        forever #10 spi_clk_temp = ~spi_clk_temp;
    end
	 
	     // 50 MHz SPI clk
	 always @(spi_cs, spi_clk_temp)
    begin
		spi_clk <= spi_clk_temp & ~spi_cs;
    end

    // Write 16-bit packet
    task spi_packet_write(input [15:0] packet);
	 
        begin
            @(negedge spi_clk_temp);
				spi_cs = 0;
				
            for (i = 0; i <= 15; i = i+1) begin
                @(posedge spi_clk);
				    spi_mosi = packet[i];
            end
				
				#19;
            spi_cs = 1;
				
            #50;
				end 
				endtask
		// read 7 bit packet 	
	     task spi_packet_read(input [7:0] packet);
        integer k;
        reg [7:0] read_val;
        begin
            read_val = 0;
            @(negedge spi_clk_temp);
				spi_cs = 0;

            // Send 16-bit command
            for (j = 0; j <= 7; j = j+1) begin
                @(posedge spi_clk);
					 spi_mosi = packet[j];
            end
				// send 6 dummy bits 
				for (k = 0; k <= 6; k = k+1) begin
                @(posedge spi_clk);
            end 				
            // wait for 8 cycles to sample the data
				for (k = 0; k <= 7; k = k+1) begin
                @(posedge spi_clk);
                read_val[k] = spi_miso;
            end 

				#19;
            spi_cs = 1;
				
            #50;
        end
    endtask

  
   

    // Test sequence
    initial begin
        reset = 1; spi_cs = 1; spi_mosi = 0;
        #10 reset = 0;

        // Write packets
        spi_packet_write({8'hAA, 4'h0, 4'h1}); 
        spi_packet_write({8'hBB, 4'h1, 4'h1}); 
        spi_packet_write({8'hCC, 4'h2, 4'h1}); 
		  spi_packet_write({8'hDD, 4'h3, 4'h1}); 
        spi_packet_write({8'hff, 4'h4, 4'h1});
        spi_packet_write({8'h9 , 4'h5, 4'h1});
		  spi_packet_write({8'h8 , 4'h6, 4'h1});
		  spi_packet_write({8'hA , 4'h7, 4'h1});
		  spi_packet_write({8'hB , 4'h8, 4'h1});
		  spi_packet_write({8'hBC, 4'h9, 4'h1});
		  spi_packet_write({8'hDE, 4'hA, 4'h1});
		  spi_packet_write({8'hEE, 4'hB, 4'h1});
		  spi_packet_write({8'hC , 4'hC, 4'h1});
		  spi_packet_write({8'h7 , 4'hD, 4'h1});
		  spi_packet_write({8'h6 , 4'hE, 4'h1});
		  spi_packet_write({8'h1A, 4'hF, 4'h1});
        #100;

        //  Reads packets
		
        spi_packet_read({ 4'h0, 4'h2}); 
        spi_packet_read({ 4'h1, 4'h2}); 
		  spi_packet_read({ 4'h2, 4'h2}); 	
        spi_packet_read({ 4'h3, 4'h2}); 
		  spi_packet_read({ 4'h4, 4'h2});
		  spi_packet_read({ 4'h5, 4'h2});
		  spi_packet_read({ 4'h6, 4'h2});
		  spi_packet_read({ 4'h7, 4'h2});
		  spi_packet_read({ 4'h8, 4'h2});
		  spi_packet_read({ 4'h9, 4'h2});
		  spi_packet_read({ 4'hA, 4'h2});
		  spi_packet_read({ 4'hB, 4'h2});
		  spi_packet_read({ 4'hC, 4'h2});
		  spi_packet_read({ 4'hD, 4'h2});
		  spi_packet_read({ 4'hE, 4'h2});
		  spi_packet_read({ 4'hF, 4'h2}); 
		  spi_packet_write({8'h00 ,4'h0, 4'h2});
        #500 $stop;
    end

endmodule

    