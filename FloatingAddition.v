`timescale 1ns / 1ps
module FloatingAddition #(parameter XLEN=32)
                        (input [XLEN-1:0]A,
                         input [XLEN-1:0]B,
                         input clk,
                         output overflow,
                         output underflow,
                         output exception,
                         output reg  [XLEN-1:0] result);

reg [23:0] A_Mantissa,B_Mantissa;
reg [23:0] Temp_Mantissa;
reg [22:0] Mantissa;
reg [7:0] Exponent;
reg Sign;
wire MSB;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
reg A_sign,B_sign,Temp_sign;
reg [32:0] Temp;
reg carry;
reg [2:0] one_hot;
reg comp;
reg [4:0] shift;
reg [7:0] exp_adjust;
always @(*)
begin

comp =  (A[30:23] >= B[30:23])? 1'b1 : 1'b0;
  
A_Mantissa = comp ? {1'b1,A[22:0]} : {1'b1,B[22:0]};
A_Exponent = comp ? A[30:23] : B[30:23];
A_sign = comp ? A[31] : B[31];
  
B_Mantissa = comp ? {1'b1,B[22:0]} : {1'b1,A[22:0]};
B_Exponent = comp ? B[30:23] : A[30:23];
B_sign = comp ? B[31] : A[31];

diff_Exponent = A_Exponent-B_Exponent;
B_Mantissa = (B_Mantissa >> diff_Exponent);
{carry,Temp_Mantissa} =  (A_sign ~^ B_sign)? A_Mantissa + B_Mantissa : A_Mantissa-B_Mantissa ; 
exp_adjust = A_Exponent;
if(carry)
    begin
        Temp_Mantissa = Temp_Mantissa>>1;
        exp_adjust = exp_adjust+1'b1;
    end
else
    begin
//    while(!Temp_Mantissa[23])
//        begin
//           Temp_Mantissa = Temp_Mantissa<<1;
//           exp_adjust =  exp_adjust-1'b1;
//        end
casex (Temp_Mantissa)
		
		24'b01xx_xxxx_xxxx_xxxx_xxxx_xxxx : 	begin						
										 			Temp_Mantissa = Temp_Mantissa << 1;
									 				shift = 5'd1;
									 				exp_adjust = exp_adjust - shift;
								 			  	end

		24'b001x_xxxx_xxxx_xxxx_xxxx_xxxx : 	begin						
										 			Temp_Mantissa = Temp_Mantissa << 2;
									 				shift = 5'd2;
									 				exp_adjust = exp_adjust - shift;
								 				end

		24'b0001_xxxx_xxxx_xxxx_xxxx_xxxx : 	begin 							
													Temp_Mantissa = Temp_Mantissa << 3;
								 	 				shift = 5'd3;
								 	 				exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_1xxx_xxxx_xxxx_xxxx_xxxx : 	begin						
									 				Temp_Mantissa = Temp_Mantissa << 4;
								 	 				shift = 5'd4;
								 	 				exp_adjust = exp_adjust - shift;
								 	 			
								 				end

		24'b0000_01xx_xxxx_xxxx_xxxx_xxxx : 	begin						
									 				Temp_Mantissa = Temp_Mantissa << 5;
								 	 				shift = 5'd5;
								 	 				exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_001x_xxxx_xxxx_xxxx_xxxx : 	begin						// 24'h020000
									 				Temp_Mantissa = Temp_Mantissa << 6;
								 	 				shift = 5'd6;
								 	 				exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0001_xxxx_xxxx_xxxx_xxxx : 	begin						// 24'h010000
									 				Temp_Mantissa = Temp_Mantissa << 7;
								 	 				shift = 5'd7;
								 	 				exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_1xxx_xxxx_xxxx_xxxx : 	begin						// 24'h008000
									 				Temp_Mantissa= Temp_Mantissa << 8;
								 	 				shift = 5'd8;
								 	 				exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_01xx_xxxx_xxxx_xxxx : 	begin						// 24'h004000
									 				Temp_Mantissa = Temp_Mantissa << 9;
								 	 				shift = 5'd9;
								 	 				exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_001x_xxxx_xxxx_xxxx : 	begin						// 24'h002000
									 				Temp_Mantissa= Temp_Mantissa << 10;
								 	 				shift = 5'd10;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0001_xxxx_xxxx_xxxx : 	begin						// 24'h001000
									 				Temp_Mantissa = Temp_Mantissa << 11;
								 	 				shift = 5'd11;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_1xxx_xxxx_xxxx : 	begin						// 24'h000800
									 				Temp_Mantissa = Temp_Mantissa << 12;
								 	 				shift = 5'd12;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_01xx_xxxx_xxxx : 	begin						// 24'h000400
									 				Temp_Mantissa = Temp_Mantissa << 13;
								 	 				shift = 5'd13;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_001x_xxxx_xxxx : 	begin						// 24'h000200
									 				Temp_Mantissa = Temp_Mantissa << 14;
								 	 				shift = 5'd14;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_0001_xxxx_xxxx  : 	begin						// 24'h000100
									 				Temp_Mantissa = Temp_Mantissa << 15;
								 	 				shift = 5'd15;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_0000_1xxx_xxxx : 	begin						// 24'h000080
									 				Temp_Mantissa = Temp_Mantissa << 16;
								 	 				shift = 5'd16;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_0000_01xx_xxxx : 	begin						// 24'h000040
											 		Temp_Mantissa = Temp_Mantissa << 17;
										 	 		shift = 5'd17;
										 	 		 exp_adjust = exp_adjust - shift;
												end

		24'b0000_0000_0000_0000_001x_xxxx : 	begin						// 24'h000020
									 				Temp_Mantissa = Temp_Mantissa << 18;
								 	 				shift = 5'd18;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_0000_0001_xxxx : 	begin						// 24'h000010
									 				Temp_Mantissa = Temp_Mantissa << 19;
								 	 				shift = 5'd19;
								 	 				 exp_adjust = exp_adjust - shift;
												end

		24'b0000_0000_0000_0000_0000_1xxx :	begin						// 24'h000008
									 				Temp_Mantissa = Temp_Mantissa << 20;
								 					shift = 5'd20;
								 					 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_0000_0000_01xx : 	begin						// 24'h000004
									 				Temp_Mantissa = Temp_Mantissa << 21;
								 	 				shift = 5'd21;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_0000_0000_001x : 	begin						// 24'h000002
									 				Temp_Mantissa = Temp_Mantissa << 22;
								 	 				shift = 5'd22;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end

		24'b0000_0000_0000_0000_0000_0001 : 	begin						// 24'h000001
									 				Temp_Mantissa = Temp_Mantissa << 23;
								 	 				shift = 5'd23;
								 	 				 exp_adjust = exp_adjust - shift;
								 				end
//        24'b0000_0000_0000_0000_0000_0000 : 	begin						// 24'h000001
//									 				//Temp_Mantissa_shift = Temp_Mantissa << 23;
//								 	 				shift = 5'd24;
//								 				end
		default : 	begin
						//Temp_Mantissa_shift = Temp_Mantissa;
						shift = 5'd24;
						exp_adjust = exp_adjust - shift;
					end
    endcase  
//    exp_adjust = exp_adjust - shift;
//    Temp_Mantissa = Temp_Mantissa << shift;
    end

Sign = A_sign;
Mantissa = Temp_Mantissa[22:0];
Exponent = exp_adjust;
result = {Sign,Exponent,Mantissa};
//Temp_Mantissa = (A_sign ~^ B_sign) ? (carry ? Temp_Mantissa>>1 : Temp_Mantissa) : (0); 
//Temp_Exponent = carry ? A_Exponent + 1'b1 : A_Exponent; 
//Temp_sign = A_sign;
//result = {Temp_sign,Temp_Exponent,Temp_Mantissa[22:0]};
end
endmodule