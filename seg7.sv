module seg7 (bcd, leds);  
	input  logic [3:0] bcd;
	output logic [6:0] leds;  
	always_comb begin   case 
		(bcd)
			//          Light: 6543210
			4'b0000: leds = 7'b1000000; // 0
			4'b0001: leds = 7'b1111001; // 1
			4'b0010: leds = 7'b0100100; // 2
			4'b0011: leds = 7'b0110000; // 3
			4'b0100: leds = 7'b0011001; // 4
			4'b0101: leds = 7'b0010010; // 5
			4'b0110: leds = 7'b0000010; // 6  
			4'b0111: leds = 7'b1111000; // 7
			4'b1000: leds = 7'b0000000; // 8            
			4'b1001: leds = 7'b0010000; // 9     
		default: leds = 7'bX;   endcase   
	end  
endmodule

// test to see if seg7 works with bcd
module test_benchseg7(); 

	logic [3:0] bcd;
	logic [6:0] leds; 
	
	seg7 test(.bcd, .leds); 
	// test if bcd corresonps to right led
	initial begin
		
		bcd = 4'b0000; #10;
		bcd = 4'b0001; #10;
		bcd = 4'b0010; #10;
	end
endmodule 
	
