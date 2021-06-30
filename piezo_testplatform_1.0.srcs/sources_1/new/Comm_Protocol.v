
module Comm_Protocol(
	input CLK_100MHz,
	input CLK_10MHz,
	input Start,
	input[3:0] Data,
	input[11:0] Charge_Pulses,
	input[15:0] Start_L_us,
	input[11:0] Zero_L,
	input[11:0] One_L,
	input[15:0] Break_L_us,
	output reg Finished = 1,
	output PiezoDriverSignalA_N,
	output PiezoDriverSignalB_P
	

);
	
	reg[7:0] State = 0;

	reg Start_Piezo = 0;
	reg[11:0] Nr_Pulses = 0;
	reg[23:0] Delay_us = 0;
	reg Start_Delay = 0;

	wire Finished_Piezo, Finished_Delay;

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

			0: 	if (Start == 1) begin
					State <= 1;
					Finished <= 0;
				end else State <= 0;	
			1:	begin // Send Charge Pulses
					Nr_Pulses <= Charge_Pulses;
					Start_Piezo <= 1;
					State <= 2;
				end
			2:	begin
					Start_Piezo <= 0;
					State <= 3;
				end
			3:	begin
					Delay_us <= Start_L_us;
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
					if(Data[3] == 1) Nr_Pulses <= One_L;
					else Nr_Pulses <= Zero_L;
					if (Finished_Delay == 1) begin // send 1st Bit
							State <= 6;
							Start_Piezo <= 1;
					end
				end
			6:	begin
					Start_Piezo <= 0;
					State <= 7;
				end
			7:	begin 
					Delay_us <= Break_L_us;
					if (Finished_Piezo == 1) begin
							State <= 8;
							Start_Delay <= 1;
					end
				end
			8:	begin
					Start_Delay <= 0;
					State <= 9;
				end
			9:	begin 
					if(Data[2] == 1) Nr_Pulses <= One_L;
					else Nr_Pulses <= Zero_L;
					if (Finished_Delay == 1) begin // send 2nd Bit
							State <= 10;
							Start_Piezo <= 1;
					end
				end
			10:	begin
					Start_Piezo <= 0;
					State <= 11;
				end
			11:	begin 
					Delay_us <= Break_L_us;
					if (Finished_Piezo == 1) begin
							State <= 12;
							Start_Delay <= 1;
					end
				end
			12:	begin
					Start_Delay <= 0;
					State <= 13;
				end
			13:	begin 
					if(Data[1] == 1) Nr_Pulses <= One_L;
					else Nr_Pulses <= Zero_L;
					if (Finished_Delay == 1) begin // send 3rd Bit
							State <= 14;
							Start_Piezo <= 1;
					end
				end
			14:	begin
					Start_Piezo <= 0;
					State <= 15;
				end
			15:	begin 
					Delay_us <= Break_L_us;
					if (Finished_Piezo == 1) begin
							State <= 16;
							Start_Delay <= 1;
					end
				end
			16:	begin
					Start_Delay <= 0;
					State <= 17;
				end
			17:	begin 
					Start_Delay <= 0;
					if(Data[0] == 1) Nr_Pulses <= One_L;
					else Nr_Pulses <= Zero_L;
					if (Finished_Delay == 1) begin // send 4th Bit
							State <= 18;
							Start_Piezo <= 1;
					end
				end
			18:	begin
					Start_Piezo <= 0;
					State <= 19;
				end
			19:	begin 
					if (Finished_Piezo == 1) begin
							State <= 0;
							Finished <= 1;
					end
				end
		endcase
	end

endmodule
