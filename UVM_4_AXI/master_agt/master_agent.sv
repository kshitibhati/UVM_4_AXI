class master_agent extends uvm_agent;
 
  `uvm_component_utils(master_agent)

master_agt_config m_cfg;

master_monitor monh;
master_driver drvh;
master_sequencer m_seqrh;

extern function new(string name="master_agent",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass:master_agent

function master_agent::new(string name="master_agent",uvm_component parent=null);
  super.new(name,parent);
endfunction

function void master_agent::build_phase(uvm_phase phase);
 super.build_phase(phase);

 monh=master_monitor::type_id::create("monh",this);

 if(!uvm_config_db #(master_agt_config)::get(this,"","master_agt_config",m_cfg))
	`uvm_fatal("MASTER_AGT_CONFIG","cannot get() it have u set() it?")

 if(m_cfg.is_active==UVM_ACTIVE)
  begin 
    drvh=master_driver::type_id::create("drvh",this);
    m_seqrh=master_sequencer::type_id::create("m_seqrh",this);
  end

endfunction

function void master_agent::connect_phase(uvm_phase phase);
  if(m_cfg.is_active==UVM_ACTIVE)
    drvh.seq_item_port.connect(m_seqrh.seq_item_export);

endfunction 
