`include "define.sv"
class alu_seq_item extends uvm_sequence_item;
rand bit [`dw-1:0] opa;
rand bit [`dw-1:0] opb;
rand bit [`cw-1:0] cmd;
rand bit [1:0] inp_valid;
rand bit ce, mode, cin;
bit [`dw*2-1:0] res;
bit cout, oflow, g, e, l, err;

//constraint inp_valid_con { inp_valid == 3; }
//constraint arith_op_con { (mode == 1) -> (cmd <= 10); }
//constraint log_op_con { (mode == 0) -> (cmd <= 13); }
//constraint ce_con { ce == 1; }

`uvm_object_utils_begin (alu_seq_item)
	`uvm_field_int (opa, UVM_ALL_ON | UVM_DEC)
	`uvm_field_int (opb, UVM_ALL_ON | UVM_DEC)
	`uvm_field_int (cmd, UVM_ALL_ON | UVM_DEC) 
	`uvm_field_int (inp_valid, UVM_ALL_ON | UVM_DEC)
	`uvm_field_int (ce, UVM_ALL_ON | UVM_BIN)
	`uvm_field_int (mode, UVM_ALL_ON | UVM_BIN)
	`uvm_field_int (cin, UVM_ALL_ON | UVM_BIN)
	`uvm_field_int (res, UVM_ALL_ON | UVM_DEC)
	`uvm_field_int (cout, UVM_ALL_ON | UVM_BIN)
	`uvm_field_int (oflow, UVM_ALL_ON | UVM_BIN)
	`uvm_field_int (g, UVM_ALL_ON | UVM_BIN)
	`uvm_field_int (e, UVM_ALL_ON | UVM_BIN)
	`uvm_field_int (l, UVM_ALL_ON | UVM_BIN)
	`uvm_field_int (err, UVM_ALL_ON | UVM_BIN)
`uvm_object_utils_end

function new (string name = "alu_seq_item");
	super.new(name);
endfunction

endclass
