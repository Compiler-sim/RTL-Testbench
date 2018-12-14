module Control_state #(
   parameter INPUT_SIZE=26,
   parameter UNITS_NUM=5,
   parameter ALL_CELL_NUM=30,
   parameter TIME_STEP=148
)(
   input           clk              , 
   input           rst_n            ,
   input           d_ready          ,
   input           x_in_valid       ,
   input           c_o_valid        ,
   input           LSTM_o_valid     ,

   output          get_x_en         ,  
   output          get_preh_en      ,
   output          one_timestep_over,
   output reg [7:0]addr_x           ,
   output reg [7:0]addr_preh        ,
   output reg [7:0]units_cnt        ,
   output reg [7:0]c_addr           ,
   output reg [7:0]xw_addr          ,
   output reg [7:0]hw_addr          , 
   output reg [7:0]addr_h           ,
   output reg [7:0]b_addr           ,
   output reg      h_mem_sel        ,
   output          w_x_en           ,
   output          h_to_full_en     ,
   output reg [7:0]    to_full_h_addr   ,
   output          prst             
);                                   

localparam IDLE              = 4'b0000;
localparam GET_X_IN          = 4'b0001;
localparam GET_X             = 4'b1011;
localparam GET_H             = 4'b0011;
localparam UNITS_OVER        = 4'b1111;
localparam WAIT_H            = 4'b1010;
localparam ALL_UNITS_OVER    = 4'b0111;
localparam ONE_TIMESTEP_OVER = 4'b0110;
localparam ALL_TIMESTEP_OVER = 4'b0100;
localparam TO_FULL           = 4'b1100;
localparam RESET_HC          = 4'b1101;
localparam WAIT_ACT          = 4'b1110;
reg [3:0] state;
//reg [7:0] addr_x;
//reg [7:0] addr_h;
//reg [7:0] units_cnt;
wire units_over  ;
reg [7:0] time_step_count;
//wire one_timestep_over;
reg [8:0] WAIT_cnt;

always @( posedge clk )
  if(!rst_n)
    WAIT_cnt <= 'h0;
  else if( x_in_valid || get_preh_en || get_x_en || (state==WAIT_ACT) )
    WAIT_cnt <= WAIT_cnt+1'b1;
  else if( units_over )
    WAIT_cnt <= 'h0;

wire get_x_over;

always @( posedge clk  )
  if( !rst_n )
    state <= IDLE;
  else
      case( state )
      IDLE:     begin
              if( d_ready )
                state <= GET_X_IN;
                end
      GET_X_IN: begin
              if( get_x_over )
                state <= GET_H;
            end
      GET_X  : begin
              if( addr_x==INPUT_SIZE-1 )
               state <= GET_H;
            end
      GET_H   : begin
              if( addr_preh == ALL_CELL_NUM-1) 
               state <= WAIT_ACT;
                end
      WAIT_ACT: begin
                if( WAIT_cnt == 'd300 )
                  state <= UNITS_OVER;
                end
      UNITS_OVER : begin
                if( units_cnt == ALL_CELL_NUM-UNITS_NUM)
                  state <= WAIT_H;
	              else 
		              state <= GET_X;
              end
      WAIT_H :begin
                if( units_cnt == addr_h )
		  state <= ONE_TIMESTEP_OVER;
              end
      ONE_TIMESTEP_OVER: begin
                if( time_step_count == TIME_STEP-1 )
		  state <= TO_FULL;
	        else
		  state <= GET_X_IN;	
              end
      TO_FULL   : begin
                if( to_full_h_addr == ALL_CELL_NUM-1 )
                  state <= RESET_HC;
              end
      RESET_HC : begin
                state <= IDLE;
              end
      default : state <= IDLE;
      endcase

//wire get_x_en;
//wire get_h_en;
//wire soft_rst;

assign get_x_en = (state==GET_X)? 1'b1:1'b0;
assign get_preh_en = (state==GET_H)? 1'b1:1'b0;
assign h_to_full_en = (state==TO_FULL)? 1'b1:1'b0;
assign prst     = (state==RESET_HC) ? 1'b1:1'b0;
assign get_x_over = ((addr_x==INPUT_SIZE-1)&&(x_in_valid))? 1'b1:1'b0;
assign w_x_en = ( state == GET_X_IN ) ? 1'b1:1'b0;
assign units_over = (state == UNITS_OVER) ? 1'b1:1'b0;
assign one_timestep_over = ( state == ONE_TIMESTEP_OVER ) ? 1'b1:1'b0;

always @( posedge clk )
  if( !rst_n )
    addr_x <= 8'h00;
  else if( (x_in_valid || get_x_en) && ( addr_x!=INPUT_SIZE-1 ) )
    addr_x <= addr_x+1'b1;
  else if( units_over )
    addr_x <= 8'h00;      

always @( posedge clk )
  if( !rst_n )
    xw_addr <= 'h00;
  else if( (x_in_valid || get_x_en) && ( xw_addr!=INPUT_SIZE*(ALL_CELL_NUM/UNITS_NUM)-1 ) )
    xw_addr <= xw_addr+1'b1;
  else if( one_timestep_over )
    xw_addr <= 'h00;

always @( posedge clk )
  if( !rst_n )
    hw_addr <= 'h00;
  else if( get_preh_en  && ( hw_addr!=ALL_CELL_NUM*(ALL_CELL_NUM/UNITS_NUM)-1 ))
    hw_addr <= hw_addr+1'b1;
  else if( one_timestep_over )
    hw_addr <= 'h00;

always @( posedge clk )
  if( !rst_n )
    addr_preh <= 'h00;
  else if( get_preh_en && (addr_preh!=ALL_CELL_NUM-1))
    addr_preh <= addr_preh+1'b1;
  else 
    addr_preh <= 'h00;	   

always @( posedge clk )
  if( !rst_n )
    addr_h <= 'h00;
  else if( LSTM_o_valid )
    addr_h <= addr_h+UNITS_NUM;
  else if( one_timestep_over )
    addr_h <= 'h00;	    

always @( posedge clk )
  if( !rst_n )
    units_cnt <= 'h00;
  else if( units_over )
    units_cnt <= units_cnt+UNITS_NUM;
  else if( one_timestep_over )
    units_cnt <= 'h00;

always @( posedge clk )
  if( !rst_n )
    b_addr <= 'h00;
  else if( units_over && (b_addr!=ALL_CELL_NUM/UNITS_NUM-1) )
    b_addr <= b_addr+1'b1;
  else if( one_timestep_over )
    b_addr <= 'h00;
//reg [7:0] time_step_count;
always @( posedge clk )
  if( !rst_n )
    time_step_count <= 8'h00;
  else if( one_timestep_over )
    time_step_count <= time_step_count + 1'b1;
  else if( h_to_full_en )
    time_step_count <= 8'b00;

always @( posedge clk )
  if( !rst_n )
    to_full_h_addr <= 8'h00;
  else if( h_to_full_en )
    to_full_h_addr <= to_full_h_addr+1'b1;
  else
    to_full_h_addr <= 8'h00;

always @( posedge clk  )
  if( !rst_n )
    h_mem_sel <= 1'b0;
  else if( one_timestep_over )
    h_mem_sel <= ~h_mem_sel;	  
//assign LSTM_LAST_o_valid = ( time_step_count == TIME_STEP ) ? 1'b1:1'b0;

always @( posedge clk )
  if( !rst_n ) 
    c_addr <= 'h00;
  else if( c_o_valid && c_addr!=ALL_CELL_NUM/UNITS_NUM-1)
    c_addr <= c_addr + 1'b1;
  else if( one_timestep_over )
    c_addr <= 'h00;
  

endmodule				  
