class alu_driver extends uvm_driver #(alu_seq_item);
`uvm_component_utils(alu_driver)
virtual alu_if.ACT_DRV drv_if;
alu_cfg d_cfg;

function new (string name = "alu_driver", uvm_component parent);
	super.new (name,parent);
endfunction

function void build_phase (uvm_phase phase);
	super.build_phase (phase);
	if (!uvm_config_db #(alu_cfg)::get(this, "", "alu_cfg", d_cfg))
		`uvm_fatal(get_type_name(),"Input driver getting failed")
endfunction

function void connect_phase (uvm_phase phase);
	super.connect_phase (phase);
	drv_if = d_cfg.vif;
endfunction

task run_phase (uvm_phase phase);
	begin
		forever 
		begin
			seq_item_port.get_next_item(req);
			//`uvm_info ("DRV","Received data",UVM_NONE);
			drive(req);
			seq_item_port.item_done();
		end
	end
endtask

task drive (alu_seq_item data2duv);
	@(drv_if.act_drv_cb);
	drv_if.act_drv_cb.opa <= data2duv.opa;
	drv_if.act_drv_cb.opb <= data2duv.opb;
	drv_if.act_drv_cb.ce <= data2duv.ce;
	drv_if.act_drv_cb.cin <= data2duv.cin;
	drv_if.act_drv_cb.cmd <= data2duv.cmd;
	drv_if.act_drv_cb.inp_valid <= data2duv.inp_valid;
	drv_if.act_drv_cb.mode <= data2duv.mode;
	`uvm_info("DRV", $sformatf ("ce = %d opa =  %d opb = %d mode = %d cin = %d cmd = %d inp_valid = %d",data2duv.ce, data2duv.opa, data2duv.opb, data2duv.mode, data2duv.cin, data2duv.cmd, data2duv.inp_valid), UVM_NONE)
endtask
endclass
	
