class alu_pas_agent extends uvm_agent;
`uvm_component_utils (alu_pas_agent)
alu_pas_monitor ps_mon;

function new (string name = "alu_pas_agent", uvm_component parent);
	super.new (name, parent);
endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ps_mon = alu_pas_monitor::type_id::create("ps_mon", this);
    `uvm_info (get_name(), "Passive agent created", UVM_LOW);
  endfunction

function void connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction

endclass
