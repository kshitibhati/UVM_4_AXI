class slave_agent extends uvm_agent;
 
  `uvm_component_utils(slave_agent)

slave_agt_config m_cfg;

slave_monitor monh;
slave_driver drvh;
slave_sequencer s_seqrh;

extern function new(string name="slave_agent",uvm_component parent=null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass:slave_agent

function slave_agent::new(string name="slave_agent",uvm_component parent=null);
  super.new(name,parent);
endfunction

function void slave_agent::build_phase(uvm_phase phase);
 super.build_phase(phase);

 monh=slave_monitor::type_id::create("monh",this);

 if(!uvm_config_db #(slave_agt_config)::get(this,"","slave_agt_config",m_cfg))
	`uvm_fatal("SLAVE_AGT_CONFIG","cannot get() it have u set() it?")

 if(m_cfg.is_active==UVM_ACTIVE)
  begin 
    drvh=slave_driver::type_id::create("drvh",this);
    s_seqrh=slave_sequencer::type_id::create("s_seqrh",this);
  end

endfunction

function void slave_agent::connect_phase(uvm_phase phase);
  if(m_cfg.is_active==UVM_ACTIVE)
    drvh.seq_item_port.connect(s_seqrh.seq_item_export);

endfunction 
