// Logan Mar and Timothy
// 11/19/2022
// EE 271
// Lab 4
 
// Takes in an input of the current states and the next states of 
// the board to determine if the LED should be on or off.

// Input: the current and next state of the LED. All the inputs are 1 bit clk, reset, L, R, NL, NR
// Output: Either an "on" or "off" for depening on the state of the LED. output lighOn is one bit. 
// output lighOn is one bit

module normalLight (clk, reset, L, R, NL, NR, lightOn);
	input logic clk, reset, L, R, NL, NR; 
	output logic lightOn; 
	
	enum {off, on} ps, ns;
	// creates the logic LEDs states
	always_comb  begin
	case(ps)
	off: if(~L & R & NL | L & ~R & NR) ns = on;
	else
		ns = off;
		
	on: if (L & ~R | R & ~L) ns = off;
		else ns = on;
endcase
end

	//sequential logic (DFFs)
	always_ff @(posedge clk) begin
  
		if (reset)
			ps <= off;
		else
			ps <= ns;
end

assign lightOn = (ps == on);

endmodule

// Tests every possible combination of the inputs of the KEYs
module normalLight_testbench();
	logic clk, reset, L, R, NL, NR, lightOn;
	// Instantiates normalLight
	normalLight dut (.lightOn, .clk, .reset, .L, .R, .NL, .NR);
	
	// creates a clock
	parameter clock_period = 100; // controls clock period
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk; // creates wave function
	end //initial
	
	initial begin
		// creates/set values to identiify key cases													
		reset <= 1; 						@(posedge clk);
		reset <= 0;   L <= 1; NR <= 0;@(posedge clk);
						NL <= 0; R <= 0;  @(posedge clk);
												@(posedge clk);
												@(posedge clk);
												@(posedge clk);
		reset <= 1; 						@(posedge clk);
		reset <= 0;   L <= 0; NR <= 0;@(posedge clk);
						NL <= 0; R <= 1;  @(posedge clk);
												@(posedge clk);
		reset <= 1; 						@(posedge clk);
		reset <= 0;   L <= 1; NR <= 0;@(posedge clk);
						NL <= 0; R <= 0;  @(posedge clk);
						R <= 1;  NL <=1;  @(posedge clk);	
												@(posedge clk);
		reset <= 1; 						@(posedge clk);
		reset <= 0;   L <= 0; NR <= 0;@(posedge clk);
						NL <= 0; R <= 1;  @(posedge clk);
						L <= 1; NR <= 1;  @(posedge clk);	
												@(posedge clk);	
												@(posedge clk);			
		reset <= 1; 						@(posedge clk);
		reset <= 0;   L <= 0; NR <= 0;@(posedge clk);
						NL <= 0;   R <= 0;@(posedge clk);
												@(posedge clk);
	$stop; // End the simulation.
	end
endmodule
