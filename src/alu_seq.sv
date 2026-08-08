class arthematic_seq extends uvm_sequence #(alu_seq_item);
`uvm_object_utils(arthematic_seq)
alu_seq_item req;
function new (string name = "arthematic_seq");
	super.new(name);
endfunction
task body();
	for (int c = 0; c <= 10; c++)
	begin
		req = alu_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { inp_valid == 2'b11; mode == 1; cmd == c; ce == 1; })
		finish_item(req);
	end
endtask
endclass

class logical_seq extends uvm_sequence #(alu_seq_item);
`uvm_object_utils(logical_seq)
alu_seq_item req;
function new (string name = "logical_seq");
	super.new(name);
endfunction
task body();
	for (int c = 0; c <= 13; c++)
	begin
		req = alu_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { inp_valid == 2'b11; mode == 0; cmd == c; ce == 1; })
		finish_item(req);
	end
endtask
endclass

class opeartion_with_wait_seq extends uvm_sequence #(alu_seq_item);
`uvm_object_utils(opeartion_with_wait_seq)
alu_seq_item req;
function new (string name = "opeartion_with_wait_seq");
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
begin
	send_item (2'b01, 1, 1);
	idle (1, 1, 2);
	send_item (2'b10, 1, 1);
	idle (1, 1, 2);
	send_item (2'b01, 0, 0);
	idle (0, 0, 2);
	send_item (2'b10, 0, 0);
	idle (0, 0, 2);
	send_item (2'b01, 1, 0);
	idle (0, 0, 16);
	send_item (2'b10, 1, 0);
end
endtask
endclass

class multipy_seq extends uvm_sequence #(alu_seq_item);
`uvm_object_utils(multipy_seq)
alu_seq_item req;
function new (string name = "multiply_seq");
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
begin
	send_item (2'b01, 1, 9);
	idle (1, 9, 2);
	send_item (2'b10, 1, 9);
	idle (1, 9, 4);
	send_item (2'b01, 1, 10);
	idle (1, 9, 2);
	send_item (2'b10, 1, 10);
	idle (1, 9, 4);
end
endtask
endclass

class invalid_cmd_seq extends uvm_sequence #(alu_seq_item);
`uvm_object_utils(invalid_cmd_seq)
alu_seq_item req;
function new (string name = "invalid_cmd_seq");
	super.new(name);
endfunction
task body();
	repeat (3)
	begin
		req = alu_seq_item::type_id::create("req");
		start_item(req);
		assert(req.randomize() with { inp_valid == 2'b00; cmd == 14; ce == 1; mode dist {0:=50, 1:=50};})
		finish_item(req);
	end
endtask
endclass
