// Logan Mar and Timothy yi
// 11/19/2022
// EE 271
// Lab 4
// this module is the button pusher and lets you click left and right
// inputs:are all one bit clk, reset, w; 
// output: one bit out

module Clock_fixer(clk, reset, w, out);
// w is the button
	input  logic  clk, reset, w;
	output logic  out;
	
	enum {S0, S1} ps, ns; // Present state, next state

	//Next state logic for each state
	always_comb begin
		case (ps)
			S0: if (w) ns = S1; // key is pressed s1
					else ns = S0; // not pressed s0
			S1: if (~w) ns = S0; // not press s0
					else ns = S1; // press states s1
		endcase
	end
			
	assign out = (ps == S0) & w;  //use this statement or the next one

	//sequential logic (DFFs)
		always_ff @(posedge clk) begin
			if (reset)
				ps <= S0;
			else
				ps <= ns;
		end
				
	
endmodule


// this simulates the clock_fixer_testbench simulates a button push
module Clock_fixer_testbench();

		logic clk, reset, w, out;
		
		 Clock_fixer dut (.clk, .reset, .w, .out);
		
		//clock setup
		parameter clock_period = 100;
		
		initial begin
			clk <= 0;
			forever #(clock_period /2) clk <= ~clk;
					
		end //initial
		
		initial begin
			// creates/set values to identiify key cases
			reset <= 1;         @(posedge clk);
			reset <= 0; w<=0;   @(posedge clk);
									  @(posedge clk);
			                    @(posedge clk);	
			                    @(posedge clk);	
			            w<=1;   @(posedge clk);
									  @(posedge clk); // added one 
							w<=0;   @(posedge clk);	
							w<=1;   @(posedge clk);	
									  @(posedge clk);	
			                    @(posedge clk);	
			                    @(posedge clk);	
							w<=0;   @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);	
									  @(posedge clk);
							w<=1;   @(posedge clk);	
							w<=0;   @(posedge clk);	
							w<=1;   @(posedge clk);	
									  @(posedge clk);
									  @(posedge clk);
			$stop; //end simulation							
							
		end //initial
		
endmodule		
