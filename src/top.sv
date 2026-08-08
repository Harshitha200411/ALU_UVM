`include "test_pkg.sv"
`include "alu_if.sv"
`include "alu_design.sv"
module top;
import uvm_pkg::*;
import test_pkg::*;
bit clk;
bit rst;
alu_if itf(clk,rst);
ALU_DESIGN duv (.OPA(itf.opa), .OPB(itf.opb), .CLK(itf.clk), .RST(itf.rst), .CE(itf.ce), .MODE(itf.mode), .CIN(itf.cin), .CMD(itf.cmd), .INP_VALID(itf.inp_valid), .RES(itf.res), 
.COUT(itf.cout), .L(itf.l), .E(itf.e), .G(itf.g), .OFLOW(itf.oflow), .ERR(itf.err));

initial begin
	uvm_config_db #(virtual alu_if)::set(null, "*", "alu_if", itf);
	run_test();
end

initial begin
	clk=1'b0;
	forever 
	#5 clk=~clk;
end

initial begin
    rst = 1;
    #10;
    rst = 0;
end
endmodule
