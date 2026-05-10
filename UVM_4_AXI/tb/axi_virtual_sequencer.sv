class axi_virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
 `uvm_component_utils(axi_virtual_sequencer)

 master_sequencer m_seqrh;
 slave_sequencer s_seqrh;
 
 axi_env_config a_cfg;

extern function new(string name="axi_virtual_sequencer",uvm_component parent);
extern function void build();
endclass 

function axi_virtual_sequencer::new(string name="axi_virtual_sequencer",uvm_component parent);
 super.new(name,parent);
endfunction

function void axi_virtual_sequencer::build();
 super.build();
endfunction
