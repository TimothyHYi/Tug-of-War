// create a random 10 bit generator
// input are  all one bit reset, CLOCK_50
// output 10 bits for out 


module lfsr10 (out, reset, CLOCK_50);
	output logic [9 : 0] out; // out ps 
	input logic reset, CLOCK_50;
	logic [9:0] ns; // intermidate step
	// create conatination  of bits

	assign ns = (out[0] ~^ out[3]); // takes the 0 and 3 third bit and nxor
	
	// creates the adding of each bit 
	always_ff@(posedge CLOCK_50)
		begin
		if(reset) 
			out<=10'b1111111111;
		else	
			out <= {ns, out[9:1]};
		end
endmodule

// test the lfsr10 counter 
module testbench_st10();

	logic [9 : 0] out;
	logic reset, CLOCK_50;
	logic [9:0] ns;
	// instantates the 
	lfsr10 dut (.out, .reset, .CLOCK_50);
		
		parameter clock_period = 100; // set period
		
		initial begin
			CLOCK_50 <= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50; // creates wavefunction
					
		end //initial
		
		initial begin
		
		// creates the xnor cyle
			reset <= 1;         @(posedge CLOCK_50);
			reset <= 0; @(posedge CLOCK_50);
									  @(posedge CLOCK_50);
			                    @(posedge CLOCK_50);	
			                    @(posedge CLOCK_50);	
			               @(posedge CLOCK_50);
									  @(posedge CLOCK_50); // added one 
							    @(posedge CLOCK_50);	
							   @(posedge CLOCK_50);	
									  @(posedge CLOCK_50);	
			                    @(posedge CLOCK_50);	
			                     @(posedge CLOCK_50);	
							   @(posedge CLOCK_50);	
									  @(posedge CLOCK_50);	
									  @(posedge CLOCK_50);	
									  @(posedge CLOCK_50);
								     @(posedge CLOCK_50);
									  @(posedge CLOCK_50);
							   @(posedge CLOCK_50);	
							   @(posedge CLOCK_50);	
							@(posedge CLOCK_50);	
									  @(posedge CLOCK_50);
									  @(posedge CLOCK_50);
			$stop; //end simulation							
							
		end //initial
		
endmodule
		
		