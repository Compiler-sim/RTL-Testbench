//-----------------------------------
//Filename:syn_fifo.v
//Author:fanhu
//Create Date:12/12/2018
//E-mail:fh_w@seu.edu.cn
//Description:异步FIFO
//
//Revision: 
//Coryright:
//--------------------------------

module asyn_fifo #(
           parameter DATA_WIDTH=16,
           parameter MEM_WIDTH=2048,
           parameter ADDER_WIDTH=11
	    )(
		input wr_clk,
		input rd_clk,
		input wr_rst_n,
		input rd_rst_n,
		input wr_en,
		input rd_en,
        input [DATA_WIDTH-1:0] data_in,
        output reg [DATA_WIDTH-1:0] data_out,
        output empty,
        output full
		);
	      reg [DATA_WIDTH-1:0] mem[0:MEM_WIDTH-1];
          reg [ADDER_WIDTH:0]  wr_adder,rd_adder;	
		  reg [ADDER_WIDTH:0] wr_adder_2_rd1,wr_adder_2_rd2;
		  reg [ADDER_WIDTH:0] rd_adder_2_wr1,rd_adder_2_wr2;	
		  wire [ADDER_WIDTH:0] wr_adder_g,rd_adder_g;
		  
		  //读时钟域的读地址与同步到读时钟域的写地址比较，判断空信号
		  assign empty=(rd_adder_g==wr_adder_2_rd2)?1:0;
		  //写时钟域的写地址与同步到写时钟域的读地址比较，判断满信号
		 // assign full=((wr_adder_g[ADDER_WIDTH]!=rd_adder_2_wr2[ADDER_WIDTH])&&(wr_adder_g[ADDER_WIDTH-1:0]==rd_adder_2_wr2[ADDER_WIDTH-1:0]))?1:0;
		 
		 assign full=(wr_adder_g=={~rd_adder_2_wr2[ADDER_WIDTH:ADDER_WIDTH-1],rd_adder_2_wr2[ADDER_WIDTH-2:0]})?1:0;
		  
		  bin2gray #(.ADDER_WIDTH(ADDER_WIDTH))bin2gray_wr(.bin(wr_adder),.gray(wr_adder_g));
		  bin2gray #(.ADDER_WIDTH(ADDER_WIDTH))bin2gray_rd(.bin(rd_adder),.gray(rd_adder_g));	
		  
		  
		  //写地址同步到读时钟域
		  always@(posedge wr_clk or negedge wr_rst_n)
		         if(!wr_rst_n)begin
				     wr_adder_2_rd1<=0;
					 wr_adder_2_rd2<=0;
					 end
				 else begin
				     wr_adder_2_rd1<=wr_adder_g; 
					 wr_adder_2_rd2<=wr_adder_2_rd1;
					 end
					 
		  //读地址同步到写时钟域
		  always@(posedge rd_clk or negedge rd_rst_n)
		          if(!rd_rst_n)begin
				     rd_adder_2_wr1<=0;
					 rd_adder_2_wr2<=0;
					 end
				  else begin
                     rd_adder_2_wr1<=rd_adder_g;
					 rd_adder_2_wr2<=rd_adder_2_wr1;
					 end	
					 
          always@(posedge wr_clk or negedge wr_rst_n)
                  if(!wr_rst_n)
                     wr_adder<=0;
                  else if(wr_en&&!full)
                     wr_adder<=wr_adder+1;
                  else 
                     wr_adder<=wr_adder;
          
          always@(posedge rd_clk or negedge rd_rst_n)
                  if(!rd_rst_n)
                      rd_adder<=0;
                  else if(rd_en&&!empty)
                      rd_adder<=rd_adder+1;
                  else
                      rd_adder<=rd_adder;	
		    
          always@(posedge wr_clk )			
                  if(wr_en&&!full)
          		      mem[wr_adder[ADDER_WIDTH-1:0]]<=data_in;
          		   
          always@(posedge rd_clk or negedge rd_rst_n)
                  if(rd_en&&!empty)
                      data_out<=mem[rd_adder[ADDER_WIDTH-1:0]];   

	  
endmodule

module bin2gray #(
        parameter ADDER_WIDTH=16
         )(
        input [ADDER_WIDTH:0] bin,
	    output [ADDER_WIDTH:0] gray
       );
	   
       assign gray=(bin>>1)^bin;
	       
endmodule