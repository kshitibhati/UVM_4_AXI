class slave_agt_config extends uvm_object;

 `uvm_object_utils(slave_agt_config)

virtual axi_if vif;

uvm_active_passive_enum is_active = UVM_ACTIVE;

function new(string name="slave_agt_config");
  super.new(name);
endfunction

endclass


  
