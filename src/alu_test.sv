class alu_test extends uvm_test;
`uvm_component_utils(alu_test)
alu_env env;
alu_seq s1;
//alu_seq1 s2;
alu_cfg m_cfg;

function new (string name  = "alu_test", uvm_component parent);
	super.new (name, parent);
endfunction

virtual function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	m_cfg = alu_cfg::type_id::create("m_cfg");
	if(!uvm_config_db #(virtual alu_if) :: get(this, "", "alu_if",m_cfg.vif))
		`uvm_fatal(get_type_name,"Can't get the interface")
	uvm_config_db #(alu_cfg)::set(this, "*", "alu_cfg",m_cfg);
	env = alu_env::type_id::create ("env",this);
endfunction

function void end_of_elaboration_phase(uvm_phase phase);
  super.end_of_elaboration_phase(phase);
   uvm_top.print_topology();
endfunction

task run_phase (uvm_phase phase);
	phase.raise_objection(this);
	s1 = alu_seq::type_id::create("s1");
	s1.start(env.act_ag.seqr);
	//s2 = alu_seq1::type_id::create("s2");
	//s2.start(env.act_ag.seqr);
	#40;
	phase.drop_objection(this);
endtask
endclass
