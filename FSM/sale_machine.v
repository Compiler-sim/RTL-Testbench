//-----------------------------------
//Filename:sale_machine.v
//Author:fanhu
//Create Date:12/12/2018
//E-mail:fh_w@seu.edu.cn
//Description:自动售货机的RTL文件
//
//Revision: 
//Coryright:
//--------------------------------

module sale_machine #(parameter CHARGE_WIDTH=2)(
       input clk,
       input rst_n,
       input ten,
	   input twenty,
	   input fifty,
	   output reg out,
	   output reg [CHARGE_WIDTH-1:0] charge
	   );
	  
	  localparam FSM_WIDTH = 4;
	  //不考虑输入金额为110，和120情况
	  localparam IDLE=4'b0000,
				 TEN=4'b0001,
				 TWENTY=4'b0010,
				 THIRTY=4'b0011,
				 FORTY=4'b0100,
				 FIFTY=4'b0101,
				 SIXTY=4'b0110,
				 SEVENTY=4'b0111,
				 EIGHTY=4'b1000,
				 NINETY=4'b1001,
				 HUNDRED=4'b1010;
	  
	   		 
				 
	reg [FSM_WIDTH-1:0] state,next_state;

	
	//推荐三段式状态机
   
    always@(posedge clk or negedge rst_n)
          if(!rst_n)
             state<=IDLE;
          else 
             state<=next_state;		

    always@(*)begin
         case(state)
		     IDLE:  if(ten)
			           next_state=TEN;
					else if(twenty)
                       next_state=TWENTY;
                    else if(fifty)
                       next_state=FIFTY;
                    else
                       next_state=IDLE;
             TEN:   if(ten)
			           next_state=TWENTY;
					else if(twenty)
                       next_state=THIRTY;
                    else if(fifty)
                       next_state=SIXTY;
                    else
                       next_state=TEN;
			 TWENTY:if(ten)
			           next_state=THIRTY;
					else if(twenty)
                       next_state=FORTY;
                    else if(fifty)
                       next_state=SEVENTY;
                    else
                       next_state=TWENTY;		   
 			 THIRTY:if(ten)
			           next_state=FORTY;
					else if(twenty)
                       next_state=FIFTY;
                    else if(fifty)
                       next_state=EIGHTY;
                    else
                       next_state=THIRTY;                    			 
 			 FORTY:if(ten)
			           next_state=FIFTY;
					else if(twenty)
                       next_state=SIXTY;
                    else if(fifty)
                       next_state=NINETY;
                    else
                       next_state=FORTY; 		 
 			 FIFTY:if(ten)
			           next_state=SIXTY;
					else if(twenty)
                       next_state=SEVENTY;
                    else if(fifty)
                       next_state=HUNDRED;
                    else
                       next_state=FIFTY; 	
 			 SIXTY:if(ten)
			           next_state=SEVENTY;
					else if(twenty)
                       next_state=EIGHTY;
                    // else if(fifty)
                       // next_state=HUNDRED; //
                    else
                       next_state=SIXTY; 
 			 SEVENTY:if(ten)
			           next_state=EIGHTY;
					else if(twenty)
                       next_state=NINETY;
                    // else if(fifty)
                       // next_state=HUNDRED;//
                    else
                       next_state=SEVENTY;  
					   
 			 EIGHTY:   next_state=IDLE;
			 NINETY:   next_state=IDLE;
			 HUNDRED:  next_state=IDLE;
			 default:  next_state=IDLE;			 
		 endcase		
	 end
				 
	  
	  always@(*)
	     if(state==HUNDRED)begin
		     out=1'b1;
			 charge=2'b11;
		 end
		 else if(state==NINETY)begin
		     out=1'b1;
			 charge=2'b01;
		 end
		 else if(state==EIGHTY)begin
		     out=1'b1;
			 charge=2'b00;
		 end
		 else begin
		     out=1'b0;
			 charge=2'b00;
		 end            
	  

endmodule