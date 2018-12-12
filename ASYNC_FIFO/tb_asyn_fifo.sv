//-----------------------------------
//Filename:syn_fifo.v
//Author:fanhu
//Create Date:12/12/2018
//E-mail:fh_w@seu.edu.cn
//Description:异步FIFO的TB测试文件
//
//Revision: 
//Coryright:
//--------------------------------

`timescale 1ns/1ns
module tb_asyn_fifo();
`define random
 parameter DATA_WIDTH_inst=16;
 parameter MEM_WIDTH_inst=2048;
 parameter ADDER_WIDTH_inst=11;
 
 reg wr_clk_inst,rd_clk_inst;
 reg rst_n_inst;
 reg wr_en_inst,rd_en_inst;
 reg [DATA_WIDTH_inst-1:0] data_in_inst;
 wire [DATA_WIDTH_inst-1:0] data_out_inst;
 wire empty_inst,full_inst;
 
asyn_fifo #(
          .DATA_WIDTH(DATA_WIDTH_inst),
          .MEM_WIDTH(MEM_WIDTH_inst),
          .ADDER_WIDTH(ADDER_WIDTH_inst)
	    )asyn_fifo_inst(
		.wr_clk(wr_clk_inst),
		.rd_clk(rd_clk_inst),
		.wr_rst_n(rst_n_inst),
		.rd_rst_n(rst_n_inst),
		.wr_en(wr_en_inst),
        .rd_en(rd_en_inst),
		.data_in(data_in_inst),
        .data_out(data_out_inst),
        .empty(empty_inst),
        .full(full_inst)
		);

/* 		
always #25		wr_clk_inst=~wr_clk_inst;
always #20      rd_clk_inst=~rd_clk_inst; */

always #3		wr_clk_inst=~wr_clk_inst;
always #20      rd_clk_inst=~rd_clk_inst;


initial begin
     rst_n_inst=0;
	 wr_clk_inst=0;
	 rd_clk_inst=0;
	 data_in_inst=0;
	 #10
	 rst_n_inst=1;
	 
`ifdef random
     ;
`else	 

	 fifo_wr;
	 fifo_rd;
`endif
	 
end

task fifo_wr;
     begin
     repeat(2048)@(posedge wr_clk_inst)begin
     #1
	 wr_en_inst=1;
	 data_in_inst=data_in_inst+1;
	 $display("%0tns,write enable:%h,send data:%h",$time,wr_en_inst,data_in_inst);
	 end
	 @(posedge wr_clk_inst)
     wr_en_inst=0;	
	 end
endtask

task fifo_rd;
    begin
     repeat(2048)@(posedge rd_clk_inst)begin
     #1
	 rd_en_inst=1;
	 $display("%0tns,read enable:%h,recive data:%h",$time,rd_en_inst,data_out_inst);
	 end
	 @(posedge rd_clk_inst)
     rd_en_inst=0;	
    end	 
endtask	 




//$random;随机测试

`ifdef random
always@(posedge rd_clk_inst or negedge rst_n_inst)begin
       if(!rst_n_inst)
	     #1 rd_en_inst<=0;
	   else
      	 #1 rd_en_inst<=$random;
	   end
	   
always@(posedge wr_clk_inst or negedge rst_n_inst)begin
       if(!rst_n_inst)
	     #1 wr_en_inst<=0;
	   else
      	 #1 wr_en_inst<=$random;
	   end
	  
always@(*)begin
      if(wr_en_inst)
	    data_in_inst=$random;
	  else
        data_in_inst=0;	  	  
	  end	  
	  
//
`endif

  initial 
    begin
      $wlfdumpvars();//保存所有的波形
    end 
	
  initial begin
   //repeat(3000)@(posedge rd_clk_inst);
   #2000_000
   $finish;
  end
  
endmodule