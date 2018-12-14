`timescale 1ns / 1ns
module tb_top1;

parameter INPUT_SIZE  = 26 ;
parameter ALL_CELL_NUM= 30 ;
parameter TIME_STEP   = 148;
parameter UNITS_NUM   = 5  ;
parameter D_WL        = 24 ;
parameter FL          = 14 ;
parameter num_mfcc=3848;
logic            clk         ;
logic            rst_n       ;
logic            f_in_valid  ;
logic [D_WL-1:0] feature_in  ;
logic            w_x_en      ;
logic            o_valid     ;
logic            result      ;



FULL_DESIGN #(
  .INPUT_SIZE   ( INPUT_SIZE  ),
  .ALL_CELL_NUM ( ALL_CELL_NUM),
  .TIME_STEP    ( TIME_STEP   ),
  .UNITS_NUM    ( UNITS_NUM   ),
  .D_WL         ( D_WL        ),
  .FL           ( FL          ) 
)FULL_DESIGN_INST(
    .clk         ( clk          ),
    .rst_n       ( rst_n        ),
    .f_in_valid  ( f_in_valid   ),
    .feature_in  ( feature_in   ),
                               
    .w_x_en      ( w_x_en       ), 
    .o_valid     ( o_valid      ),
    .result      ( result       ) 
);


always #25 clk=~clk;

initial begin

clk=0;
rst_n=0;
#200 rst_n=1;
mfcc_load(mffc_in);
LSTM_H_load(refrence_LSTM_H);
ref_gatei_load(reference_gatei);
end


reg [D_WL-1:0] mffc_in[0:num_mfcc-1];

task mfcc_load(output   [D_WL-1:0] mffc_in[0:num_mfcc-1]);
 parameter audio_file_name= "C:/Users/10903/Desktop/HELLO_DD1/Data/gold_data/mel_txt.txt";
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
 mfcc_file=$fopen("mfcc_file.txt");
  foreach(mffc_in[a])
    $fdisplay(mfcc_file,"mffc_in[%0d]=%h",a,mffc_in[a]);
	
endtask


integer i_feature,j_feature;
integer feature_in_file;

 initial begin
feature_in_file=$fopen("feature_in.txt");
end


//激励
always @(posedge clk or negedge rst_n)begin
 if(!rst_n)begin
   i_feature=0;
   j_feature=0;
 end
 else if(i_feature<=num_mfcc-1)begin
     @(posedge w_x_en) begin     	
	   repeat(INPUT_SIZE)@(posedge clk)begin
	     feature_in<=mffc_in[j_feature];
	     f_in_valid<=1;
		 $fdisplay(feature_in_file,"%h<=mffc_in[%0d]",mffc_in[j_feature],j_feature);
		 j_feature=j_feature+1;
	  end
       i_feature=i_feature+1;
	 end
     @(negedge w_x_en)
     begin
       feature_in<=0;
	   f_in_valid<=0;
     end
	
  end	 
  else begin
       feature_in<=0;
	   f_in_valid<=0;
  end
       
 
end

 

//refrence_LSTM_H_LOAD

reg [D_WL-1:0] refrence_LSTM_H[0:ALL_CELL_NUM*TIME_STEP-1];

task LSTM_H_load(output  [D_WL-1:0] refrence_LSTM_H[0:ALL_CELL_NUM*TIME_STEP-1] );

integer h_r_time_step;
integer i_refrence_H;
i_refrence_H=0;
for(h_r_time_step=1;h_r_time_step<=TIME_STEP;h_r_time_step++) begin  //修改
      $sformat(refrence_LSTM_H_FILE,"gold_data/h_%0d.txt",h_r_time_step);
	  $readmemh(refrence_LSTM_H_FILE,refrence_LSTM_H,i_refrence_H,i_refrence_H+29);
	  i_refrence_H=i_refrence_H+30;
 
 end	 


endtask


//reference_gatei_load

reg [30*8:0] reference_gatei_FILE;
reg [D_WL-1:0] reference_gatei [0:ALL_CELL_NUM*TIME_STEP-1];

task ref_gatei_load(output [D_WL-1:0] reference_gatei [0: ALL_CELL_NUM*TIME_STEP-1] );

integer ref_gatei_time_step;
integer i_reference_gatei;
i_reference_gatei=0;
for(ref_gatei_time_step=1;ref_gatei_time_step<=TIME_STEP;ref_gatei_time_step++)begin
       $sformat(reference_gatei_FILE,"gold_data/gatei_%0d_c.txt",ref_gatei_time_step);
	   $readmemh(reference_gatei_FILE,reference_gatei,i_reference_gatei,i_reference_gatei+29);
	   i_reference_gatei=i_reference_gatei+30;
end

endtask


 
//monitor_H；
 
integer RTL_LSTM_FILE;

reg [40*8:0] RTL_LSTM_NAME;
reg [D_WL-1:0] RTL_LSTM_H[0:ALL_CELL_NUM-1][0:TIME_STEP-1];

integer h_time_step;

reg [30*8:0] refrence_LSTM_H_FILE;

integer H_chec_log;
integer i_RTL_H;

 initial begin
 h_time_step=1;
 forever begin
 //@(posedge FULL_DESIGN_INST.LSTM_INST.Control_inst.one_timestep_over)
 @(posedge FULL_DESIGN_INST.LSTM_INST.Control_inst.one_timestep_over)
  begin
  if (FULL_DESIGN_INST.LSTM_INST.Control_inst.one_timestep_over)begin
    $sformat(RTL_LSTM_NAME,"out/RTL_LSTM_H/RTL_LSTM_H%0d.txt",h_time_step);
	RTL_LSTM_FILE=$fopen(RTL_LSTM_NAME);
   for(i_RTL_H=0;i_RTL_H<=ALL_CELL_NUM-1;i_RTL_H++)begin
     if(!FULL_DESIGN_INST.LSTM_INST.Control_inst.h_mem_sel)begin
        RTL_LSTM_H[i_RTL_H][h_time_step-1]=FULL_DESIGN_INST.LSTM_INST.H_buffer_1.mem[i_RTL_H];
		$fwrite(RTL_LSTM_FILE,"%h",FULL_DESIGN_INST.LSTM_INST.H_buffer_1.mem[i_RTL_H]);
		$fwrite(RTL_LSTM_FILE,"\n");
		end
     else begin
	    RTL_LSTM_H[i_RTL_H][h_time_step-1]=FULL_DESIGN_INST.LSTM_INST.H_buffer_2.mem[i_RTL_H];		
        $fwrite(RTL_LSTM_FILE,"%h",FULL_DESIGN_INST.LSTM_INST.H_buffer_2.mem[i_RTL_H]);
		$fwrite(RTL_LSTM_FILE,"\n");
		end	
    end
	h_time_step=h_time_step+1;
	
	if(h_time_step==148)begin
	
	 //$finish;
	end
	$fclose(RTL_LSTM_FILE);
	end
 end
end
end 

//monitor_gatei；

reg [D_WL-1:0] RTL_GATE_I [0:TIME_STEP*ALL_CELL_NUM-1];
integer RTL_GATE_I_INDEX;
integer gatei_time_step; 
reg[40*8:0] RTL_GATEI_NAME;
integer RTL_GATE_FILE;
integer i_RTL_GATE_I;

 initial begin
    RTL_GATE_I_INDEX=0;
    forever begin	
	  for(gatei_time_step=1;gatei_time_step<=TIME_STEP;gatei_time_step++)begin
	      $sformat(RTL_GATEI_NAME,"out/RTL_gatei/RTL_GATEI_%0d.txt",gatei_time_step);
	      RTL_GATE_FILE=$fopen(RTL_GATEI_NAME);
	      repeat(6)@(posedge FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[4].LSTM_CELL_INST.gate_i.o_valid)begin
	       for(i_RTL_GATE_I=0;i_RTL_GATE_I<=UNITS_NUM-1;i_RTL_GATE_I++)begin
		       if(i_RTL_GATE_I==0)begin
	         RTL_GATE_I[RTL_GATE_I_INDEX] = FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[0].LSTM_CELL_INST.gate_i.d_o; 
	         $fwrite(RTL_GATE_FILE,"%h",FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[0].LSTM_CELL_INST.gate_i.d_o);
			 $fwrite(RTL_LSTM_FILE,"\n");
			 RTL_GATE_I_INDEX=RTL_GATE_I_INDEX+1;
			 end
			   if(i_RTL_GATE_I==1)begin
	         RTL_GATE_I[RTL_GATE_I_INDEX] = FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[1].LSTM_CELL_INST.gate_i.d_o; 
	         $fwrite(RTL_GATE_FILE,"%h",FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[1].LSTM_CELL_INST.gate_i.d_o);
			 $fwrite(RTL_LSTM_FILE,"\n");
			 RTL_GATE_I_INDEX=RTL_GATE_I_INDEX+1;
			 end
			   if(i_RTL_GATE_I==2)begin
	         RTL_GATE_I[RTL_GATE_I_INDEX] = FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[2].LSTM_CELL_INST.gate_i.d_o; 
	         $fwrite(RTL_GATE_FILE,"%h",FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[2].LSTM_CELL_INST.gate_i.d_o);
			 $fwrite(RTL_LSTM_FILE,"\n");
			 RTL_GATE_I_INDEX=RTL_GATE_I_INDEX+1;
			 end
			   if(i_RTL_GATE_I==3)begin
	         RTL_GATE_I[RTL_GATE_I_INDEX] = FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[3].LSTM_CELL_INST.gate_i.d_o; 
	         $fwrite(RTL_GATE_FILE,"%h",FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[3].LSTM_CELL_INST.gate_i.d_o);
			 $fwrite(RTL_LSTM_FILE,"\n");
			 RTL_GATE_I_INDEX=RTL_GATE_I_INDEX+1;
			 end
			   if(i_RTL_GATE_I==4)begin
	         RTL_GATE_I[RTL_GATE_I_INDEX] = FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[4].LSTM_CELL_INST.gate_i.d_o; 
	         $fwrite(RTL_GATE_FILE,"%h",FULL_DESIGN_INST.LSTM_INST.LSTM_LAYER_INST.LSTM_CELL[4].LSTM_CELL_INST.gate_i.d_o);
			 $fwrite(RTL_LSTM_FILE,"\n");
			 RTL_GATE_I_INDEX=RTL_GATE_I_INDEX+1;
			 end
	       end
	      end
	      $fclose(RTL_GATE_FILE);
	  end
	end
 
 end


//check_H

integer j_end;
integer i_end;
integer ref_H_index;
initial begin

 ref_H_index=0;

end

  always @(posedge clk)begin
 @(posedge o_valid)
    H_chec_log=$fopen("out/check_log/H_chec_log.txt");
   for(j_end=0;j_end<=TIME_STEP-1;j_end++)begin  	    
      for(i_end=0;i_end<=ALL_CELL_NUM-1;i_end++)begin
	      //if(RTL_LSTM_H[i_end][j_end]!==refrence_LSTM_H[ref_H_index])begin
		   if(RTL_LSTM_H[i_end][j_end][23:11]!==refrence_LSTM_H[ref_H_index][23:11])begin
		     $display("timestep %0d,cell %0d id is error, RTL_LSTM_H is %h,refrence_LSTM_H is %h",j_end,i_end,RTL_LSTM_H[i_end][j_end],refrence_LSTM_H[ref_H_index]);
		    $fdisplay(H_chec_log,"timestep %0d,cell %0d is error, RTL_LSTM_H is %h,refrence_LSTM_H is %h",j_end,i_end,RTL_LSTM_H[i_end][j_end],refrence_LSTM_H[ref_H_index]);
          end
		  ref_H_index=ref_H_index+1;
	  end
   end
   $fclose(H_chec_log);
 
end  
 
//check_gate_i
integer i_chec_gate_i;
integer gate_i_timestep;
integer gate_i_cell;
integer gate_i_chec_log;

initial begin
;
end

 always @(posedge clk)begin
 @(posedge o_valid)
   gate_i_chec_log=$fopen("out/check_log/gate_i_chec_log.txt");
   for(i_chec_gate_i=0;i_chec_gate_i<=TIME_STEP*ALL_CELL_NUM-1;i_chec_gate_i++)begin
      gate_i_timestep=i_chec_gate_i/TIME_STEP;
	  gate_i_cell=i_chec_gate_i%TIME_STEP+1;	  
      if(RTL_GATE_I[i_chec_gate_i]!=reference_gatei[i_chec_gate_i])
	    $fdisplay(gate_i_chec_log,"timestep %d,cell %0d is error,RTL_GATE_I is %h,reference_gatei is %h",gate_i_timestep,gate_i_cell,RTL_GATE_I[i_chec_gate_i],reference_gatei[i_chec_gate_i]);
   end
   $fclose(gate_i_chec_log);
 end


 always @(posedge clk)begin
  @(posedge o_valid)
     begin
     repeat(10) @(posedge clk)
	 $finish;
	 //;
     end
 end
 
 initial 
    begin
      $wlfdumpvars();//保存所有的波形
    end

endmodule





