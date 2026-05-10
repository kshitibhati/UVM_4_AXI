class axi_base_test extends uvm_test;
 
`uvm_component_utils(axi_base_test)
 
 axi_tb axi_envh;
 axi_env_config a_cfg;
 master_agt_config m_cfg;
 slave_agt_config s_cfg;

int has_magent=1;
int has_sagent=1;

extern function new(string name="axi_base_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void config_axi();
endclass

function axi_base_test::new(string name="axi_base_test",uvm_component parent);
 super.new(name,parent);
endfunction 

function void axi_base_test::config_axi();
 if(has_magent) begin
  m_cfg=master_agt_config::type_id::create("m_cfg");
  if(!uvm_config_db #(virtual axi_if)::get(this,"","vif",m_cfg.vif))
    `uvm_fatal("VIF_CONFIG","connot get interface vif have u set it?")
  m_cfg.is_active=UVM_ACTIVE;
  a_cfg.m_agent_cfg=m_cfg;
 end
 
 if(has_sagent) begin
  s_cfg=slave_agt_config::type_id::create("s_cfg");
  if(!uvm_config_db #(virtual axi_if)::get(this,"","vif",s_cfg.vif))
   `uvm_fatal("VIF CONFIG","cannot get interface vif have u set it?")
  s_cfg.is_active=UVM_ACTIVE;
  a_cfg.s_agent_cfg=s_cfg;
 end

a_cfg.has_magent=has_magent;
a_cfg.has_sagent=has_sagent;
endfunction


function void axi_base_test::build_phase(uvm_phase phase);
  a_cfg=axi_env_config::type_id::create("a_cfg");
  
  config_axi;
  
  uvm_config_db #(axi_env_config)::set(this,"*","axi_env_config",a_cfg);
   
  super.build();

 axi_envh=axi_tb::type_id::create("axi_envh",this);
endfunction
 

class axi_test_multi extends axi_base_test;
 
 `uvm_component_utils(axi_test_multi)
 
axi_test_vseq axi_seqh;

extern function new(string name="axi_test_multi",uvm_component parent);
extern task run_phase(uvm_phase phase);
endclass

function axi_test_multi::new(string name="axi_test_multi",uvm_component parent);
 super.new(name,parent);
endfunction


task axi_test_multi::run_phase(uvm_phase phase);
 phase.raise_objection(this);
 
 axi_seqh=axi_test_vseq::type_id::create("axi_seqh");
 axi_seqh.start(axi_envh.v_sequencer);
 #1500;
 phase.drop_objection(this);
endtask
/////////////////////////////  aligned test  //////////////////////////
class axi_aligned_test extends axi_base_test;
 
 `uvm_component_utils(axi_aligned_test)
 
axi_aligned_test_vseq axi_seqh;

extern function new(string name="axi_aligned_test",uvm_component parent);
extern task run_phase(uvm_phase phase);
endclass

function axi_aligned_test::new(string name="axi_aligned_test",uvm_component parent);
 super.new(name,parent);
endfunction


task axi_aligned_test::run_phase(uvm_phase phase);
 phase.raise_objection(this);
 
 axi_seqh=axi_aligned_test_vseq::type_id::create("axi_seqh");
 axi_seqh.start(axi_envh.v_sequencer);
 #1000;
 phase.drop_objection(this);
endtask

///////////////////////  unaligend test ///////////////////////////////
class axi_test_unaligned extends axi_base_test;
 
 `uvm_component_utils(axi_test_unaligned)
 
axi_unaligned_test_vseq axi_seqh;

extern function new(string name="axi_test_unaligned",uvm_component parent);
extern task run_phase(uvm_phase phase);
endclass

function axi_test_unaligned::new(string name="axi_test_unaligned",uvm_component parent);
 super.new(name,parent);
endfunction


task axi_test_unaligned::run_phase(uvm_phase phase);
 phase.raise_objection(this);
 
 axi_seqh=axi_unaligned_test_vseq::type_id::create("axi_seqh");
 axi_seqh.start(axi_envh.v_sequencer);
 #1000;
 phase.drop_objection(this);
endtask

//////////////////// narrow test ///////////////////
class axi_test_narrow extends axi_base_test;
 
 `uvm_component_utils(axi_test_narrow)
 
axi_narrow_test_vseq axi_seqh;

extern function new(string name="axi_test_narrow",uvm_component parent);
extern task run_phase(uvm_phase phase);
endclass

function axi_test_narrow::new(string name="axi_test_narrow",uvm_component parent);
 super.new(name,parent);
endfunction


task axi_test_narrow::run_phase(uvm_phase phase);
 phase.raise_objection(this);
 
 axi_seqh=axi_narrow_test_vseq::type_id::create("axi_seqh");
 axi_seqh.start(axi_envh.v_sequencer);
 #1000;
 phase.drop_objection(this);
endtask


