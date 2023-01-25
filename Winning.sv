// determines the wins and counts the amount of times a player has won 
module Winning(clk, reset, L, W, endlight, BCD,gamereset);
	input logic clk, reset, L, W, endlight;
	output logic [3:0] BCD;
	output logic gamereset;
	logic [2:0] nextcount, count;
	
	enum {Nothing, win} ps, ns; 
	
	// creates possible cases of winning
	always_comb  begin
		case(ps)
			Nothing: if(~L & W & endlight) begin
					ns = win; 
					nextcount = 1 + count; // adds a bit
					gamereset = 1'b1; 
			end
				else begin
					ns = Nothing;
								nextcount = count;
								gamereset = 1'b0;
					end
					
			win: begin
			
			ns = Nothing; 
			nextcount = count;
			gamereset = 1'b0;
			end
		endcase
	end 
	
		assign BCD = {1'b0, count}; // concatation of bits


	
	always_ff @(posedge clk) begin
		if (reset)begin
			ps <= Nothing;
			count <= 3'b000;
			end
		else begin
			ps <= ns;
			count <= nextcount;
			end
			
	end
endmodule 

module testwinning();

	logic clk, reset, L, W, endlight;
	logic [3:0] BCD;
	logic gamereset;
	logic [2:0] nextcount, count;
	
	
 Winning dut(.clk, .reset, .L, .W, .endlight, .BCD, .gamereset);
 
	// creates a clock
	parameter clock_period = 100; // controls clock period
	initial begin
		clk <= 0;
		forever #(clock_period /2) clk <= ~clk; // creates wave function
	end //initial
	
		initial begin
			reset <= 1; 						@(posedge clk);
			reset <= 0; L<= 0;W <=1; endlight <= 1;   @(posedge clk); 
			endlight<=0; repeat(20)@(posedge clk);
			
			L<=1; W<= 0; endlight <=0; repeat(20) @(posedge clk);
			endlight <=1; @(posedge clk); endlight <=0; repeat(5) @(posedge clk);
			 L<= 0;W <=1; endlight <= 1;   @(posedge clk); endlight <= 0;  
			repeat(20)@(posedge clk);	
				L<=0; W<= 0; endlight <=0; repeat(20) @(posedge clk);
			endlight <=1; repeat(10) @(posedge clk);
		    L<= 1;W <=1; endlight <= 0;   @(posedge clk); 
			repeat(20)@(posedge clk);	
			
			
		$stop; // end simuluation
		end
endmodule 
	
	
	