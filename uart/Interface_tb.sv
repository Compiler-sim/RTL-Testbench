`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/12/05 00:06:21
// Design Name: 
// Module Name: Interface_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Interface_tb();

parameter CLK_Period = 20000000;
parameter Buad_Rate  = 9600;
parameter num_mfcc=3848;
parameter D_WL        = 24 ;
logic clk;
logic rst_n;
logic uart_rx1;
logic uart_tx1;

//logic uart_rx2;
//logic uart_tx2;
logic      w_x_en;
logic[7:0] rx_data2;
logic      rx_finish2;
reg[7:0] tx_data2;
reg      tx_en2;
logic [23:0] d_o;
logic  d_o_valid;
logic tx_finish2;
always #3 clk = ~clk;
integer i,j;
reg [7:0] count;
reg rx_finish_d;
always @( posedge clk )
  if( !rst_n )
    rx_finish_d <= 1'b0;
  else 
    rx_finish_d <= tx_finish2;
	

always @( posedge clk )
 if(!rst_n)
   w_x_en<=0;
  else if(count==8'd200)
  w_x_en<=1;
 else
  w_x_en<=0;

  

always @(posedge clk)
if(!rst_n)
 count<=8'd0;
else 
 count<=count+1;
 
//always #25 clk=~clk;	
integer ii,jj;	

reg [D_WL-1:0] mffc_in[0:num_mfcc-1];
initial begin
  clk = 0;
  rst_n = 0;
  #20;
  rst_n=1;
  #20;
 mfcc_load(mffc_in);
 
 //uart_trans( mffc_in, tx_finish2,tx_en2,tx_data2);
  // wait( rx_finish2 && rx_data2=='hff )
      // $display( "get req successful!!!" );
 /* forever begin  
 for( ii=0;i<3;ii=ii+1 ) begin
    for ( jj=0;jj<3;jj=jj+1 ) begin	   
        // tx_en2 = 1;
        // tx_data2=mffc_in[i][8*j+7:8*j];
		if(jj==0)
		 begin
		 tx_en2 = 1;
         tx_data2=mffc_in[ii][7:0];		 
		 end
		 if(jj==1)
		 begin
		 tx_en2 = 1;
         tx_data2=mffc_in[ii][15:8];		 
		 end
		  if(jj==2)
		 begin
		 tx_en2 = 1;
         tx_data2=mffc_in[ii][23:16];		 
		 end
         #20
        //wait( (~rx_finish_d)& tx_finish2)
		 @(posedge tx_finish2)
         $display("send one d over");
     end  
	 end
	 end */
	jj=0;
	ii=0;
  begin
	repeat(num_mfcc*3)@( posedge clk )begin
	// tx_en2=1;
	// tx_data2=mffc_in[0][7:0];
	
	   if(jj==0)
		 begin
		 tx_en2 = 1;
         tx_data2=mffc_in[ii][7:0];		 
		 end
		 if(jj==1)
		 begin
		 tx_en2 = 1;
         tx_data2=mffc_in[ii][15:8];		 
		 end
		  if(jj==2)
		 begin
		 tx_en2 = 1;
         tx_data2=mffc_in[ii][23:16];		 
		 end
		 
		 if(jj==2)begin
		 jj=0;
		 ii=ii+1;	
          end		 
		 else begin
		 jj=jj+1;
		 end
		 
	  @(posedge tx_finish2)begin
	    $display("send one d over");
	    $display("%0d",ii);
	  end
	end
  end

end


Interface #(
   .CLK_Period(20000000),//the unit is Hz 
   .Buad_Rate (9600    ), //the unit is bits/s
   .D_WL      ( 24     ),
   .INPUT_SIZE( 26     )
)Interface_inst( 
     .clk      (clk      ),
     .rst_n    (rst_n    ),
     .w_x_en   (w_x_en   ),
     .uart_rx  (uart_tx1  ),
     .uart_tx  (uart_rx1  ),
          
     .d_o_valid(d_o_valid),
     .d_o      (d_o      )
);


UART #(
  .CLK_Period(CLK_Period),//the unit is Hz
  .Buad_Rate (Buad_Rate ) //the unit is bits/s
)UART_INST(
    .clk      (clk      ),
    .rst_n    (rst_n    ),
          
    .tx_data  (tx_data2  ),
    .tx_en    (tx_en2    ),
    .tx_finish(tx_finish2),
    .uart_tx  (uart_tx1  ),
            
    .uart_rx  (uart_rx1  ),
    .rx_data  ( rx_data2    ),
    .rx_finish(rx_finish2)
); 

//monitor——d_o
integer d_o_file;

initial begin
  d_o_file=$fopen("monitor_d_o.txt");
  forever begin
 repeat(148) @(posedge d_o_valid)begin
  repeat(26)@(posedge clk)begin
    $fdisplay(d_o_file,"%h",d_o); 
  end	
  end
  @(posedge clk)
  $finish;
end
end


task mfcc_load(output   [D_WL-1:0] mffc_in[0:num_mfcc-1]);
 parameter audio_file_name= "C:/Users/10903/Desktop/HELLO_DD1/uart/mel_txt(1).txt";
 reg [D_WL:0] audio_value;
 integer i,j,file_id,v;
integer mfcc_file;
 $display("mffc_in value");
 file_id=$fopen(audio_file_name,"r");
 i=0;
 while(!$feof(file_id)) begin        
    v=$fscanf(file_id,"%h",audio_value);
	if(i<=3847)  //修改
		begin		
		mffc_in[i]=audio_value;
		i=i+1;
		end			   					
 end
  $fclose(file_id);
   foreach(mffc_in[a])
    $display("mffc_in[%0d]=%h",a,mffc_in[a]);
  endtask

/* 
  task uart_trans;
  input [D_WL-1:0] mffc_in[0:num_mfcc-1];
  input tx_finish2;

  output tx_en2;
  output [7:0] tx_data2;
  integer i;
  integer j;
  begin
  for( i=0;i<num_mfcc-1;i=i+1 ) begin
    for ( j=0;j<3;j=j+1 ) begin	   
        // tx_en2 = 1;
        // tx_data2=mffc_in[i][8*j+7:8*j];
		if(j==0)
		 begin
		 tx_en2 = 1;
         tx_data2=mffc_in[i][7:0];		 
		 end
		 if(j==1)
		 begin
		 tx_en2 = 1;
         tx_data2=mffc_in[i][15:8];		 
		 end
		  if(j==2)
		 begin
		 tx_en2 = 1;
         tx_data2=mffc_in[i][23:16];		 
		 end
        // #20
        // wait( (~rx_finish_d)& tx_finish2)
		@(posedge tx_finish2)
        $display("send one d over");
    end  
	end
  end 
  
  endtask
  */
  initial begin
 @(posedge d_o_valid)
 repeat(10)@(posedge clk)
  ;
  end
  
  initial 
    begin
      $wlfdumpvars();//保存所有的波形
    end 
  
//task testcase1;
//  integer i,j;
//  w_x_en = 1;
//  #20;
//  w_x_en = 0;
//  wait( rx_finish2 && rx_data2=='hff )
//      $display( "get req successful!!!" );
//  for( i=0;i<26;i=i+1 ) begin
//    for ( j=0;j<4;j=j+1 ) begin
//        tx_en2 = 1;
//        tx_data2=j;
//        #5
//        wait(tx_finish2)
//        $display("send one d over");
//    end  
//  end
//endtask

endmodule
