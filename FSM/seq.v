//-----------------------------------
//Filename:seq.v
//Author:fanhu
//Create Date:12/12/2018
//E-mail:fh_w@seu.edu.cn
//Description:序列检测器的RTL文件
//
//Revision: 
//Coryright:
//--------------------------------
module seq #(
     parameter STATE_WIDTH=2
	 )(
       input clk,
	   input rst_n,
	   input seq_in,
	   output reg out
	   );
	   
parameter IDLE = 4'b0000,
          S1 = 4'b0001,
		  S2 = 4'b0010,
		  S3 = 4'b0011,
		  S4 = 4'b0100,
		  S5 = 4'b0101,
		  S6 = 4'b0110,
		  S7 = 4'b0111,
		  S8 = 4'b1000,
		  S9 = 4'b1001;
		  
 reg [STATE_WIDTH-1:0]state,next_state;
 
 always@(posedge clk or negedge rst_n)
       if(!rst_n)
	      state<=IDLE;
	   else 
          state<=next_state;

always@(*)
     case(state)	
         IDLE: if(seq_in)
		         next_state=S1;
			   else
			     next_state=IDLE;
		 S1:   if(seq_in)
                 next_state=S1;
               else
                 next_state=S2;
         S2:   if(seq_in)
                 next_state=S3;
               else
                 next_state=IDLE;
		 S3:   if(seq_in)
                 next_state=S1;
               else
                 next_state=S4;
         S4:   if(seq_in)
                 next_state=S5;
               else
                 next_state=IDLE;
		 S5:   if(seq_in)
                 next_state=S6;
               else
                 next_state=S4;
         S6:   if(seq_in)
                 next_state=S1;
               else
                 next_state=S7;	
		 S7:   if(seq_in)
                 next_state=S8;
               else
                 next_state=IDLE;
         S8:   if(seq_in)
                 next_state=S9;
               else
                 next_state=S4;	
         S9:   if(seq_in)
                 next_state=S1;
               else
                 next_state=S2;	
        default: next_state=IDLE;				 
          				 
	 endcase	 
 
  always@(*)
         if(state==S9)
		    out=1;
		 else
            out=0;		 
        	

endmodule