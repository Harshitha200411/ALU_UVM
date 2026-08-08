class base_test extends uvm_test;
`uvm_component_utils(base_test)
alu_env env;
arthematic_seq s1;
logical_seq s2;
alu_cfg m_cfg;
function new (string name  = "base_test", uvm_component parent);
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
	s1 = arthematic_seq::type_id::create("s1");
	s1.start(env.act_ag.seqr);
	s2 = logical_seq::type_id::create("s2");
	s2.start(env.act_ag.seqr);
	#40;
	phase.drop_objection(this);
endtask
endclass

class wait_cycle_test extends uvm_test;
`uvm_component_utils(wait_cycle_test)
alu_env env;
opeartion_with_wait_seq s1;
alu_cfg m_cfg;
function new (string name  = "wait_cycle_test", uvm_component parent);
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
	s1 = opeartion_with_wait_seq::type_id::create("s1");
	s1.start(env.act_ag.seqr);
	#40;
	phase.drop_objection(this);
endtask
endclass

class multiply_test extends uvm_test;
`uvm_component_utils(multiply_test)
alu_env env;
multipy_seq s1;
alu_cfg m_cfg;
function new (string name  = "multiply_test", uvm_component parent);
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
	s1 = multipy_seq::type_id::create("s1");
	s1.start(env.act_ag.seqr);
	#40;
	phase.drop_objection(this);
endtask
endclass

class cmd_invalid_test extends uvm_test;
`uvm_component_utils(cmd_invalid_test)
alu_env env;
invalid_cmd_seq s1;
alu_cfg m_cfg;
function new (string name  = "cmd_invalid_test", uvm_component parent);
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
	s1 = invalid_cmd_seq::type_id::create("s1");
	s1.start(env.act_ag.seqr);
	#40;
	phase.drop_objection(this);
endtask
endclass
