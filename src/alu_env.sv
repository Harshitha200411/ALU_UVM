class alu_env extends uvm_env;
`uvm_component_utils (alu_env)
alu_act_agent act_ag;
alu_pas_agent pas_ag;
alu_scoreboard scr;
alu_sub sub;

function new (string name = "alu_env", uvm_component parent);
	super.new (name, parent);
endfunction

function void build_phase (uvm_phase phase);
	super.build_phase (phase);
	uvm_config_db #(uvm_active_passive_enum)::set(this, "pas_ag", "is_active", UVM_PASSIVE);
	act_ag = alu_act_agent::type_id::create("act_ag", this);
	pas_ag = alu_pas_agent::type_id::create("pas_ag", this);
	scr = alu_scoreboard::type_id::create("scr", this);
	sub = alu_sub::type_id::create("sub",this);
endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
	act_ag.ac_mon.act_mon_port.connect(scr.alu_ip_mon_fifo.analysis_export);
	pas_ag.ps_mon.pas_mon_port.connect(scr.alu_ot_mon_fifo.analysis_export);
	act_ag.ac_mon.act_mon_port.connect(sub.analysis_export);
endfunction
endclass
