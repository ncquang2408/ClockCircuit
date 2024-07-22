module PULSE(CLOCK,OUTPUT);
	input		CLOCK;
	output	reg	OUTPUT;
	reg		cycle = 0;
	
	always @(posedge CLOCK) begin
		if(cycle >= 49999999) begin
			cycle  <= 0;
			OUTPUT <= 1;
		end 
		else begin 
			OUTPUT <= 0;
			cycle <= cycle + 1'b1;
		end 
	end
endmodule 

	
module DECODE(bin, HEX);
    input [3:0] bin;
    output reg [0:6] HEX;

always @(*)
	begin
		HEX = (bin == 4'b0000) ? 7'b0000001 : // 0
				(bin == 4'b0001) ? 7'b1001111 : // 1
				(bin == 4'b0010) ? 7'b0010010 : // 2
				(bin == 4'b0011) ? 7'b0000110 : // 3
				(bin == 4'b0100) ? 7'b1001100 : // 4
				(bin == 4'b0101) ? 7'b0100100 : // 5
				(bin == 4'b0110) ? 7'b0100000 : // 6
				(bin == 4'b0111) ? 7'b0001111 : // 7
				(bin == 4'b1000) ? 7'b0000000 : // 8
				(bin == 4'b1001) ? 7'b0000100 : // 9
				(bin == 4'b1010) ? 7'b0001000 : // A
				(bin == 4'b1011) ? 7'b1100000 : // B
				(bin == 4'b1100) ? 7'b0110001 : // C
				(bin == 4'b1101) ? 7'b1000010 : // D
				(bin == 4'b1110) ? 7'b0110000 : // E
				7'b0111000;  // F
	end

endmodule


module Clockcircuit(clock,HEX0,HEX1,HEX2,HEX3,KEY);
	input clock;
	input  [1:0] KEY;
	output [0:6] HEX0, HEX1 , HEX2 , HEX3;
	//reg	pulse = 0;
	reg	phut0,phut,giay0,giay = 0;
	reg	counter = 0;
	reg 	button_changed;
	reg 	button_state, button_state_prev;
	
	PULSE(clock,pulse);
	
	always @(posedge pulse)begin
		  button_state_prev <= button_state;
        button_state <= KEY[1];
        if (!button_state_prev && button_state) begin
            button_changed <= ~button_changed;
        end
	if(button_changed) begin
		giay  <= giay ;
		giay0 <= giay0;
		phut  <= phut ;
		phut0 <= phut0;
	end
	else begin	
		giay <= giay + 1'b1;
		if(giay >=9)begin
			giay  <= 0;
			giay0 <= giay0 + 1'b1;
			if(giay0 >=6)begin
				giay0 <= 0;
				phut <= phut + 1'b1;
				if(phut >=9)begin
					phut  <= 0;
					phut0 <= phut0 + 1'b1;
					if(phut0>=6) begin
						phut0 <=0;
					end
				end
			end
		end	
	end

	if(KEY[0])begin
		giay  <= 0;
		giay0 <= 0;
		phut  <= 0;
		phut0 <= 0;
	end
	end
	
	DECODE((giay), (HEX0));
	DECODE((giay0), (HEX1));
	DECODE((phut), (HEX2));
	DECODE((phut0), (HEX3));
endmodule 

	