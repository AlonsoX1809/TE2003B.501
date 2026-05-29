module RegisterFile(
	input clk, 
	input rst,
	input [31:0] WD3,
	input WE3,
	input [4:0] A1,   
   input [4:0] A2,   
   input [4:0] A3,   
	output [31:0] RD1,
	output [31:0] RD2
);
	
	reg [31:0] registros [31:0];
	integer i;
	
	always @(posedge clk or posedge rst) begin
		if (rst) begin
			for(i = 0; i < 32; i = i + 1)
				registros[i] <= 32'b0;
      end
		else begin
			if (WE3)
				registros[A3] <= WD3;
		end
	end
	
	assign RD1 = registros[A1];
	assign RD2 = registros[A2];

endmodule
	