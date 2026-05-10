class master_seq extends uvm_sequence#(signal_xtn);

 `uvm_object_utils(master_seq)

 function new(string name="master_seq");
    super.new(name);
 endfunction
endclass


class master_test_xtns extends master_seq;
  
  `uvm_object_utils(master_test_xtns)
extern function new(string name="master_test_xtns");
extern task body();
endclass

function master_test_xtns::new(string name="master_test_xtns");
 super.new(name);
endfunction

task master_test_xtns::body();
repeat(4)
begin
 req=signal_xtn::type_id::create("req");
 start_item(req);
 assert(req.randomize()); 
  `uvm_info("MASTER_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
 finish_item(req);
end
endtask

class master_test_aligned_xtns extends master_seq;
  
  `uvm_object_utils(master_test_aligned_xtns)
extern function new(string name="master_test_aligned_xtns");
extern task body();
endclass

function master_test_aligned_xtns::new(string name="master_test_aligned_xtns");
 super.new(name);
endfunction

task master_test_aligned_xtns::body();
repeat(1)
begin
 req=signal_xtn::type_id::create("req");
 start_item(req);
 assert(req.randomize()with {awaddr[1:0]==2'b00; awburst==2'b01;}); 
  `uvm_info("MASTER_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
 finish_item(req);
end
endtask

class master_test_unaligned_xtns extends master_seq;
  
  `uvm_object_utils(master_test_unaligned_xtns)
extern function new(string name="master_test_unaligned_xtns");
extern task body();
endclass

function master_test_unaligned_xtns::new(string name="master_test_unaligned_xtns");
 super.new(name);
endfunction

task master_test_unaligned_xtns::body();
repeat(1)
begin
 req=signal_xtn::type_id::create("req");
 start_item(req);
 assert(req.randomize()with {awaddr[1:0]==2'b01; awburst==2'b01;}); 
  `uvm_info("MASTER_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
 finish_item(req);
end
endtask


class master_test_narrow_xtns extends master_seq;
  
  `uvm_object_utils(master_test_narrow_xtns)
extern function new(string name="master_test_narrow_xtns");
extern task body();
endclass

function master_test_narrow_xtns::new(string name="master_test_narrow_xtns");
 super.new(name);
endfunction

task master_test_narrow_xtns::body();
repeat(1)
begin
 req=signal_xtn::type_id::create("req");
 start_item(req);
 assert(req.randomize()with {awaddr[1:0]==2'b00; awsize==3'b000; awburst==2'b10;}); 
  `uvm_info("MASTER_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)
 finish_item(req);
end
endtask
 
