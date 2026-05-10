class master_monitor extends uvm_monitor;

 `uvm_component_utils(master_monitor)

virtual axi_if.MMON_MP vif;

master_agt_config m_cfg;

/////////////  Analysis TLM port declare to connect monitor with scoreboard


extern function new(string name="master_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
 
endclass

function master_monitor::new(string name="master_monitor",uvm_component parent); super.new(name,parent);
 //create object for handle monitor_port using new
 
endfunction

function void master_monitor::build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(!uvm_config_db #(master_agt_config)::get(this,"","master_agt_config",m_cfg))
   `uvm_fatal("MASTER_MONITOR","Cannot get() have u set() it?")

endfunction

function void master_monitor::connect_phase(uvm_phase phase);
 vif=m_cfg.vif;
endfunction

task master_monitor::run_phase(uvm_phase phase);
// forever 
     collect_data();
 
endtask

task master_monitor::collect_data();
  
endtask


