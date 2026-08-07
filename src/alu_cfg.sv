class alu_cfg extends uvm_object;
`uvm_object_utils (alu_cfg)
virtual alu_if vif;

function new (string name = "alu_cfg");
	super.new (name);
endfunction

endclass
