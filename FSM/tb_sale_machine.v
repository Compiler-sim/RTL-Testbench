//-----------------------------------
//Filename:tb_sale_machine.v
//Author:fanhu
//Create Date:12/12/2018
//E-mail:fh_w@seu.edu.cn
//Description:自动售货机的TB测试文件
//
//Revision: 
//Coryright:
//--------------------------------

`timescale 1ns/1ns
module tb_sale_machine();

parameter CHARGE_WIDTH=2;

reg clk_inst;
reg rst_n_inst;
reg ten_inst;
reg twenty_inst;
reg fifty_inst;
wire out_inst;
wire [CHARGE_WIDTH-1:0] charge_inst;

sale_machine #(
       .CHARGE_WIDTH(CHARGE_WIDTH)
        )sale_machine_inst(
       .clk(clk_inst),
       .rst_n(rst_n_inst),
       .ten(ten_inst),
	   .twenty(twenty_inst),
	   .fifty(fifty_inst),
	   .out(out_inst),
	   .charge(charge_inst)
	   );
	   
always #25 clk_inst=~clk_inst;   

initial begin
      rst_n_inst=0;
	  clk_inst=0;
	  #20
	  rst_n_inst=1;
	  #10
      input_eighty(ten_inst,twenty_inst,fifty_inst);
	  
end	   

task input_eighty;
      output ten_inst_1;
      output twenty_inst_1;
      output fifty_inst_1;
	  fork
	  begin	  
	  
	  @(posedge clk_inst)
	  #1
	  ten_inst_1=1;
	  twenty_inst_1=0;
	  fifty_inst_1=0;
	  end
	  begin
	  @(posedge clk_inst)
	  #2	  
	  ten_inst_1=0;
	  twenty_inst_1=1;
	  fifty_inst_1=0;
	  end
	  begin
	   @(posedge clk_inst)
      #3
	  ten_inst_1=0;
	  twenty_inst_1=0;
	  fifty_inst_1=1;		  
	  end
	  join_any
	  
endtask	  

 initial 
    begin
      $wlfdumpvars();//保存所有的波形
    end

endmodule