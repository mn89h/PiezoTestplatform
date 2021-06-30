
module Repeat_Transmit(
	input[11:0] Nr_Pulses,
	input[23:0] Delay_us,
	input Enable,
	input CLK_10MHz,
	input CLK_100MHz,
	output PiezoDriverSignalA_N,
	output PiezoDriverSignalB_P
	);

	reg[3:0] State = 0;
	wire Finished_Piezo, Finished_Delay;
	reg Start_Piezo = 0;
	reg Start_Delay = 0;

	MosFet_Driver MosFet_Inst(
		.CLK_100(CLK_100MHz),
		.Nr_Pulses(Nr_Pulses),
		.Start(Start_Piezo),
		.Finished(Finished_Piezo),
		.PiezoDriverSignalA_N(PiezoDriverSignalA_N),
		.PiezoDriverSignalB_P(PiezoDriverSignalB_P)
	);

	Delay Delay_Inst(
		.Delay_us(Delay_us),
		.Start(Start_Delay),
		.CLK_10MHz(CLK_10MHz),
		.Finished(Finished_Delay)
	);

	always@(posedge CLK_10MHz) begin

		case (State)

			0: 	if (Enable == 1) begin
					State <= 1;
				end else State <= 0;	
			1:	begin // Send Charge Pulses
					Start_Piezo <= 1;
					State <= 2;
				end
			2:	begin
					Start_Piezo <= 0;
					State <= 3;
				end
			3:	begin
					if (Finished_Piezo == 1) begin
							State <= 4;
							Start_Delay <= 1;
					end
				end
			4:	begin
					Start_Delay <= 0;
					State <= 5;
				end
			5:	begin // Wait for start signal
					if (Finished_Delay == 1) begin // send 1st Bit
							State <= 0;
					end else State <= 5;
				end

		endcase
	end


endmodule
