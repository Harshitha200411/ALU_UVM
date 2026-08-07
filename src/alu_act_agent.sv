class alu_act_agent extends uvm_agent;
`uvm_component_utils (alu_act_agent)
alu_driver drv;
alu_seqr seqr;
alu_act_monitor ac_mon;

function new (string name = "alu_act_agent", uvm_component parent);
	super.new (name, parent);
endfunction

virtual function void build_phase (uvm_phase phase);
	super.build_phase (phase);
	if (get_is_active() == UVM_ACTIVE) begin
		drv = alu_driver::type_id::create("drv", this);
		seqr = alu_seqr::type_id::create("seqr", this);
		`uvm_info (get_name(), "Active agent created", UVM_LOW);
	end
	ac_mon = alu_act_monitor::type_id::create("ac_mon", this);
endfunction

virtual function void connect_phase (uvm_phase phase);
	super.connect_phase (phase);
	if (get_is_active() == UVM_ACTIVE)
		drv.seq_item_port.connect(seqr.seq_item_export);
endfunction 
endclass
	
