// Logan Mar and Timothy yi
// 11/19/2022
// EE 271
// Lab 4


// This top-level module displays the results the result of a winner in tug a war
//  The inputs are KEY[0], KEY[3], and SW[9] The outputs are the HEX display 0 
// which shows 1 if the left player wins and 2 if right player wins

// Overall inputs and outputs to the DE1_SoC module are listed below:
// Inputs: 10-bit SWs, 4-bit KEYs
// Outputs: 7-bit HEXs, 10-bit LEDRs
module DE1_SoC (CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
	
	input logic CLOCK_50; // 50MHz clock
	output logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	output logic [9:0] LEDR;
	input logic [3:0] KEY; // Active low property
	input logic [9:0] SW;
	logic [3:0] BCDL, BCDR;
	// turns off HEX's not in use

	assign HEX2 = 7'b1111111;
	assign HEX3 = 7'b1111111;
	assign HEX4 = 7'b1111111;
	assign HEX5 = 7'b1111111;
	

	// Generate clk off of CLOCK_50, whichClock picks rate.

	logic [31:0] clk;
	logic reset;  // configure reset
	parameter whichClock = 20;// .75Hz //20 24Hz / 19 ~50Hz
	logic lightreset, GameresetL, GameresetR ; 
	assign lightreset = reset | GameresetL |GameresetR;

	clock_divider cdiv (CLOCK_50, clk);


	logic L, R, Win;

	assign reset = SW[9];//~KEY[2]; // Reset when SW[9]
	logic Select;
	assign Select =clk[whichClock];
	logic key0, key3, fakekey; //stable
	logic [9:0]LFSR;
	
	
	//assign LEDR[5] = clk[whichClock];
	
	// instantiates Hazard light and assigned corresponding ports
	//fsm f1 (.clk(clk[whichClock]), .reset(reset), .w(SW[0]), .out(LEDR[0]));
	
	//fsm f1 (.clk(CLOCK_50), .reset(reset), .w(SW[0]), .out(LEDR[0]));
	
	// fixes metastablity 
	delayer KS0 (.clk(Select), .reset, .button(~fakekey), .out(key0)); 
	delayer KS3 (.clk(Select), .reset, .button(~KEY[3]), .out(key3));
	
	// random value generator
	lfsr10 random(.out(LFSR), .reset, .CLOCK_50(Select));
	// creates the machine that gives a fakekey press
	comparator10 value0(.LFSR, .Switch({1'b0, SW[8:0]}), .press(fakekey));
	// button pusher for the left (user input) and right(right is automated player)
	Clock_fixer buttonRight(.clk(Select),.reset, .w(fakekey), .out(R));
	Clock_fixer buttonLeft(.clk(Select),.reset, .w(key3), .out(L));
	
	// displays the number for the left hex 1
	seg7 winDisplayL (.bcd(BCDL), .leds(HEX1));
	// displays the number for right play hex0
	seg7 winDisplayR (.bcd(BCDR), .leds(HEX0));

	
	// this show the winner of the tug of war
	//Winning Winning_state (.clk(CLOCK_50),.reset, .L, .R, .L9(LEDR[9]),.L1(LEDR[1]), .BCD(BCD));
	// left win updater
 Winning leftwin(.clk(Select), .reset(reset), .L(R), .W(L), .endlight(LEDR[9]), .BCD(BCDL),.gamereset(GameresetL));
 Winning rightwin(.clk(Select), .reset(reset), .L(L), .W(R), .endlight(LEDR[1]), .BCD(BCDR),.gamereset(GameresetR));

	// this is all the possible combination and cases
	normalLight S0 (.clk(Select), .reset (lightreset), .L, .R, .NL(LEDR[2]),.NR(Win),.lightOn(LEDR[1]));
	normalLight S1 (.clk(Select), .reset(lightreset), .L, .R, .NL(LEDR[3]),.NR(LEDR[1]),.lightOn(LEDR[2]));
	normalLight S2 (.clk(Select), .reset(lightreset), .L, .R, .NL(LEDR[4]),.NR(LEDR[2]), .lightOn(LEDR[3]));
	normalLight S3 (.clk(Select), .reset(lightreset), .L, .R, .NL(LEDR[5]),.NR(LEDR[3]), .lightOn(LEDR[4]));
	// light is on when reset in the center of the ledr
	centerLight S4 (.clk(Select), .reset (lightreset), .L, .R, .NL(LEDR [6]),.NR(LEDR[4]), .lightOn(LEDR[5]));
	
	normalLight S5 (.clk(Select), .reset(lightreset), .L, .R, .NL(LEDR [7]),.NR(LEDR[5]), .lightOn(LEDR[6]));
	normalLight S6 (.clk(Select), .reset(lightreset), .L, .R, .NL(LEDR [8]),.NR(LEDR[6]), .lightOn(LEDR[7]));
	normalLight S7 (.clk(Select), .reset(lightreset), .L, .R, .NL(LEDR [9]),.NR(LEDR[7]), .lightOn(LEDR[8]));
	normalLight S8 (.clk(Select), .reset(lightreset), .L, .R, .NL(Win), .NR(LEDR[8]), .lightOn(LEDR[9]));
	
	

endmodule

//  test possible cases of wining either for the right or left player
module DE1_SoC_testbench();

/*logic [9:0]SW;
logic [2:0]KEY;
logic [9:0] LEDR;
logic CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;*/
	logic CLOCK_50; // 50MHz clock
	logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	logic [9:0] LEDR;
	logic [3:0] KEY; // Active low property
	 logic [9:0] SW;
	logic [3:0] BCDL, BCDR;
		logic [31:0] clk;
	logic reset;  // configure reset

	logic lightreset, GameresetL, GameresetR ;
	logic L, R, Win;

	logic Select;

	logic key0, key3, fakekey; //stable
	logic [9:0]LFSR;

DE1_SoC dut(CLOCK_50, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, KEY, LEDR, SW);
           
		parameter clock_period = 100;
		
		initial begin
				CLOCK_50<= 0;
			forever #(clock_period /2) CLOCK_50 <= ~CLOCK_50;;
					
		end //initial
			// Test the winners of the two players
	initial begin
	repeat(1) @(posedge CLOCK_50);
		// creates/sets values to identiify key cases
			
	    						
				SW[9:0] <= ~10'b1000000000;@(posedge CLOCK_50);// reset
				SW[9:0] <= ~10'b0; repeat(20) @(posedge CLOCK_50);// zero key presses
				SW[9:0] <= ~10'b0111111111; repeat(20) @(posedge CLOCK_50); // key presses half the time about two wins auto reset , 0 1 , 2
				SW[9:0] <= ~10'b0001111111; repeat(50) @(posedge CLOCK_50); // presses 1/8 of the time // 
				SW[9:0] <= ~10'b0000011111; repeat(200) @(posedge CLOCK_50); //1/32 three keys out 100 // 4 or 5
				
		

	
	
	$stop; // End the simulation.
	end
endmodule


