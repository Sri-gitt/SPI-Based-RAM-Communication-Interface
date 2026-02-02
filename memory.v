module memory( input clk,reset,wr,read,
               input [7:0]data_in,
					input [3:0]addr,
					output [7:0]q);
				
			
 ram inst(  .clock(clk),
            .wren(wr) , 
				.rden(read) ,
            .address(addr) , 
				.data(data_in) , 
				.q(q) );
			
endmodule
			  