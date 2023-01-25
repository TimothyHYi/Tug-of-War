// Logan Mar and Timothy yi
// 11/29/2022
// EE 271
// Lab 5

// creates a counter that increase by one 
// inputs all one bit inner reset, CLOCK_50
// outputs 8 bit out
module upcount3 (out, inner, reset, CLOCK_50);
	parameter width = 8; // state the width of bit
	output logic [width-1 : 0] out; 
	input logic inner, reset, CLOCK_50;
	
	// creates the adding of each bit 
	always_ff@(posedge CLOCK_50)
		begin
		if(reset) 
			out<=0; 
			else if (inner)
			out <= 1+out;
		end
endmodule

// test the upcounter 
module testbench_upcount3();

	parameter width = 8;
	logic [width-1 : 0] out;
	logic inner, reset, CLOCK_50;
	// instantates the upcount3
	upcount3 dut (.out, .inner, .reset, .CLOCK_50);
		
		parameter clock_period = 100; // set period
		
		initial begin
			CLOCK_50 <= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50; // creates wavefunction
					
		end //initial
		
		initial begin
		// creates the simulation of each count
			reset <= 1;         @(posedge CLOCK_50);
			reset <= 0;  inner <=0;   @(posedge CLOCK_50);
									  @(posedge CLOCK_50);
			                    @(posedge CLOCK_50);	
			                    @(posedge CLOCK_50);	
			              @(posedge CLOCK_50);
									  @(posedge CLOCK_50); // added one 
							  inner<=1; @(posedge CLOCK_50);	
							   inner<= 1;@(posedge CLOCK_50);	
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
		
		