
module Delay(
	input[23:0] Delay_us,
	input Start,
	input CLK_10MHz,
	output reg Finished = 1
	);

	reg Start_Merker = 0;
	reg[23:0] Counter = 0;
	reg[3:0] Counter_10 = 0;

	always@(posedge CLK_10MHz) begin
		
		Start_Merker <= Start;
		if(Start_Merker == 0 && Start == 1) begin
			Finished <= 0;
		end

		if(Finished == 1) begin
			Counter_10 <= 0;
			Counter <= 1;
		end else begin

		//Divide by 10
			if(Counter_10 == 9) begin
				Counter_10 <= 0;

				// Create Delay
			
			 	if (Finished == 0) begin
            				Counter <= Counter + 1;
					if(Counter == Delay_us) begin
						Finished <= 1;
					end else begin
            					Finished <= 0;
					end
				end else Counter <= 0;
				end else begin
					Counter_10 <= Counter_10 + 1;
				end
			end
	end

endmodule