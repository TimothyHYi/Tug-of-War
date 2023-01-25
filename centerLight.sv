module centerLight (clk, reset, L, R, NL, NR, lightOn);
	input logic clk, reset, L, R, NL, NR; 
	output logic lightOn; 
	
	enum {off, on} ps, ns;
	
	always_comb  begin
	case(ps)
	off: if(~L & R & NL | L & ~R & NR) ns = on;
	else
		ns = off;
		
	on: if (L & ~R | R & ~L) ns = off;
		else ns = on;
endcase
end

	always_ff @(posedge clk) begin
  
		if (reset)
			ps <= on;
		else
			ps <= ns;
end

assign lightOn = (ps == on);

endmodule

module centerLight_testbench();
	logic clk, reset, L, R, NL, NR, lightOn;

centerLight dut(.clk, .reset, .L, .R, .NL, .NR, .lightOn);

	parameter CLOCK_PERIOD = 100;
	initial begin
	clk <= 0;
	forever #(CLOCK_PERIOD/2) clk <= ~clk; // Forever toggle the clock
	end
	// Test the design.
	initial begin
	
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