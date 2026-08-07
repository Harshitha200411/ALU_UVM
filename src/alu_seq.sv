class alu_seq extends uvm_sequence #(alu_seq_item);
`uvm_object_utils(alu_seq)
alu_seq_item req;
function new (string name = "alu_seq");
	super.new(name);
endfunction

task send_item (bit [1:0] valid, bit mode_i, bit [`cw-1:0] cmd_i);
	req = alu_seq_item::type_id::create("req");
	start_item(req);
	assert(req.randomize() with { inp_valid == valid; mode == mode_i; cmd == cmd_i; ce == 1; })
	finish_item(req);
endtask

task idle (bit mode_i, bit [`cw-1:0] cmd_i, int cycle);
	repeat (cycle) 
	begin
		req = alu_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { inp_valid == 2'b00; mode == mode_i; cmd == cmd_i; ce == 1; })
		finish_item(req);
	end
endtask

task body();
	for (int c = 0; c <= 8; c++)
	begin
		send_item (2'b11, 1, c);
		idle (1, c, 5);
		send_item (2'b10, 1, c);
	end
endtask
endclass

/*class alu_seq1 extends uvm_sequence #(alu_seq_item);
`uvm_object_utils(alu_seq1)
alu_seq_item req;
function new (string name = "alu_seq1");
	super.new(name);
endfunction
task body();
	repeat(50) begin
		req = alu_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {mode == 1'b0;})
		`uvm_info ("SEQ", "Randomized one time", UVM_NONE);
		finish_item(req);
	end
endtask
endclass*/
