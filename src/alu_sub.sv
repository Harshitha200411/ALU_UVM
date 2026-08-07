class alu_sub extends uvm_subscriber #(alu_seq_item);
`uvm_component_utils(alu_sub)
alu_seq_item si;
 covergroup alu_cg;
 	mode_cp: coverpoint si.mode {
 		bins logical={0};
 		bins arith={1}; }
   cmd_cp : coverpoint si.cmd { bins cmd_val[]={[0:13]}; }
 	inp_valid_cp : coverpoint si.inp_valid{
 		bins a_valid ={2'b01};
 		bins b_valid={2'b10};
 		bins a_b_valid={2'b11};
 		bins clear = {2'b00}; }
 	ce_cp : coverpoint si.ce {
 		bins low ={0};
 		bins high ={1};}
 	cin_cp : coverpoint si.cin {
 		bins low ={0};
 		bins high ={1};}
 	opa_cp : coverpoint si.opa {
 		bins max={[0:256]};
 		bins others=default; }
 	opb_cp : coverpoint si.opb {
 		bins max={[0:256]};
 		bins others=default; }
 	/*err_cp : coverpoint si.err {
 		bins low={0};
 		bins high={0};}
 	cout_cp : coverpoint si.cout {
 		bins low={0};
 		bins high={1};}
 	oflow_cp:coverpoint si.oflow {
 		bins low ={0};
 		bins high={1};}
 	g_cp:coverpoint si.g;
 	l_cp : coverpoint si.l;
 	e_cp : coverpoint si.e;*/
 endgroup
  function new(string name = "alu_sub",uvm_component parent); 		
  	super.new(name,parent);
      	alu_cg=new();
 endfunction
 virtual function void write (alu_seq_item t);
 	si=t;
   	alu_cg.sample();
endfunction
 endclass
