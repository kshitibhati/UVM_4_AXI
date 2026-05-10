class master_driver extends uvm_driver #(signal_xtn);

`uvm_component_utils(master_driver)

virtual axi_if.MDR_MP vif;


master_agt_config m_cfg;


int j=0;



	static bit [3:0] awid_q[$];
	static bit [31:0]awaddr_q[$];
	static bit [7:0] awlen_q[$];
	static bit [2:0] awsize_q[$];
	static bit [1:0] awburst_q[$];
	
	static bit [31:0]wdata_q[$];
	static bit [3:0] wstrb_q[$];
	
	static bit [1:0]bresp_q[$];
	
	static bit [3:0] arid_q[$];
	static bit [31:0]araddr_q[$];
	static bit [7:0] arlen_q[$];
	static bit [2:0] arsize_q[$];
	static bit [1:0] arburst_q[$];
	
	static int index;
	static bit [7:0] length_q[$];
	       bit [7:0] length;
	
	semaphore sem0 = new(1);
	semaphore sem1 = new(1);
	semaphore sem2 = new(1);
	semaphore sem3 = new(1);
	semaphore sem4 = new(1);

extern function new(string name="master_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_slave();
extern task wr_addr_ch(int j);
extern task wr_data_ch(int j);
extern task wr_resp_ch(int j);
extern task rd_addr_ch(int j);
extern task rd_data_ch();
extern task store_to_queue(signal_xtn xtn);
extern task store_to_read(signal_xtn xtn);
endclass

function master_driver::new(string name="master_driver",uvm_component parent);
  super.new(name,parent);
endfunction

function void master_driver::build_phase(uvm_phase phase);
  super.build_phase(phase);
 if(!uvm_config_db #(master_agt_config)::get(this,"","master_agt_config",m_cfg))
   `uvm_fatal("MASTER_DRIVER","cannot get() it have u set() it?")
  

endfunction

function void master_driver::connect_phase(uvm_phase phase);
 vif=m_cfg.vif;
 
endfunction

task master_driver::run_phase(uvm_phase phase);
 
forever
begin
    seq_item_port.get_next_item(req);
    `uvm_info("MASTER_DRIVER",$sformatf("printing from driver \n %s", req.sprint()),UVM_LOW)
     store_to_queue(req);
     store_to_read(req);
     send_to_slave();
     seq_item_port.item_done();	
end
endtask

task master_driver::send_to_slave();

   fork 
     wr_addr_ch(j);
     wr_data_ch(j);
     wr_resp_ch(j);
     rd_addr_ch(j);
     rd_data_ch();
   join_none
   j++;
endtask

task master_driver::wr_addr_ch(int j);
$display($time,">>>>>>>>>>>>>>>>>MASTER DRIVER COME WR_ADDRESS_CHANNEL =%0d<<<<<<<<<<<<<<<<<<<<<<<<<<",j);
	@(vif.mdr_cb);
	sem0.get(1);
	if(!vif.mdr_cb.aresetn)
        begin
	  
          vif.mdr_cb.awvalid <= 0;
	  @(vif.mdr_cb);
        end
        
     // wait(vif.mdr_cb.aresetn);
	if(awid_q.size != 0)
	begin
		vif.mdr_cb.awid    <= awid_q.pop_front();
		vif.mdr_cb.awaddr  <= awaddr_q.pop_front();
		vif.mdr_cb.awlen   <= awlen_q.pop_front();
		vif.mdr_cb.awsize  <= awsize_q.pop_front();
		vif.mdr_cb.awburst <= awburst_q.pop_front();
		vif.mdr_cb.awvalid <= 1;
	end

     wait(vif.mdr_cb.awready);
	@(vif.mdr_cb);

    vif.mdr_cb.awaddr  <= 0;
    vif.mdr_cb.awlen   <= 0;
    vif.mdr_cb.awsize  <= 0;
    vif.mdr_cb.awburst <= 0;
	vif.mdr_cb.awvalid <= 0;

	sem0.put(1);
$display($time,"<<<<<<<<<<<<<<<<<<MASTER DRIVER COME OUT WR_ADDRESS_CHANNEL =%0d>>>>>>>>>>>>>>>>>>>>>>>",j);
endtask

task master_driver::wr_data_ch(int j);
sem1.get(1);
$display($time,">>>>>>>>>>>>>>>>>MASTER DRIVER COME WR_DATA_CHANNEL =%0d<<<<<<<<<<<<<<<<<<<<<<<<<<",j);
       if(!vif.mdr_cb.aresetn)
        begin
	    vif.mdr_cb.wvalid <= 0;
		//@(vif.mdr_cb);
        end
        
         
        wait(vif.mdr_cb.wready);
	repeat(2)
	@(vif.mdr_cb);
	
	if(wdata_q.size != 0)
	begin
	length = length_q.pop_front();
  
	for(int i=0; i < (length + 1); i++)
	begin

		vif.mdr_cb.wdata	<=wdata_q.pop_front();
		vif.mdr_cb.wstrb	<=wstrb_q.pop_front();
		vif.mdr_cb.wvalid	<= 1;
	
		if(i==length)
			vif.mdr_cb.wlast <= 1;
		else
			vif.mdr_cb.wlast<= 0;
	@(vif.mdr_cb);
	
	end
	vif.mdr_cb.wvalid	<= 0;
	vif.mdr_cb.wdata	<= 0;
	vif.mdr_cb.wstrb	<= 0;
	vif.mdr_cb.wlast	<= 0;
	end
 sem1.put(1);
$display($time,"<<<<<<<<<<<<<<<<<<<<MASTER DRIVER COME OUT WR_DATA_CHANNEL =%0d>>>>>>>>>>>>>>>>>>>",j);
        
endtask

task master_driver::store_to_queue(signal_xtn xtn);
 awid_q.push_back(xtn.awid);
 awaddr_q.push_back(xtn.awaddr);
 awlen_q.push_back(xtn.awlen);
 length_q.push_back(xtn.awlen);
 awsize_q.push_back(xtn.awsize);
 awburst_q.push_back(xtn.awburst);

 foreach(xtn.m_data[i])
 begin
	wdata_q.push_back(xtn.m_data[i]);
     
 end
 foreach(xtn.strb_gen[i])
   wstrb_q.push_back(xtn.strb_gen[i]);
   
endtask


task master_driver::wr_resp_ch(int j);
$display($time,">>>>>>>>>>>>>>>>>MASTER DRIVER COME WR_RESPONSE_CHANNEL =%0d<<<<<<<<<<<<<<<<<<<<<<<<<<",j);
sem2.get(1);
wait(vif.mdr_cb.wlast);
 @(vif.mdr_cb);
   vif.mdr_cb.bready <= 1;
 wait(vif.mdr_cb.bvalid);
  bresp_q.push_back(vif.mdr_cb.bresp);
 vif.mdr_cb.bready <=0;
sem2.put(1);
$display($time,"<<<<<<<<<<<<<<<<MASTER DRIVER COME OUT WR_RESPONSE_CHANNEL =%0d>>>>>>>>>>>>>>>>>>>>>>>",j);
endtask


task master_driver::store_to_read(signal_xtn xtn);
 arid_q.push_back(xtn.arid);
 araddr_q.push_back(xtn.araddr);
 arlen_q.push_back(xtn.arlen);
 arsize_q.push_back(xtn.arsize);
 arburst_q.push_back(xtn.arburst);
endtask


task master_driver::rd_addr_ch(int j);
$display($time,">>>>>>>>>>>>>>>>>MASTER DRIVER COME READ_ADDR_CHANNEL =%0d<<<<<<<<<<<<<<<<<<<<<<<<<<",j);
@(vif.mdr_cb);
 sem3.get(1);

     if(!vif.mdr_cb.aresetn)
        begin
	  @(vif.mdr_cb);
          vif.mdr_cb.arvalid <= 0;
        end
 
  if(arid_q.size != 0)
	begin
		vif.mdr_cb.arid    <= arid_q.pop_front();
		vif.mdr_cb.araddr  <= araddr_q.pop_front();
		vif.mdr_cb.arlen   <= arlen_q.pop_front();
		vif.mdr_cb.arsize  <= arsize_q.pop_front();
		vif.mdr_cb.arburst <= arburst_q.pop_front();
		vif.mdr_cb.arvalid <= 1;
	end
     wait(vif.mdr_cb.arready);
     @(vif.mdr_cb);
	vif.mdr_cb.arvalid <= 0;

 sem3.put(1);

$display($time,"<<<<<<<<<<<<<<<<MASTER DRIVER COME OUT READ_ADDR_CHANNEL =%0d>>>>>>>>>>>>>>>>>>>>>>>",j);
endtask

task master_driver::rd_data_ch();
$display($time,"<<<<<<<<<<<<<<<<MASTER DRIVER COME READ_DATA_CHANNEL >>>>>>>>>>>>>>>>>>>>>>>");
 sem4.get(1);
  @(vif.mdr_cb);
  vif.mdr_cb.rready <= 1;
 
 @(vif.mdr_cb);
 sem4.put(1);
$display($time,"<<<<<<<<<<<<<<<<MASTER DRIVER COME OUT READ_DATA_CHANNEL >>>>>>>>>>>>>>>>>>>>>>>");
endtask



