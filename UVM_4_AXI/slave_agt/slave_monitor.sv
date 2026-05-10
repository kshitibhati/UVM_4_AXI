class slave_monitor extends uvm_monitor;

 `uvm_component_utils(slave_monitor)

virtual axi_if.SMON_MP vif;

slave_agt_config m_cfg;

/////////////  Analysis TLM port declare to connect monitor with scoreboard


extern function new(string name="slave_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
 
endclass

function slave_monitor::new(string name="slave_monitor",uvm_component parent); super.new(name,parent);
 //create object for handle monitor_port using new
 
endfunction

function void slave_monitor::build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(!uvm_config_db #(slave_agt_config)::get(this,"","slave_agt_config",m_cfg))
   `uvm_fatal("SLAVE_MONITOR","Cannot get() have u set() it?")

endfunction

function void slave_monitor::connect_phase(uvm_phase phase);
 vif=m_cfg.vif;
endfunction

task slave_monitor::run_phase(uvm_phase phase);
 //forever 
     collect_data();
endtask

task slave_monitor::collect_data();
 
endtask


