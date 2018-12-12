
//-----------------------------------
//Filename:syn_fifo.v
//Author:fanhu
//Create Date:12/12/2018
//E-mail:fh_w@seu.edu.cn
//Description:同步FIFO的RTL文件
//
//Revision: 
//Coryright:
//--------------------------------

`define syn_fifo_fcounter

`ifdef syn_fifo_fcounter

       module syn_fifo#(parameter DATA_WIDTH=8,
                        parameter MEM_WIDTH=16,
          				parameter ADDER_WIDTH=4
          			   )(
                     input clk,
                     input rst_n,
                     input wr_en,
                     input rd_en,
                     input [DATA_WIDTH-1:0] data_in,
                     output reg [DATA_WIDTH-1:0] data_out,
                     output empty,
                     output full	   
                         );
          		   
          reg [DATA_WIDTH-1:0] mem[0:MEM_WIDTH-1];
          reg [ADDER_WIDTH-1:0]wr_adder,rd_adder;
          reg [ADDER_WIDTH:0] fcounter;
          
		  assign empty=(fcounter==0)?1:0;
		  assign full=(fcounter=='d16)?1:0;
		  
          always@(posedge clk or negedge rst_n)
                 if(!rst_n)
          	     fcounter<=0;
          	   else if(wr_en&&rd_en&&!full&&!empty)
                   fcounter<=fcounter;	   
          	   else if(wr_en&&!full)
          	       fcounter<=fcounter+1;
          	   else if(rd_en&&!empty)
                   fcounter<=fcounter-1;
          	   else 
                   fcounter<=fcounter;
          
          always@(posedge clk or negedge rst_n)
                  if(!rst_n)
                     wr_adder<=0;
                  else if(wr_en&&!full)
                     wr_adder<=wr_adder+1;
                  else 
                     wr_adder<=wr_adder;
          
          always@(posedge clk or negedge rst_n)
                  if(!rst_n)
                      rd_adder<=0;
                  else if(rd_en&&!empty)
                      rd_adder<=rd_adder+1;
                  else
                      rd_adder<=rd_adder;		
          			
          always@(posedge clk or negedge rst_n)			
                  if(wr_en&&!full)
          		      mem[wr_adder]<=data_in;
          		   
          always@(posedge clk or negedge rst_n)
                  if(rd_en&&!empty)
                      data_out<=mem[rd_adder];
	 endmodule
          
`else
       module syn_fifo#(parameter DATA_WIDTH=8,
                        parameter MEM_WIDTH=16,
          				parameter ADDER_WIDTH=4
          			   )(
                     input clk,
                     input rst_n,
                     input wr_en,
                     input rd_en,
                     input [DATA_WIDTH-1:0] data_in,
                     output reg [DATA_WIDTH-1:0] data_out,
                     output empty,
                     output full	   
                         );
          reg [DATA_WIDTH-1:0] mem[0:MEM_WIDTH-1];
          reg [ADDER_WIDTH:0]wr_adder,rd_adder;	
		  
		  
		  assign empty=(wr_adder==rd_adder)?1:0;
		  assign full=((wr_adder[ADDER_WIDTH]!=rd_adder[ADDER_WIDTH])&&(wr_adder[ADDER_WIDTH-1:0]==rd_adder[ADDER_WIDTH-1:0]))?1:0;
		  
          always@(posedge clk or negedge rst_n)
                  if(!rst_n)
                     wr_adder<=0;
                  else if(wr_en&&!full)
                     wr_adder<=wr_adder+1;
                  else 
                     wr_adder<=wr_adder;
          
          always@(posedge clk or negedge rst_n)
                  if(!rst_n)
                      rd_adder<=0;
                  else if(rd_en&&!empty)
                      rd_adder<=rd_adder+1;
                  else
                      rd_adder<=rd_adder;	
		    
          always@(posedge clk or negedge rst_n)			
                  if(wr_en&&!full)
          		      mem[wr_adder[ADDER_WIDTH-1:0]]<=data_in;
          		   
          always@(posedge clk or negedge rst_n)
                  if(rd_en&&!empty)
                      data_out<=mem[rd_adder[ADDER_WIDTH-1:0]];   
	endmodule
         					  
	
`endif
			
      	   
      
      
