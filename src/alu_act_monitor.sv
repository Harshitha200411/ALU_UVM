class alu_act_monitor extends uvm_monitor;
`uvm_component_utils (alu_act_monitor)
uvm_analysis_port #(alu_seq_item) act_mon_port;
alu_cfg ipm_cfg;
virtual alu_if.ACT_MON vif;
alu_seq_item a_item;

function new (string name = "alu_act_monitor", uvm_component parent);
	super.new (name, parent);
endfunction

function void build_phase (uvm_phase phase);
	super.build_phase (phase);
	if (!uvm_config_db #(alu_cfg)::get(this, "", "alu_cfg", ipm_cfg))
		`uvm_fatal (get_type_name(), "Input Monitor Failed");
	act_mon_port = new ("act_mon_port", this);
endfunction

function void connect_phase (uvm_phase phase);
	super.connect_phase (phase);
	vif = ipm_cfg.vif;
endfunction

task run_phase (uvm_phase phase);
//@ (vif.act_mon_cb);
	forever begin
		//`uvm_info ("ACT_MON","Active monitor is activating",UVM_NONE)
		collect_data();
	end
endtask

task collect_data();
	begin
		a_item = alu_seq_item::type_id::create ("a_item");
		@ (vif.act_mon_cb);
		a_item.ce = vif.act_mon_cb.ce;
		a_item.inp_valid = vif.act_mon_cb.inp_valid;
		a_item.opa = vif.act_mon_cb.opa;
		a_item.opb = vif.act_mon_cb.opb;
		a_item.cin = vif.act_mon_cb.cin;
		a_item.mode = vif.act_mon_cb.mode;
		a_item.cmd = vif.act_mon_cb.cmd;
		`uvm_info("ALU_ACT_MON", $sformatf ("ce = %d opa =  %d opb = %d mode = %d cin = %d cmd = %d inp_valid = %d",a_item.ce, a_item.opa, a_item.opb, a_item.mode, a_item.cin, a_item.cmd, a_item.inp_valid), UVM_NONE)
		act_mon_port.write (a_item);
	end
endtask
endclass
