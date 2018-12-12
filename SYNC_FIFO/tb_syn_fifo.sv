
//-----------------------------------
//Filename:syn_fifo.v
//Author:fanhu
//Create Date:12/12/2018
//E-mail:fh_w@seu.edu.cn
//Description:同步FIFO的TB测试文件
//
//Revision: 
//Coryright:
//--------------------------------

`timescale 1ns/1ns

module tb_syn_fifo();

parameter DATA_WIDTH_inst=8;
parameter ADDER_WIDTH_inst=4;
parameter MEM_WIDTH_inst=16;

reg clk_inst,rst_n_inst;
reg wr_en_inst,rd_en_inst;
reg [DATA_WIDTH_inst-1:0] data_in_inst;

wire [DATA_WIDTH_inst-1:0] data_out_inst;
wire empty_inst,full_inst;

 syn_fifo#(.DATA_WIDTH(DATA_WIDTH_inst),
           .MEM_WIDTH(MEM_WIDTH_inst),
           .ADDER_WIDTH(ADDER_WIDTH_inst)
          )syn_fifo_inst(
            .clk(clk_inst),
            .rst_n(rst_n_inst),
            .wr_en(wr_en_inst),
            .rd_en(rd_en_inst),
            .data_in(data_in_inst),
            .data_out(data_out_inst),
            .empty(empty_inst),
            .full(full_inst)	   
             );
			 
always #25 clk_inst=~clk_inst;

initial begin
        clk_inst=0;
		rst_n_inst=0;
		data_in_inst=0;
		wr_en_inst=0;
		rd_en_inst=0;
		#10 rst_n_inst=1;
	    fifo_wr;
		fifo_rd;
        fifo_wr_rd;
		
end	
		
task fifo_wr;
    //begin
     repeat(16)@(posedge clk_inst)begin
     #1
	 wr_en_inst=1;
	 data_in_inst=data_in_inst+1;
	 $display("%0tns,write enable:%h,send data:%h",$time,wr_en_inst,data_in_inst);
	 end
	 @(posedge clk_inst)
     wr_en_inst=0;	
     //#10	
   // end	 
endtask

task fifo_rd;
    begin
     repeat(16)@(posedge clk_inst)begin
     #1
	 rd_en_inst=1;
	 $display("%0tns,read enable:%h,recive data:%h",$time,rd_en_inst,data_out_inst);
	 end
	 @(posedge clk_inst)
     rd_en_inst=0;	
    // #10	
    end	 
endtask	 

task fifo_wr_rd;
   // begin
     repeat(16)@(posedge clk_inst)begin
     #1
	 rd_en_inst=1;
	 wr_en_inst=1;
	 data_in_inst=data_in_inst+1;
	 $display("%0tns,write enable:%h,read enable:%h,send data:%h,recive data:%h",$time,wr_en_inst,rd_en_inst,data_in_inst,data_out_inst);
	 end
	 @(posedge clk_inst)
     rd_en_inst=0;	
	 wr_en_inst=0;
    // #10	

 
endtask	
 
  initial 
    begin
      $wlfdumpvars();//保存所有的波形
    end 
	
endmodule