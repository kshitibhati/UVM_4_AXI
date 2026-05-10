class axi_env_config extends uvm_object;

`uvm_object_utils(axi_env_config)

bit has_scoreboard=0;

bit has_magent=1;
bit has_sagent=1;

bit has_virtual_sequencer=1;

master_agt_config m_agent_cfg;
slave_agt_config s_agent_cfg;

extern function new(string name="axi_env_config");
endclass 

function axi_env_config::new(string name="axi_env_config");
   super.new(name);
endfunction

