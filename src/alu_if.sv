`include "define.sv"
interface alu_if (input bit clk,rst);
logic [`dw-1:0] opa;
logic [`dw-1:0] opb;
logic [`cw-1:0] cmd;
logic [1:0] inp_valid;
logic [`dw:0] res;
logic ce, mode, cin, cout, oflow, g, e, l, err;

clocking act_drv_cb @ (posedge clk);
	default input #0 output #0;
	output opa, opb;
	output ce, mode, cin;
	output cmd;
	output inp_valid;
endclocking

clocking act_mon_cb @ (posedge clk);
	default input #0 output #0;
	input opa, opb;
	input ce, mode, cin;
	input cmd;
	input inp_valid;
endclocking

clocking pas_mon_cb @ (posedge clk);
	default input #0 output #0;
	input res;
	input cout, oflow, g, e, l, err;
endclocking

modport ACT_DRV (clocking act_drv_cb);
modport ACT_MON (clocking act_mon_cb);
modport PAS_MON (clocking pas_mon_cb);

endinterface
