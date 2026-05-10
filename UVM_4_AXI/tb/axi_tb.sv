class axi_tb extends uvm_env;

`uvm_component_utils(axi_tb)

master_agent_top magt_top;
slave_agent_top sagt_top;

axi_virtual_sequencer v_sequencer;

// declare scoreboard 

axi_env_config a_cfg;

extern function new(string name="axi_tb",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass

function axi_tb::new(string name="axi_tb",uvm_component parent);
  super.new(name,parent);
endfunction

function void axi_tb::build_phase(uvm_phase phase);
  if(!uvm_config_db #(axi_env_config)::get(this,"","axi_env_config",a_cfg))
     `uvm_fatal("AXI_TB","cannot get() have u set() it?")

 if(a_cfg.has_magent) 
  begin
     magt_top=master_agent_top::type_id::create("magt_top",this);
    uvm_config_db #(master_agt_config)::set(this,"magt_top*","master_agt_config",a_cfg.m_agent_cfg);
   
  end

 if(a_cfg.has_sagent)
   begin 
    uvm_config_db #(slave_agt_config)::set(this,"sagt_top*","slave_agt_config",a_cfg.s_agent_cfg);
   sagt_top=slave_agent_top::type_id::create("sagt_top",this);
  end

 super.build_phase(phase);
 
 if(a_cfg.has_virtual_sequencer)
   v_sequencer=axi_virtual_sequencer::type_id::create("v_sequencer",this);
endfunction

function void axi_tb::connect_phase(uvm_phase phase);
 if(a_cfg.has_virtual_sequencer)
  begin
   if(a_cfg.has_magent)
     v_sequencer.m_seqrh=magt_top.agnth.m_seqrh;
   if(a_cfg.has_sagent)
     v_sequencer.s_seqrh=sagt_top.agnth.s_seqrh;
  end
 
  // scoreboard connection
  

endfunction

