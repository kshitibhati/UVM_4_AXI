/********************** signal xtn*****************************/

class signal_xtn extends uvm_sequence_item;

 /////  write address channel //////////////
randc bit [3:0]awid;
 rand bit [31:0]awaddr;
 rand bit [7:0]awlen;
 rand bit [2:0]awsize;
 rand bit [1:0]awburst;
      bit awvalid;
      bit awready;

////  write data channel /////////////
 rand bit [31:0]wdata;
 rand bit [3:0]wstrb;
      bit wlast;
      bit wvalid;
      bit wready;

////  write response channel //////////
 bit [3:0]bid[$];
 bit [1:0]bresp;
 bit bvalid;
 bit bready;
//bresp_enum bresp;

////  read address channel ///////////
 rand bit [3:0]arid;
 rand bit [31:0]araddr;
 rand bit [7:0]arlen;
 rand bit [2:0]arsize;
 rand bit [1:0]arburst;
 bit arvalid;
 bit arready;

////  read data channel ////////////
 bit [3:0]rid;
// bit [31:0]rdata;
 bit [1:0]rresp;
 bit rlast;
 bit rvalid;
 bit rready;
/////////// Extra variable for calculation 
bit [8:0]burst_len;
static bit [2:0] no_of_byte; 
static bit [31:0]aligned_addr;
static bit [31:0]wrap_boundry;

rand bit [31:0]m_data[]; 
//rand bit [31:0]s_data[];
rand bit [3:0]strb_gen[];
static bit [31:0]s_data[int];
static bit [31:0]s_awaddr;
static bit [7:0]xtn_awlen;
static bit [1:0]s_awburst;


static bit [31:0]s_wdata;
static bit [3:0]s_wstrb;
static bit s_wlast;

static bit [31:0]mask_data;

event last;
 `uvm_object_utils_begin(signal_xtn)
 	`uvm_field_int(awid,UVM_ALL_ON)
	`uvm_field_int(awaddr,UVM_ALL_ON)
	`uvm_field_int(awlen,UVM_ALL_ON) 
	`uvm_field_int(awsize,UVM_ALL_ON)
	`uvm_field_int(awburst,UVM_ALL_ON) 
	`uvm_field_int(awvalid,UVM_ALL_ON)
	`uvm_field_int(awready,UVM_ALL_ON)
	`uvm_field_int(wdata,UVM_ALL_ON)
	`uvm_field_int(wstrb,UVM_ALL_ON)
	`uvm_field_int(wlast,UVM_ALL_ON)
	`uvm_field_int(wvalid,UVM_ALL_ON)
	`uvm_field_int(wready,UVM_ALL_ON)
	`uvm_field_queue_int(bid,UVM_ALL_ON)
	`uvm_field_int(bresp,UVM_ALL_ON)
	`uvm_field_int(bvalid,UVM_ALL_ON)
	`uvm_field_int(bready,UVM_ALL_ON)
	`uvm_field_int(arid,UVM_ALL_ON)
	`uvm_field_int(araddr,UVM_ALL_ON)
	`uvm_field_int(arlen,UVM_ALL_ON)
	`uvm_field_int(arsize,UVM_ALL_ON)
	`uvm_field_int(arburst,UVM_ALL_ON)
	`uvm_field_int(arvalid,UVM_ALL_ON)
	`uvm_field_int(arready,UVM_ALL_ON)
	`uvm_field_int(rid,UVM_ALL_ON)
	
	`uvm_field_int(rresp,UVM_ALL_ON)
	`uvm_field_int(rlast,UVM_ALL_ON)
	`uvm_field_int(rvalid,UVM_ALL_ON)
	`uvm_field_int(rready,UVM_ALL_ON)
	`uvm_field_array_int(m_data,UVM_ALL_ON)

	`uvm_field_array_int(strb_gen,UVM_ALL_ON)
 `uvm_object_utils_end





/////////////////     Function declaration //////////////////

extern function new(string name="signal_xtn");
extern function void post_randomize();

///// constraints         ////////////////////

constraint AW_SIZE  { awsize <= 3'b010;}
constraint AW_LEN   { awlen < 8'd16;}
constraint W_DATA   { m_data.size==awlen+1;}  
constraint AW_BURST { awburst <= 2'b10;}
constraint W_STROB    { strb_gen.size==awlen+1;}

constraint AR_SIZE  { arsize <= 3'b010;}
constraint AR_LEN   { arlen < 8'd16;}

constraint AR_BURST { arburst < 2'b11;}

//constraint AWADDRESS{ awaddr[1:0]==2'b01;}

endclass 

function signal_xtn::new(string name="signal_xtn");
   super.new(name);
endfunction

function void signal_xtn::post_randomize();
 burst_len=awlen+1'b1;
 no_of_byte=2**awsize;
 aligned_addr=(awaddr/((no_of_byte)*burst_len))*((no_of_byte)*burst_len);
 wrap_boundry=aligned_addr+(no_of_byte*burst_len);
 s_awaddr=aligned_addr;
 

////////////////////////AWADDR = 00 /////////////////////////////
 if(awaddr[1:0]==2'b00)
  begin
	if(awsize==0)
	begin
		strb_gen[0]=4'b0001;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
			begin
				strb_gen[i+1]=strb_gen[i]<<1;
				if(strb_gen[i+1]==4'b0000)
					strb_gen[i+1]=4'b0001;
			end
		end
	end
       
   	if(awsize==1)
	begin
		strb_gen[0]=4'b0011;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
				strb_gen[i+1]=~strb_gen[i];
		end
	end

	if(awsize==2)
	begin
		strb_gen[0]=4'b1111;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
				strb_gen[i]=strb_gen[0];
		end
	end
  end
//////////////////////////AWADDR = 01 /////////////////////////
  if(awaddr[1:0]==2'b01)
  begin
	if(awsize==0)
	begin
		strb_gen[0]=4'b0010;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
			begin
				strb_gen[i+1]=strb_gen[i]<<1;
				if(strb_gen[i+1]==4'b0000)
					strb_gen[i+1]=4'b0001;
			end
		end
	end
       
   	if(awsize==1)
	begin
		strb_gen[0]=4'b0010;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			strb_gen[1]=4'b1100;
			foreach(strb_gen[i])
				strb_gen[i+2]=~strb_gen[i+1];
		end
	end

	if(awsize==2)
	begin
		strb_gen[0]=4'b1110;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
				strb_gen[i+1]=4'b1111;
		end
	end
  end
//////////////////////////AWADDR = 10 //////////////////////////////
if(awaddr[1:0]==2'b10)
  begin
	if(awsize==0)
	begin
		strb_gen[0]=4'b0100;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
			begin
				strb_gen[i+1]=strb_gen[i]<<1;
				if(strb_gen[i+1]==4'b0000)
					strb_gen[i+1]=4'b0001;
			end
		end
	end
       
   	if(awsize==1)
	begin
		strb_gen[0]=4'b1100;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
				strb_gen[i+1]=~strb_gen[i];
		end
	end

	if(awsize==2)
	begin
		strb_gen[0]=4'b1100;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
				strb_gen[i+1]=4'b1111;
		end
	end
  end
////////////////////////// AWADDR = 11 //////////////////////////////
if(awaddr[1:0]==2'b11)
  begin
	if(awsize==0)
	begin
		strb_gen[0]=4'b1000;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
			begin
				strb_gen[i+1]=strb_gen[i]<<1;
				if(strb_gen[i+1]==4'b0000)
					strb_gen[i+1]=4'b0001;
			end
		end
	end
       
   	if(awsize==1)
	begin
		strb_gen[0]=4'b1000;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			strb_gen[1]=4'b0011;
			foreach(strb_gen[i])
				strb_gen[i+2]=~strb_gen[i+1];
		end
	end

	if(awsize==2)
	begin
		strb_gen[0]=4'b1000;
		if(awburst==2'b00)
		begin
			foreach(strb_gen[i])
			  strb_gen[i+1]=strb_gen[i];
		end
		else
		begin
			foreach(strb_gen[i])
				strb_gen[i+1]=4'b1111;
		end
	end
  end  
endfunction 
