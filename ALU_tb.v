// Miguel Alonso De La Rosa Zamora A01646106
// En este testbench probamos el modulo de numPrim. 
module ALU_tb();

	reg [31:0] A, B;
	reg [2:0] Control;
	wire [31:0] Result;
	wire Zero;
	
	ALU dut(.A(A), .B(B), .Control(Control), .Result(Result), .Zero(Zero));
	initial
		begin
		$display("Simulacion iniciada");
		repeat(80)
		begin 
			A = $random %100;
			B = $random %100;
			Control = $random %6;
			#10;
		end
		$display("Simulacion finalizada");
		$stop;
		$finish;
		end
	
		initial
			begin
				$monitor("A = %b, B = %b, Control = %b, Result = %b, Zero = %b", A, B, Control, Result, Zero);
			end
		initial
			begin
				$dumpfile("ALU_tb.vcd");
				$dumpvars(0, ALU_tb);
			end
endmodule