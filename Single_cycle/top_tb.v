// Miguel Alonso De La Rosa Zamora A01646106
module top_tb();

reg clk, rst;
top dut ( .clk(clk), .rst(rst));
always #5 clk = ~clk; 
initial begin
    clk = 0;
    rst  = 1;
    #10;
    rst  = 0;
    #100;
    $finish;
end

initial begin
    $dumpfile("single_cycle.vcd");
    $dumpvars(0, top_tb);
end

initial begin
    $display("clk | rst | PC | Instr | ALUResult | WD3 | RegWrite | MemWrite | PCSrc");
    $monitor("%b | %b | %h | %h | %h | %h | %b | %b | %b", clk, rst, dut.PC, dut.Instr, dut.ALUResult, dut.WD3, dut.RegWrite, dut.MemWrite, dut.PCSrc);
end
