class alu_scoreboard extends uvm_scoreboard;
`uvm_component_utils (alu_scoreboard)
uvm_tlm_analysis_fifo #(alu_seq_item) alu_ip_mon_fifo;
uvm_tlm_analysis_fifo #(alu_seq_item) alu_ot_mon_fifo;
alu_seq_item ip_mon;
alu_seq_item ot_mon;
alu_seq_item ex_mon, delay1, delay2;
alu_seq_item delay_q;
virtual alu_if vif;
bit flag = 0;

bit va, vb;
bit [`dw-1:0] opa1,opb1;
bit [`cw-1:0] cmd1;
bit mode1;
int cnt;
	
function new (string name = "alu_scoreboard", uvm_component parent);
	super.new (name, parent);
	alu_ip_mon_fifo = new ("alu_ip_mon_fifo", this);
	alu_ot_mon_fifo = new ("alu_ot_mon_fifo", this);
endfunction

virtual function void build_phase (uvm_phase phase);
	super.build_phase (phase);
	if(!uvm_config_db #(virtual alu_if)::get(this,"","alu_if",vif))
        	`uvm_fatal("SB","Cannot get interface")
	ip_mon = alu_seq_item::type_id::create("ip_mon");
	ot_mon = alu_seq_item::type_id::create("ot_mon");
	ex_mon = alu_seq_item::type_id::create("ex_mon");
	delay1 = alu_seq_item::type_id::create("delay1");
	delay2 = alu_seq_item::type_id::create("delay2");
endfunction

task run_phase (uvm_phase phase);
	forever
		begin
			alu_ip_mon_fifo.get (ip_mon);
			alu_ot_mon_fifo.get (ot_mon);
			
			ex_mon.copy(delay1);
			//delay2.copy(delay1);
			delay1.copy(ip_mon);
			
			ref_model (ex_mon);
			`uvm_info("REFRENCE MODEL", $sformatf ("res =  %d err = %d oflow = %d cout = %d l = %d e = %d g = %d",ex_mon.res, ex_mon.err, ex_mon.oflow, ex_mon.cout, ex_mon.l, ex_mon.e, ex_mon.g), UVM_NONE)
			`uvm_info("DUT", $sformatf ("res =  %d err = %d oflow = %d cout = %d l = %d e = %d g = %d",ot_mon.res, ot_mon.err, ot_mon.oflow, ot_mon.cout, ot_mon.l, ot_mon.e, ot_mon.g), UVM_NONE)
			//validate_output ();
			check_data (ot_mon);
			ex_mon = ip_mon;
		end
endtask

/*virtual task validate_output();
	if (ip_mon. compare (ot_mon))
	begin
		`uvm_info (get_type_name, $sformatf ("DATA MATCH"), UVM_NONE);
	end
	else
	begin
		`uvm_info (get_type_name, $sformatf ("DATA MISMATCH" ), UVM_NONE);
	end
	`uvm_info (get_type_name, $sformatf ("Expected data\n%s", ip_mon.sprint()), UVM_NONE);
	`uvm_info (get_type_name, $sformatf ("Actual data\n%s", ot_mon.sprint()), UVM_NONE);
endtask*/

task check_data (alu_seq_item ch);
	begin
	   if(ex_mon.res == ch.res)
		$display("\n RES IS  MATCHING");
	   else
		$display("\n RES IS NOT MATCHING");

           if(ex_mon.err == ch.err)
		$display("\n ERR IS MATCHING");
	   else
		$display("\n ERR IS NOT MATCHING");

 	   if(ex_mon.cout == ch.cout)
		$display("\n COUT IS MATCHING");
	   else
		$display("\n COUT IS NOT MATCHING");

	    if(ex_mon.oflow == ch.oflow)
		$display("\n OFLOW IS MATCHING");
	   else
		$display("\n OFLOW IS NOT MATCHING");

            if(ex_mon.g == ch.g)
		$display("\n Greater IS MATCHING");
	   else
		$display("\n Greater IS NOT MATCHING");

	   if(ex_mon.l == ch.l)
		$display("\n Lesser IS MATCHING");
	   else
		$display("\n Lesser IS NOT MATCHING");

            if(ex_mon.e == ch.e)
		$display("\n Equal IS MATCHING");
	   else
		$display("\n Equal IS NOT MATCHING");
	end
 endtask
	
	
virtual task ref_model (alu_seq_item t);
	if (vif.rst)
	begin 
		t.res = 0;
		t.err = 0;
		t.g = 0;
		t.l = 0;
		t.e = 0;
		t.oflow = 0;
		t.cout = 0;
		opa1 = 0;
		opb1 = 0;
		cmd1 = 0;
		mode1 = 0;
		t.cin = 0;
		cnt = 0;
		va = 0;
		vb = 0;
	end
	else if (t.ce)
	begin
		if (va | vb)
		begin
			if (cnt < 16) 
				cnt++;
			else 
			begin
				va = 0;
				vb = 0;
				cnt = 0;
				opa1 = 0;
				opb1 = 0;
			end
		end

		case (t.inp_valid)
			2'b01: begin
				if ((va || vb) && (cmd1 != t.cmd || mode1 != t.mode))
				begin
					va = 0;
					vb = 0;
					cnt = 0;
				end
				opa1 = t.opa;
				cmd1 = t.cmd;
				mode1 = t.mode;
				va = 1;
			end
			2'b10: begin
				if ((va || vb) && (cmd1 != t.cmd || mode1 != t.mode))
				begin
					va = 0;
					vb = 0;
					cnt = 0;
				end
				vb = 1;
				opb1 = t.opb;
				cmd1 = t.cmd;
				mode1 = t.mode;
			end
			2'b11: begin
				if ((va || vb) && (cmd1 != t.cmd || mode1 != t.mode))
				begin
					va = 0;
					vb = 0;
					cnt = 0;
				end
				opa1 = t.opa;
				opb1 = t.opb;
				cmd1 = t.cmd;
				mode1 = t.mode;
				va = 1;
				vb = 1;
			end
		endcase

			if ((mode1 == 1 && (cmd1 == 4 || cmd1 == 5)) || (mode1 == 0 && (cmd1 == 8 || cmd1 == 9 || cmd1 == 6)))
			begin
				if (va)
				begin
					result_data(opa1, opb1, cmd1, t.res, mode1, t.cin, t.cout, t.g, t.l, t.e, t.err, t.oflow);
				end
			end
			else if ((mode1 == 1 && (cmd1 == 6 || cmd1 == 7)) || (mode1 == 0 && (cmd1 == 7 || cmd1 == 10 || cmd1 == 11)))
			begin
				if (vb)
				begin
					result_data(opa1, opb1, cmd1, t.res, mode1, t.cin, t.cout, t.g, t.l, t.e, t.err, t.oflow);
				end
			end
			else
				if (va && vb)
				begin
					result_data(opa1, opb1, cmd1, t.res, mode1, t.cin, t.cout, t.g, t.l, t.e, t.err, t.oflow);
				end
	end
endtask

task result_data (    input bit [`dw-1:0] opa,input bit [`dw-1:0] opb,
    input bit [`cw-1:0] cmd,output bit [`dw:0] res,input bit mode,
    input bit cin, output bit cout,output bit g,output bit l,
    output bit e,output bit err,output bit oflow);
	bit [`dw-1:0] out1, out2;
	if (mode)
	begin
		case (cmd)
			4'b0000: begin
				res = opa + opb;
				cout = res[8] ? 1 : 0;
			end
			4'b0001: begin
				oflow = (opa < opb) ? 1 : 0;
				res = opa - opb;
			end
			4'b0010: begin
				res = opa + opb + cin;
				cout = res[8] ? 1 : 0;
			end
			4'b0011: begin
				oflow = (opa < opb) ? 1 : 0;
				res = opa - opb - cin;
			end
			4'b0100: res = opa + 1;
			4'b0101: res = opa - 1;
			4'b0110: res = opb + 1;
			4'b0111: res = opb - 1;
			4'b1000: begin
				if (opa == opb)
				begin
					e = 1;
					l = 0;
					g = 0;
				end
				else if (opa > opb)
				begin
					e = 0;
					l = 0;
					g = 1;
				end
				else
				begin
					e = 0;
					l = 1;
					g = 0;
				end
			end
			4'b1001: begin
				out1 = opa + 1;
				out2 = opb + 1;
				res = out1 * out2;
			end
			4'b1010: begin
				out1 = opa << 1;
				out2 = opb;
				res = out1 * out2;
			end
			default : begin
				res = 0;
				oflow = 0;
				err = 0;
				g = 0;
				l = 0;
				e = 0;
				cout = 0;
			end
		endcase
	end
	else
	begin
		case (cmd)
			4'b0000: res = {1'b0, opa & opb};
			4'b0001: res = {1'b0, ~(opa & opb)};
			4'b0010: res = {1'b0, opa | opb};
			4'b0011: res = {1'b0, ~(opa | opb)};
			4'b0100: res = {1'b0, opa ^ opb};
			4'b0101: res = {1'b0, ~(opa ^ opb)};
			4'b0110: res = {1'b0, ~opa};
			4'b0111: res = {1'b0, ~opb};
			4'b1000: res = {1'b0, opa >> 1};
			4'b1001: res = {1'b0, opa << 1};
			4'b1010: res = {1'b0, opb >> 1};
			4'b1011: res = {1'b0, opb << 1};
			4'b1100: begin
				err = |opb[7:4];
				if(!err)
					res = {1'b0, (opa << opb[2:0]) | (opa >> (`dw - opb[2:0]))};
				else
					res = {1'b0, opa};
			end
			4'b1101: begin
				err = |opb[7:4];
				if(!err)
					res = {1'b0, (opa >> opb[2:0]) | (opa << (`dw - opb[2:0]))};
				else
					res = {1'b0, opa};

			end
		endcase
	end
endtask
endclass 
