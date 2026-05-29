module multiplexor(
	 input [31:0] in0,
	 input [31:0] in1,
	 input [31:0] in2,
	 input [1:0] selector,
	 output reg [31:0] out
);

	always @(*) begin
		case(selector)
			2'b00: out = in0;
			2'b01: out = in1;
			2'b10: out = in2;
			2'b11: out = 0;
		endcase
	end
	
endmodule