`timescale 1ns / 1ps

module Testbench_division;

  parameter XLEN = 32;
  parameter NUM_TESTS = 100;

  reg [XLEN-1:0] A, B,result_neg,result_A,result_B;
  reg clk;
  wire [XLEN-1:0] result,tolerance;
  
  reg [XLEN-1:0] mem_A[NUM_TESTS:1];
  reg [XLEN-1:0] mem_B[NUM_TESTS:1];
  reg [XLEN-1:0] mem_expected_result[NUM_TESTS:1];
  reg [XLEN-1:0] exp_res;
  integer i, dec;
  //count=1;
  
  // Instantiate the FloatingDivision module
  FloatingDivision#(XLEN) UUT(
    .A(A),
    .B(B),
    .clk(clk),
    .result(result)
    );
    
//  FloatingAddition#(XLEN) DUT(
//    .A({1'b1,result[30:0]}),
//    .B(mem_expected_result[i]),
//    .clk(clk),
//    .result(tolerance)
//    );
    
//  result_neg == ~result;
  FloatingAddition#(XLEN) DUT(
    //.A({32'b1,result[30:0]}),
    .A(result_A),
    .B(result_B),   
    .clk(clk),
    .result(tolerance)
    );
    

always @* begin
if (result >= exp_res) begin
result_A = result_neg;
result_B = exp_res;
  end
else begin
result_A = exp_res;
result_B = result_neg;
end
end


  always @* begin
    if (result[31])
    result_neg = {1'b0, result[30:0]}; // Compute the value of result_neg
    else
    result_neg = {1'b1, result[30:0]};
  end
  
    // Clock generation
  always #10 clk = ~clk;
  initial begin

    // Initialize clock
    clk = 1;

    // Load test vectors
    $readmemh("C:/Users/Shivam Shaw/Documents/matlab/A_ieee754.txt", mem_A, 1);
    $readmemh("C:/Users/Shivam Shaw/Documents/matlab/B_ieee754.txt", mem_B, 1);
    $readmemh("C:/Users/Shivam Shaw/Documents/matlab/result_ieee754.txt", mem_expected_result, 1);

    // Loop through test cases
    i = 1;
    while (i <= NUM_TESTS) begin
      // Apply test vectors
      A = mem_A[i]; // Load A from memory
      B = mem_B[i]; // Load B from memory
      
      exp_res= mem_expected_result[i];

      // Wait for posedge of clock
      //repeat (1) @(posedge clk);
      @(posedge clk);

      // Display results for each test case
      $display("Test Case %0d:", i);
      $display("A = %h, B = %h", A, B);
      $display(" Expected: %h, Got: %h", mem_expected_result[i], result);
      
      
      // Check result against expected values
     // if (result !== mem_expected_result[i])
      if (tolerance <= 32'hb727c5ac) begin
        $display("Test Passed!");      
        assign  dec = 1'd1;
        end
        else if (tolerance == 32'h00000000) begin //zero
        $display("Test Passed!");      
        assign  dec = 1'd1;
      end 
      else begin
        $display("Test Failed! Expected: %h, Got: %h", mem_expected_result[i], result);
        assign dec = 1'd0;
      end
      

      // Display the value of dec for each test case
      $display("dec = %d", dec);
      $display("tolerance = %h", tolerance);
      $display("result_neg = %h",result_neg);
      

      i = i + 1; // Increment the loop counter
    end

    // Stop simulation
    $stop;
  end

endmodule
