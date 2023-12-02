`timescale 1ns / 1ps

module FloatingDivision#(parameter XLEN=32)
                        (input [XLEN-1:0]A,
                         input [XLEN-1:0]B,
                         input clk,
//                         output overflow,
//                         output underflow,
//                         output exception,
                         output [XLEN-1:0] result);
                         
reg [23:0] A_Mantissa,B_Mantissa;
reg [22:0] Mantissa;
wire [7:0] exp;
reg [23:0] Temp_Mantissa;
reg [7:0] A_Exponent,B_Exponent,Temp_Exponent,diff_Exponent;
wire [7:0] Exponent;
reg [7:0] A_adjust,B_adjust;
reg A_sign,B_sign,Sign;
reg [32:0] Temp;
wire [31:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10;
wire [31:0] temp11,temp12,temp13,temp14,temp15,temp16,temp17,temp18,temp19,temp20;
wire [31:0] temp21,temp22,temp23,temp24,temp25,temp26,temp27,temp28,temp29,temp30,debug;
wire [31:0] reciprocal;
wire [31:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15;
reg [6:0] exp_adjust;
reg [XLEN-1:0] B_scaled; 
reg en1,en2,en3,en4,en5;
reg dummy;
/*----Initial value----*/
FloatingMultiplication M1(.A({{1'b0,8'd126,B[22:0]}}),.B(32'h3ff0f0f1),.clk(clk),.result(temp1)); //verified
//assign debug = {1'b1,temp1[30:0]};
FloatingAddition A1(.A(32'h4034b4b5),.B({1'b1,temp1[30:0]}),.clk(clk),.result(x0));

/*----First Iteration----*/
FloatingMultiplication M2(.A({{1'b0,8'd126,B[22:0]}}),.B(x0),.clk(clk),.result(temp2));
FloatingAddition A2(.A(32'h40000000),.B({!temp2[31],temp2[30:0]}),.clk(clk),.result(temp3));
FloatingMultiplication M3(.A(x0),.B(temp3),.clk(clk),.result(x1));

/*----Second Iteration----*/
FloatingMultiplication M4(.A({1'b0,8'd126,B[22:0]}),.B(x1),.clk(clk),.result(temp4));
FloatingAddition A3(.A(32'h40000000),.B({!temp4[31],temp4[30:0]}),.clk(clk),.result(temp5));
FloatingMultiplication M5(.A(x1),.B(temp5),.clk(clk),.result(x2));

/*----Third Iteration----*/
FloatingMultiplication M6(.A({1'b0,8'd126,B[22:0]}),.B(x2),.clk(clk),.result(temp6));
FloatingAddition A4(.A(32'h40000000),.B({!temp6[31],temp6[30:0]}),.clk(clk),.result(temp7));
FloatingMultiplication M7(.A(x2),.B(temp7),.clk(clk),.result(x3));

/*----Fourth Iteration----*/
FloatingMultiplication M8(.A({1'b0,8'd126,B[22:0]}),.B(x3),.clk(clk),.result(temp8));
FloatingAddition A5(.A(32'h40000000),.B({!temp8[31],temp8[30:0]}),.clk(clk),.result(temp9));
FloatingMultiplication M9(.A(x3),.B(temp9),.clk(clk),.result(x4));

/*----Fifth Iteration----*/
FloatingMultiplication M10(.A({1'b0,8'd126,B[22:0]}),.B(x4),.clk(clk),.result(temp10));
FloatingAddition A6(.A(32'h40000000),.B({!temp10[31],temp10[30:0]}),.clk(clk),.result(temp11));
FloatingMultiplication M11(.A(x4),.B(temp11),.clk(clk),.result(x5));

/*----Sixth Iteration----*/
FloatingMultiplication M12(.A({1'b0,8'd126,B[22:0]}),.B(x5),.clk(clk),.result(temp12));
FloatingAddition A7(.A(32'h40000000),.B({!temp12[31],temp12[30:0]}),.clk(clk),.result(temp13));
FloatingMultiplication M13(.A(x5),.B(temp13),.clk(clk),.result(x6));

/*----Seventh Iteration----*/
FloatingMultiplication M14(.A({1'b0,8'd126,B[22:0]}),.B(x6),.clk(clk),.result(temp14));
FloatingAddition A8(.A(32'h40000000),.B({!temp14[31],temp14[30:0]}),.clk(clk),.result(temp15));
FloatingMultiplication M15(.A(x6),.B(temp15),.clk(clk),.result(x7));

/*----Eighth Iteration----*/
FloatingMultiplication M16(.A({1'b0,8'd126,B[22:0]}),.B(x7),.clk(clk),.result(temp16));
FloatingAddition A9(.A(32'h40000000),.B({!temp16[31],temp16[30:0]}),.clk(clk),.result(temp17));
FloatingMultiplication M17(.A(x7),.B(temp17),.clk(clk),.result(x8));

/*----Nineth Iteration----*/
FloatingMultiplication M18(.A({1'b0,8'd126,B[22:0]}),.B(x8),.clk(clk),.result(temp18));
FloatingAddition A10(.A(32'h40000000),.B({!temp18[31],temp18[30:0]}),.clk(clk),.result(temp19));
FloatingMultiplication M19(.A(x8),.B(temp19),.clk(clk),.result(x9));

/*----Tenth Iteration----*/
FloatingMultiplication M20(.A({1'b0,8'd126,B[22:0]}),.B(x9),.clk(clk),.result(temp20));
FloatingAddition A11(.A(32'h40000000),.B({!temp20[31],temp20[30:0]}),.clk(clk),.result(temp21));
FloatingMultiplication M21(.A(x9),.B(temp21),.clk(clk),.result(x10));

/*----Eleventh Iteration----*/
FloatingMultiplication M22(.A({1'b0,8'd126,B[22:0]}),.B(x10),.clk(clk),.result(temp22));
FloatingAddition A12(.A(32'h40000000),.B({!temp22[31],temp22[30:0]}),.clk(clk),.result(temp23));
FloatingMultiplication M23(.A(x10),.B(temp23),.clk(clk),.result(x11));

///*----Twelveth Iteration----*/
//FloatingMultiplication M24(.A({1'b0,8'd126,B[22:0]}),.B(x11),.clk(clk),.result(temp24));
//FloatingAddition A13(.A(32'h40000000),.B({!temp24[31],temp24[30:0]}),.result(temp25));
//FloatingMultiplication M25(.A(x11),.B(temp25),.clk(clk),.result(x12));

///*----Thirteenth Iteration----*/
//FloatingMultiplication M26(.A({1'b0,8'd126,B[22:0]}),.B(x12),.clk(clk),.result(temp26));
//FloatingAddition A14(.A(32'h40000000),.B({!temp26[31],temp26[30:0]}),.result(temp27));
//FloatingMultiplication M27(.A(x12),.B(temp27),.clk(clk),.result(x13));

///*----Fourteenth Iteration----*/
//FloatingMultiplication M28(.A({1'b0,8'd126,B[22:0]}),.B(x13),.clk(clk),.result(temp28));
//FloatingAddition A15(.A(32'h40000000),.B({!temp28[31],temp28[30:0]}),.result(temp29));
//FloatingMultiplication M29(.A(x13),.B(temp29),.clk(clk),.result(x14));

///*----Fifteenth Iteration----*/
//FloatingMultiplication M30(.A({1'b0,8'd126,B[22:0]}),.B(x14),.clk(clk),.result(temp30));
//FloatingAddition A16(.A(32'h40000000),.B({!temp30[31],temp30[30:0]}),.result(temp31));
//FloatingMultiplication M31(.A(x14),.B(temp31),.clk(clk),.result(x15));


/*----Reciprocal : 1/B----*/
assign Exponent = x11[30:23]+8'd126-B[30:23];
assign reciprocal = {B[31],Exponent,x11[22:0]};

/*----Multiplication A*1/B----*/
FloatingMultiplication M32(.A(A),.B(reciprocal),.clk(clk),.result(result));
endmodule
