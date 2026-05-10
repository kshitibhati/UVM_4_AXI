
interface axi_if(input bit aclk);

logic aresetn;

logic [3:0]awid;
logic [31:0]awaddr;
logic [7:0]awlen;
logic [2:0]awsize;
logic [1:0]awburst;
bit awvalid;
logic awready;

logic [31:0]wdata;
logic [3:0]wstrb;
logic wlast;
bit wvalid;
logic wready;

logic [3:0]bid;
logic [1:0]bresp;
bit bvalid;
logic bready;

logic [3:0]arid;
logic [31:0]araddr;
logic [7:0]arlen;
logic [2:0]arsize;
logic [1:0]arburst;
bit arvalid;
logic arready;

logic [3:0]rid;
logic [31:0]rdata;
logic [1:0]rresp;
logic rlast;
bit rvalid;
logic rready;

clocking mdr_cb @(posedge aclk);
 default input #1 output #1;

 input aresetn;
 
 output awid;
 output awaddr;
 output awlen;
 output awsize;
 output awburst;
 output awvalid;
 input awready;

 output wdata;
 output wstrb;
 output wlast;
 output wvalid;
 input wready;
 
 output bready;
 input bid;
 input bresp;
 input bvalid;


 output arid;
 output araddr;
 output arlen;
 output arsize;
 output arburst;
 output arvalid;
 input arready;
 
 output rready;
 input rid;
 input rdata;
 input rresp;
 input rlast; 
 input rvalid;
endclocking 

clocking mmon_cb @(negedge aclk);
 default input #1 output #1;
 
 input awid;
 input awaddr;

 input awlen;
 input awsize;
 input awburst;
 input awvalid;
 input awready;


 input wdata;
 input wstrb;
 input wlast;
 input wvalid;
 input wready;
 
 input bready;
 input bid;
 input bresp;
 input bvalid;

 input arid;
 input araddr;
 input arlen;
 input arsize;
 input arburst;
 input arvalid;
 input arready;
 
 input rready;
 input rid;
 input rdata;
 input rresp;

 input rlast; 
 input rvalid;
endclocking 


clocking sdr_cb @(posedge aclk);
 default input #1 output #1;

 input aresetn; 

 output awready;

 input awid;
 input awaddr;
 input awlen;
 input awsize;
 input awburst;
 input awvalid;

 output wready;
 input wdata;
 input wstrb;
 input wlast;
 input wvalid;
 
 output bid;
 output bresp;
 output bvalid;
 input bready; 

 
 output arready;
 input arid;
 input araddr;
 input arlen;
 input arsize;
 input arburst;
 input arvalid;
 
 input rready;
 output rid;
 output rdata;
 output rresp;
 output rlast;
 output rvalid;
endclocking 

clocking smon_cb @(posedge aclk);
 default input #1 output #1;
 
 input awready;
 input awid;
 input awaddr;
 input awlen;
 input awsize;
 input awburst;
 input awvalid;

 input wready;
 input wdata;
 input wstrb;
 input wlast;
 input wvalid;
 
 input bid;
 input bresp;
 input bvalid;
 input bready; 
 
 input arready;
 input arid;
 input araddr;
 input arlen;
 input arsize;
 input arburst;
 input arvalid;
 
 input rready;
 input rid;
 input rdata;
 input rresp;
 input rlast;
 input rvalid;
endclocking 


modport MDR_MP(clocking mdr_cb);

modport MMON_MP(clocking mmon_cb);
 
modport SDR_MP(clocking sdr_cb);

modport SMON_MP(clocking smon_cb);

endinterface 

