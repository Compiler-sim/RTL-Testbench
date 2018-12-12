//-----------------------------------
//Filename:tb_seq.v
//Author:fanhu
//Create Date:12/12/2018
//E-mail:fh_w@seu.edu.cn
//Description:序列检测器的测试文件
//
//Revision: 
//Coryright:
//--------------------------------


`timescale 1ns/1ns
module tb_seq();

parameter STATE_WIDTH_inst=4;


reg clk_inst;
reg rst_n_inst;
reg seq_in_inst;
wire out_inst;

 seq #(
     .STATE_WIDTH(STATE_WIDTH_inst)
	 )seq_inst(
      .clk(clk_inst),
	  .rst_n(rst_n_inst),
	  .seq_in(seq_in_inst),
	  .out(out_inst)
	   );

always #25	clk_inst=~clk_inst;

initial begin
   clk_inst=0;
   rst_n_inst=0;
   #10
   rst_n_inst=1;
   #20
   send_seq;
end


task send_seq;
   //output seq_in_inst;
     begin
      @(posedge clk_inst)
	  #1
      seq_in_inst=1;
      $display("in %m,%0t,send bit %h",$time,seq_in_inst);
      @(posedge clk_inst)
	  #1
      seq_in_inst=0;
      $display("%0t,send bit %h",$time,seq_in_inst); 
      @(posedge clk_inst)
	  #1
      seq_in_inst=1;
      $display("%0t,send bit %h",$time,seq_in_inst);
      @(posedge clk_inst)
	  #1
      seq_in_inst=0;
      $display("%0t,send bit %h",$time,seq_in_inst); 	  
      @(posedge clk_inst)
	  #1
      seq_in_inst=1;
      $display("%0t,send bit %h",$time,seq_in_inst);
      @(posedge clk_inst)
	  #1
      seq_in_inst=1;
      $display("%0t,send bit %h",$time,seq_in_inst); 
      @(posedge clk_inst)
	  #1
      seq_in_inst=0;
      $display("%0t,send bit %h",$time,seq_in_inst);
      @(posedge clk_inst)
	  #1
      seq_in_inst=1;
      $display("%0t,send bit %h",$time,seq_in_inst); 	
      @(posedge clk_inst)
	  #1
      seq_in_inst=1;
      $display("%0t,send bit %h",$time,seq_in_inst); 
     @(posedge clk_inst)
	  $display("finished"); ;
	 end
endtask	 
	  initial 
    begin
      $wlfdumpvars();//保存所有的波形
    end
endmodule