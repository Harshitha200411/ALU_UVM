class alu_pas_monitor extends uvm_monitor;
`uvm_component_utils(alu_pas_monitor)
alu_seq_item m_item;
uvm_analysis_port #(alu_seq_item) pas_mon_port;
virtual alu_if.PAS_MON vif;
alu_cfg otm_cfg;

function new (string name = "alu_pas_monitor", uvm_component parent);
	super.new (name, parent);
endfunction

function void build_phase (uvm_phase phase);
	super.build_phase (phase);
	if (!uvm_config_db #(alu_cfg)::get(this, "", "alu_cfg", otm_cfg))
		`uvm_fatal (get_type_name(), "Output monitor failed");
	pas_mon_port = new ("outm_port", this);
endfunction

function void connect_phase (uvm_phase phase);
	super.connect_phase (phase);
	vif = otm_cfg.vif;
endfunction

task run_phase (uvm_phase phase);
//@ (vif.pas_mon_cb);
	forever begin
		collect_output_data();
		//`uvm_info ("PAS_MON","Passive monitor is activating",UVM_NONE);
	end
endtask

task collect_output_data();
	begin
		m_item = alu_seq_item::type_id::create ("m_item");
		@ (vif.pas_mon_cb);
		m_item.res = vif.pas_mon_cb.res;
		m_item.cout = vif.pas_mon_cb.cout;
		m_item.oflow = vif.pas_mon_cb.oflow;
		m_item.g = vif.pas_mon_cb.g;	
		m_item.e = vif.pas_mon_cb.e;
		m_item.l = vif.pas_mon_cb.l;
		m_item.err = vif.pas_mon_cb.err;
		`uvm_info("ALU_PASS_MON", $sformatf ("res =  %d cout = %d oflow = %d g = %d e = %d l = %d err = %d",m_item.res, m_item.cout, m_item.oflow, m_item.g, m_item.e, m_item.l, m_item.err), UVM_NONE)
		pas_mon_port.write(m_item);
	end
endtask
endclass	 
