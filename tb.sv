module tb();   
	logic clk, reset;
	logic [24:0] mem[63:0];	 
	logic [127:0] wb_alu_result; 
	logic [127:0] exe_alu_result;
	logic [4:0] reg1, reg2, reg3; 
	logic [15:0] immidiate;	
	logic mux_1, mux_2, mux_3, mux_4;
	logic[5:0] pc;	 
	logic[24:0] instruction;
	logic [127:0] r1_value, r2_value, r3_value;	 
	logic [4:0] wb_rd;	  
	logic [4:0] exe_rd;  
	logic [4:0] ID_rd;
	logic [2:0] index; 
	logic ID_wr_en, exe_wr_en, wb_wr_en; 
	
	parameter output_number	= 51;
	
	
	initial clk=0;	
    always #5 clk = ~clk; 
		
	top dut(clk, reset, mem, wb_alu_result, reg1, reg2, reg3, immidiate, mux_1, mux_2, mux_3, mux_4, pc, instruction, r1_value, r2_value, r3_value, wb_rd, exe_rd, index, ID_rd, ID_wr_en, exe_wr_en, wb_wr_en, exe_alu_result);		 
	
	logic [127:0] expected_result[output_number:0];	
	
	initial $readmemb("instruction.txt", mem);	
	initial $readmemb("expected_result.txt", expected_result); 	   
	 
	
	integer result_file;
	initial result_file=$fopen("result_file.txt","w");   
		
	initial begin
		#0 reset = 1;
		#6 reset = 	0;
	end
	
	logic [6:0] i; 
	initial i = 0;
	
	always @(posedge clk) begin
         i <= i+1;
   	end
	   
	always @* begin				
		if( i > output_number)
			$finish;
    end				  
	
	 always @(posedge clk) begin
		if(wb_alu_result !== expected_result[i])begin
			$display("ERROR: y[%b] = %b     expected output = %b" , i, wb_alu_result, expected_result[i]);   
		end
    end	
	
	always @(posedge clk) begin	
		$fdisplay(result_file, "at %d's rising edge: ", i);
		$fdisplay(result_file, "	IF: ");
		$fdisplay(result_file, "		pc = %b", pc);	  
		$fdisplay(result_file, "		instruction = %b", instruction);
		$fdisplay(result_file, "	ID: ");
		$fdisplay(result_file, "		reg1 = %b", reg1); 
		$fdisplay(result_file, "		reg2 = %b", reg2);
		$fdisplay(result_file, "		reg3 = %b", reg3);	
		$fdisplay(result_file, "		ID_rd = %b", ID_rd);
		$fdisplay(result_file, "		r1_value = %b", r1_value); 
		$fdisplay(result_file, "		r2_value = %b", r2_value);
		$fdisplay(result_file, "		r3_value = %b", r3_value);
		$fdisplay(result_file, "		immidiate = %b", immidiate);   
		$fdisplay(result_file, "		index = %b", index);  
		$fdisplay(result_file, "		ID_wr_en = %b", ID_wr_en);
		$fdisplay(result_file, "	EXE: ");
		$fdisplay(result_file, "		mux_1 = %b", mux_1); 
		$fdisplay(result_file, "		mux_2 = %b", mux_2);
		$fdisplay(result_file, "		mux_3 = %b", mux_3);
		$fdisplay(result_file, "		mux_4 = %b", mux_4); 
		$fdisplay(result_file, "		exe_rd = %b", exe_rd); 
		$fdisplay(result_file, "		exe_wr_en = %b", exe_wr_en); 
		$fdisplay(result_file, "		exe_alu_result = %b", exe_alu_result);
		$fdisplay(result_file, "	WB: ");
		$fdisplay(result_file, "		wb_alu_result = %b", wb_alu_result);  
		$fdisplay(result_file, "		wb_rd = %b", wb_rd);  
		$fdisplay(result_file, "		wb_wr_en = %b", wb_wr_en);
		
		
    end	
	   
endmodule
	