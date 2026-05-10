module top();

import axi_test_pkg::*;
import uvm_pkg::*;

bit aclk;

always 
 #10 aclk=!aclk; 

axi_if in(aclk);

initial begin
 in.aresetn = 0;
 #20;
 in.aresetn = 1;
 
end
initial begin
 
 uvm_config_db #(virtual axi_if)::set(null,"*","vif",in);
 
 run_test();
end

endmodule
