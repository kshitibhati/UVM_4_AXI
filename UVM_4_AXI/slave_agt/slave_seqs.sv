class slave_seq extends uvm_sequence #(signal_xtn);

 `uvm_object_utils(slave_seq)

 function new(string name="slave_seq");
    super.new(name);
 endfunction
endclass


class slave_test_xtns extends slave_seq;
  
  `uvm_object_utils(slave_test_xtns)
extern function new(string name="slave_test_xtns");
extern task body();
endclass

function slave_test_xtns::new(string name="slave_test_xtns");
 super.new(name);
endfunction

task slave_test_xtns::body();
repeat(4)
begin
$display("-------------Master_sequence---------------");
 req=signal_xtn::type_id::create("req");
 start_item(req);
 //assert(req.randomize());
 //`uvm_info("MASTER_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
 finish_item(req);
end
endtask


class slave_simple_test_xtns extends slave_seq;
  
  `uvm_object_utils(slave_simple_test_xtns)
extern function new(string name="slave_simple_test_xtns");
extern task body();
endclass

function slave_simple_test_xtns::new(string name="slave_simple_test_xtns");
 super.new(name);
endfunction

task slave_simple_test_xtns::body();
repeat(1)
begin
$display("-------------Master_sequence---------------");
 req=signal_xtn::type_id::create("req");
 start_item(req);
 //assert(req.randomize());
  //`uvm_info("MASTER_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
 finish_item(req);
end
endtask



