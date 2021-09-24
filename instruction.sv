module top(clk, reset, mem, wb_alu_result,reg1, reg2, reg3, immidiate, mux_1, mux_2, mux_3, mux_4, pc, instruction, r1_value, r2_value, r3_value, wb_rd, exe_rd, index, ID_rd, ID_wr_en, exe_wr_en, wb_wr_en, exe_alu_result);	
	input logic clk, reset;	   
	output logic[5:0] pc;
	output logic[24:0] instruction; 
	output logic [127:0] r1_value, r2_value, r3_value;
	logic [127:0] rd_value;
	output logic [4:0] reg1, reg2, reg3;			 
	output logic [4:0] ID_rd; 
	output logic [15:0] immidiate; 
	logic [4:0] alu_control;	   
	output logic [2:0] index;	 
	output logic mux_1, mux_2, mux_3, mux_4;
	output logic ID_wr_en, exe_wr_en, wb_wr_en; 
	output logic [4:0] exe_rd; 
	output logic [4:0] wb_rd; 
	output logic [127:0] wb_alu_result;   
	output logic [127:0] exe_alu_result; 
	input logic [24:0] mem[63:0];
	always_comb begin 
		if( alu_control == 0) begin
			mux_1 = 0;
			mux_2 = 0;
			mux_3 = 0;
			if( ID_rd == wb_rd)
				mux_4 = 1;
			else
				mux_4 = 0;
		end	
		else begin
			if(reg1 == wb_rd)
				mux_1 = 1;
			else
				mux_1 = 0;
				
			if(reg2 == wb_rd)
				mux_2 = 1;
			else
				mux_2 = 0;
			
			if(reg3 == wb_rd)
				mux_3 = 1;
			else
				mux_3 = 0;
				
			mux_4 = 0;
		end
	end
	
	w_b write_back(clk, exe_rd, wb_rd, exe_wr_en, wb_wr_en, wb_alu_result, exe_alu_result);
	ins_buffer IF(instruction, clk, reset, mem, pc);	
	ins_decoder ID(clk, wb_wr_en, instruction, wb_rd, wb_alu_result, r1_value, r2_value, r3_value, rd_value, ID_rd, ID_wr_en, alu_control, index, immidiate, reg1, reg2, reg3); 
	multimedia_ALU exe(clk, ID_wr_en, alu_control, r1_value, r2_value, r3_value, rd_value, wb_alu_result, exe_alu_result, immidiate, index, exe_wr_en, ID_rd, exe_rd, mux_1, mux_2, mux_3, mux_4, reg1, reg2, reg3);		
	
endmodule 

module w_b(clk, exe_rd, wb_rd, exe_wr_en, wb_wr_en, wb_alu_result, exe_alu_result);
	input logic clk, exe_wr_en;
	input logic [4:0] exe_rd;
	input logic [127:0] exe_alu_result;
	output logic [4:0] wb_rd;
	output logic wb_wr_en; 
	output logic [127:0] wb_alu_result;
	always_comb begin
		wb_rd = exe_rd;
		wb_wr_en = exe_wr_en;
		wb_alu_result = exe_alu_result;
	end
		
endmodule


module multimedia_ALU(clk, ID_wr_en, alu_control, r1_value, r2_value, r3_value, rd_value, wb_alu_result, exe_alu_result, imm, index, exe_wr_en, ID_rd, exe_rd, mux_1, mux_2, mux_3, mux_4, reg1, reg2, reg3);	
	input logic clk, ID_wr_en;	
	input logic mux_1, mux_2, mux_3, mux_4;
	input logic [127:0] r1_value, r2_value, r3_value, wb_alu_result, rd_value; 
	input logic [4:0] reg1, reg2, reg3;
	logic [127:0] rs1, rs2, rs3, t_rd_value;
	input logic [15:0] imm;	  
	input logic [2:0] index;
	input logic [4:0] alu_control;	
	input logic	[4:0] ID_rd;
	output logic [4:0] exe_rd;
	logic [127:0] rd; 
	output logic [127:0] exe_alu_result;
	output logic exe_wr_en;
	logic [127:0] temp;		
	logic [31:0] count_1, count_2, count_3, count_4;  
	logic hold;
	logic [2:0] test;	 	
	
	always_comb begin
		if(mux_1 == 0)
			rs1 = r1_value;
		else
			rs1 = wb_alu_result; 
		
		if(mux_2 == 0) begin
			rs2 = r2_value;
			//test = 1;		
		end
		else begin
			rs2 = wb_alu_result; 
			//test = 0;
		end
		
		if(mux_3 == 0)
			rs3 = r3_value;
		else
			rs3 = wb_alu_result; 
			
		if(mux_4 == 1)
			t_rd_value = wb_alu_result;
		else
			t_rd_value = rd_value;
			
	end
		
	
			always_comb begin
				if(alu_control == 0)begin
					if(index == 0) begin
						temp = t_rd_value;
						temp[15:0] = imm;
						rd = temp;
					//	test <= 0;
					end
					else if(index == 1)  begin
						temp = t_rd_value;
						temp[31:16] = imm;
						rd = temp;
						//test <= 0;
					end
					else if(index == 2)  begin
						temp = t_rd_value;
						temp[47:32] = imm;
						rd = temp;
					//	test <= 0;
					end
					else if(index == 3)  begin
						temp = t_rd_value;
						temp[63:48] = imm;
						rd = temp;
					//	test <= 0;
					end
					else if(index == 4)  begin
						temp = t_rd_value;
						temp[79:64] = imm;
						rd = temp;
						//test <= 0;
					end
					else if(index == 5)  begin
						temp = t_rd_value;
						temp[95:80] = imm;
						rd = temp;
						//test <= 0;
					end	
					else if(index == 6)  begin
						temp = t_rd_value;
						temp[111:96] = imm;
						rd = temp;
						//test <= 0;
					end
					else if(index == 7)  begin
						temp = t_rd_value;
						temp[127:112] = imm;
						rd = temp;
						//test <= 0;
					end
				end
				else if(alu_control == 1) begin
						//31:0
						temp[31:0] = $signed(rs3[15:0]) * $signed(rs2[15:0]);
						rd[31:0] = $signed(temp[31:0]) + $signed(rs1[31:0]);
						if((temp[31] == 1) && (rs1[31] == 1) && (rd[31] == 0))
		             	 	rd[31:0] = 32'sb10000000000000000000000000000000;
		         		else if((temp[31] == 0) && (rs1[31] == 0) && (rd[31] == 1))
		            		rd[31:0] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[31:0] = $signed(rd[31:0]); 
						//63:32	 
						temp[63:32] = $signed(rs3[47:32]) * $signed(rs2[47:32]);
						rd[63:32] = $signed(temp[63:32]) + $signed(rs1[63:32]);	
						if((temp[63] == 1) && (rs1[63] == 1) && (rd[63] == 0))
		             	 	rd[63:32] = 32'sb10000000000000000000000000000000;
		         		else if((temp[63] == 0) && (rs1[63] == 0) && (rd[63] == 1))
		            		rd[63:32] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[63:32] = $signed(rd[63:32]); 
						//95:64 		 
						temp[95:64] = $signed(rs3[79:64]) * $signed(rs2[79:64]);
						rd[95:64] = $signed(temp[95:64]) + $signed(rs1[95:64]);	
						if((temp[95] == 1) && (rs1[95] == 1) && (rd[95] == 0))
		             	 	rd[95:64] = 32'sb10000000000000000000000000000000;
		         		else if((temp[95] == 0) && (rs1[95] == 0) && (rd[95] == 1))
		            		rd[95:64] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[95:64] = $signed(rd[95:64]);	
						//127:96	 
						temp[127:96] = $signed(rs3[111:96]) * $signed(rs2[111:96]);
						rd[127:96] = $signed(temp[127:96]) + $signed(rs1[127:96]);	
						if((temp[127] == 1) && (rs1[127] == 1) && (rd[127] == 0))
		             	 	rd[127:96] = 32'sb10000000000000000000000000000000;
		         		else if((temp[127] == 0) && (rs1[127] == 0) && (rd[127] == 1))
		            		rd[127:96] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[127:96] = $signed(rd[127:96]); 
				end			
				else if(alu_control == 2) begin
						//31:0
						temp[31:0] = $signed(rs3[31:16]) * $signed(rs2[31:16]);
						rd[31:0] = $signed(temp[31:0]) + $signed(rs1[31:0]);
						if((temp[31] == 1) && (rs1[31] == 1) && (rd[31] == 0))
		             	 	rd[31:0] = 32'sb10000000000000000000000000000000;
		         		else if((temp[31] == 0) && (rs1[31] == 0) && (rd[31] == 1))
		            		rd[31:0] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[31:0] = $signed(rd[31:0]); 
						//63:32	 
						temp[63:32] = $signed(rs3[63:48]) * $signed(rs2[63:48]);
						rd[63:32] = $signed(temp[63:32]) + $signed(rs1[63:32]);	
						if((temp[63] == 1) && (rs1[63] == 1) && (rd[63] == 0))
		             	 	rd[63:32] = 32'sb10000000000000000000000000000000;
		         		else if((temp[63] == 0) && (rs1[63] == 0) && (rd[63] == 1))
		            		rd[63:32] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[63:32] = $signed(rd[63:32]); 
						//95:64 		 
						temp[95:64] = $signed(rs3[95:80]) * $signed(rs2[95:80]);
						rd[95:64] = $signed(temp[95:64]) + $signed(rs1[95:64]);	
						if((temp[31] == 1) && (rs1[95] == 1) && (rd[95] == 0))
		             	 	rd[95:64] = 32'sb10000000000000000000000000000000;
		         		else if((temp[95] == 0) && (rs1[95] == 0) && (rd[95] == 1))
		            		rd[95:64] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[95:64] = $signed(rd[95:64]);	
						//127:96	 
						temp[127:96] = $signed(rs3[127:112]) * $signed(rs2[127:112]);
						rd[127:96] = $signed(temp[127:96]) + $signed(rs1[127:96]);	
						if((temp[31] == 1) && (rs1[127] == 1) && (rd[127] == 0))
		             	 	rd[127:96] = 32'sb10000000000000000000000000000000;
		         		else if((temp[127] == 0) && (rs1[127] == 0) && (rd[127] == 1))
		            		rd[127:96] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[127:96] = $signed(rd[127:96]);   
				end
				else if(alu_control == 3) begin	
						//test = 1;
						//31:0
						temp[31:0] = $signed(rs3[15:0]) * $signed(rs2[15:0]);	 
						rd[31:0] = $signed(rs1[31:0]) - $signed(temp[31:0]);
						if((rs1[31] == 1) && (temp[31] == 0) && (rd[31] == 0))
		             	 	rd[31:0] = 32'sb10000000000000000000000000000000;
		         		else if((rs1[31] == 0) && (temp[31] == 1) && (rd[31] == 1))
		            		rd[31:0] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[31:0] = $signed(rd[31:0]); 
						//63:32	 
						temp[63:32] = $signed(rs3[47:32]) * $signed(rs2[47:32]);
						rd[63:32] = $signed(rs1[63:32]) - $signed(temp[63:32]);	
						if((rs1[63] == 1) && (temp[63] == 0) && (rd[63] == 0))
		             	 	rd[63:32] = 32'sb10000000000000000000000000000000;
		         		else if((rs1[63] == 0) && (temp[63] == 1) && (rd[63] == 1))
		            		rd[63:32] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[63:32] = $signed(rd[63:32]); 
						//95:64 		 
						temp[95:64] = $signed(rs3[79:64]) * $signed(rs2[79:64]);
						rd[95:64] = $signed(rs1[95:64]) - $signed(temp[95:64]);	
						if((rs1[95] == 1) && (temp[95] == 0) && (rd[95] == 0))
		             	 	rd[95:64] = 32'sb10000000000000000000000000000000;
		         		else if((rs1[95] == 0) && (temp[95] == 1) && (rd[95] == 1))
		            		rd[95:64] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[95:64] = $signed(rd[95:64]);	
						//127:96	 
						temp[127:96] = $signed(rs3[111:96]) * $signed(rs2[111:96]);
						rd[127:96] = $signed(rs1[127:96]) - $signed(temp[127:96]);	
						if((rs1[127] == 1) && (temp[127] == 0) && (rd[127] == 0))
		             	 	rd[127:96] = 32'sb10000000000000000000000000000000;
		         		else if((rs1[127] == 0) && (temp[127] == 1) && (rd[127] == 1))
		            		rd[127:96] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[127:96] = $signed(rd[127:96]); 	   
				end			
				else if(alu_control == 4) begin 
						//31:0
						temp[31:0] = $signed(rs3[31:16]) * $signed(rs2[31:16]);
						rd[31:0] = $signed(rs1[31:0]) - $signed(temp[31:0]);
						if((rs1[31] == 1) && (temp[31] == 0) && (rd[31] == 0))
		             	 	rd[31:0] = 32'sb10000000000000000000000000000000;
		         		else if((rs1[31] == 0) && (temp[31] == 1) && (rd[31] == 1))
		            		rd[31:0] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[31:0] = $signed(rd[31:0]); 
						//63:32	 
						temp[63:32] = $signed(rs3[63:48]) * $signed(rs2[63:48]);
						rd[63:32] = $signed(rs1[63:32]) - $signed(temp[63:32]);	
						if((rs1[63] == 1) && (temp[63] == 0) && (rd[63] == 0))
		             	 	rd[63:32] = 32'sb10000000000000000000000000000000;
		         		else if((rs1[63] == 0) && (rs1[63] == 1) && (rd[63] == 1))
		            		rd[63:32] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[63:32] = $signed(rd[63:32]); 
						//95:64 		 
						temp[95:64] = $signed(rs3[95:80]) * $signed(rs2[95:80]);
						rd[95:64] = $signed(rs1[95:64]) - $signed(temp[95:64]);	
						if((rs1[95] == 1) && (temp[95] == 0) && (rd[95] == 0))
		             	 	rd[95:64] = 32'sb10000000000000000000000000000000;
		         		else if((rs1[95] == 0) && (temp[95] == 1) && (rd[95] == 1))
		            		rd[95:64] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[95:64] = $signed(rd[95:64]);	
						//127:96	 
						temp[127:96] = $signed(rs3[127:112]) * $signed(rs2[127:112]);
						rd[127:96] = $signed(rs1[127:96]) - $signed(temp[127:96]);	
						if((rs1[127] == 1) && (temp[127] == 0) && (rd[127] == 0))
		             	 	rd[127:96] = 32'sb10000000000000000000000000000000;
		         		else if((rs1[127] == 0) && (rs1[127] == 1) && (rd[127] == 1))
		            		rd[127:96] = 32'sb01111111111111111111111111111111;
		         		else
		             		rd[127:96] = $signed(rd[127:96]);   
				end
				else if(alu_control == 5) begin
						//63:0
						temp[63:0] = $signed(rs3[31:0]) * $signed(rs2[31:0]);
						rd[63:0] = $signed(temp[63:0]) + $signed(rs1[63:0]);
						if((temp[63] == 1) && (rs1[63] == 1) && (rd[63] == 0))
		             	 	rd[63:0] = 64'sb1000000000000000000000000000000000000000000000000000000000000000;
		         		else if((temp[63] == 0) && (rs1[63] == 0) && (rd[63] == 1))
		            		rd[63:0] = 64'sb0111111111111111111111111111111111111111111111111111111111111111;
		         		else
		             		rd[63:0] = $signed(rd[63:0]); 
						//127:64	 
						temp[127:64] = $signed(rs3[95:64]) * $signed(rs2[95:64]);
						rd[127:64] = $signed(temp[127:64]) + $signed(rs1[127:64]);	
						if((temp[127] == 1) && (rs1[127] == 1) && (rd[127] == 0))
		             	 	rd[127:64] = 64'sb1000000000000000000000000000000000000000000000000000000000000000;
		         		else if((temp[127] == 0) && (rs1[127] == 0) && (rd[127] == 1))
		            		rd[127:64] = 64'sb0111111111111111111111111111111111111111111111111111111111111111;
		         		else
		             		rd[127:64] = $signed(rd[127:64]); 
				end	 
				else if(alu_control == 6) begin
						//63:0
						temp[63:0] = $signed(rs3[63:32]) * $signed(rs2[63:32]);
						rd[63:0] = $signed(temp[63:0]) + $signed(rs1[63:0]);
						if((temp[63] == 1) && (rs1[63] == 1) && (rd[63] == 0))
		             	 	rd[63:0] = 64'sb1000000000000000000000000000000000000000000000000000000000000000;
		         		else if((temp[63] == 0) && (rs1[63] == 0) && (rd[63] == 1))
		            		rd[63:0] = 64'sb0111111111111111111111111111111111111111111111111111111111111111;
		         		else
		             		rd[63:0] = $signed(rd[63:0]); 
						//127:64	 
						temp[127:64] = $signed(rs3[127:96]) * $signed(rs2[127:96]);
						rd[127:64] = $signed(temp[127:64]) + $signed(rs1[127:64]);	
						if((temp[127] == 1) && (rs1[127] == 1) && (rd[127] == 0))
		             	 	rd[127:64] = 64'sb1000000000000000000000000000000000000000000000000000000000000000;
		         		else if((temp[127] == 0) && (rs1[127] == 0) && (rd[127] == 1))
		            		rd[127:64] = 64'sb0111111111111111111111111111111111111111111111111111111111111111;
		         		else
		             		rd[127:64] = $signed(rd[127:64]); 
				end	 
				else if(alu_control == 7) begin
						//63:0
						temp[63:0] = $signed(rs3[31:0]) * $signed(rs2[31:0]);
						rd[63:0] = $signed(rs1[63:0]) - $signed(temp[63:0]);
						if((rs1[63] == 1) && (temp[63] == 0) && (rd[63] == 0))
		             	 	rd[63:0] = 64'sb1000000000000000000000000000000000000000000000000000000000000000;
		         		else if((rs1[63] == 0) && (temp[63] == 1) && (rd[63] == 1))
		            		rd[63:0] = 64'sb0111111111111111111111111111111111111111111111111111111111111111;
		         		else
		             		rd[63:0] = $signed(rd[63:0]); 
						//127:64	 
						temp[127:64] = $signed(rs3[95:64]) * $signed(rs2[95:64]);
						rd[127:64] = $signed(rs1[127:64]) - $signed(temp[127:64]);	
						if((rs1[127] == 1) && (temp[127] == 0) && (rd[127] == 0))
		             	 	rd[127:64] = 64'sb1000000000000000000000000000000000000000000000000000000000000000;
		         		else if((rs1[127] == 0) && (temp[127] == 1) && (rd[127] == 1))
		            		rd[127:64] = 64'sb0111111111111111111111111111111111111111111111111111111111111111;
		         		else
		             		rd[127:64] = $signed(rd[127:64]); 
				end
				else if(alu_control == 8) begin
						//63:0
						temp[63:0] = $signed(rs3[63:32]) * $signed(rs2[63:32]);
						rd[63:0] = $signed(rs1[63:0]) - $signed(temp[63:0]);
						if((rs1[63] == 1) && (temp[63] == 0) && (rd[63] == 0))
		             	 	rd[63:0] = 64'sb1000000000000000000000000000000000000000000000000000000000000000;
		         		else if((rs1[63] == 0) && (temp[63] == 1) && (rd[63] == 1))
		            		rd[63:0] = 64'sb0111111111111111111111111111111111111111111111111111111111111111;
		         		else
		             		rd[63:0] = rd[63:0]; 
						//127:64	 
						temp[127:64] = $signed(rs3[127:96]) * $signed(rs2[127:96]);
						rd[127:64] = $signed(rs1[127:64]) - $signed(temp[127:64]);	
						if((rs1[127] == 1) && (temp[127] == 0) && (rd[127] == 0))
		             	 	rd[127:64] = 64'sb1000000000000000000000000000000000000000000000000000000000000000;
		         		else if((rs1[127] == 0) && (temp[127] == 1) && (rd[127] == 1))
		            		rd[127:64] = 64'sb0111111111111111111111111111111111111111111111111111111111111111;
		         		else
		             		rd[127:64] = rd[127:64]; 
				end
				else if(alu_control == 9) begin
					rd = 0;					   
				end
				else if (alu_control == 10) begin	
						//test = 0;
						//31:0
						rd[31:0] = rs1[31:0] + rs2[31:0];
						//63:31
						rd[63:32] = rs1[63:32] + rs2[63:32];
						//95:64
						rd[95:64] = rs1[95:64] + rs2[95:64];
						//127:96
						rd[127:96] = rs1[127:96] + rs2[127:96];	 
				end
				else if (alu_control == 11) begin
						//7:0 
						if(rs1[7:0] > rs2[7:0])
							rd[7:0] = rs1[7:0] - rs2[7:0];
						else
							rd[7:0] = rs2[7:0] - rs1[7:0];
						//15:8
						if(rs1[15:8] > rs2[15:8])
							rd[15:8] = rs1[15:8] - rs2[15:8];
						else
							rd[15:8] = rs2[15:8] - rs1[15:8];
						//23:16
						if(rs1[23:16] > rs2[23:16])
							rd[23:16] = rs1[23:16] - rs2[23:16];
						else
							rd[23:16] = rs2[23:16] - rs1[23:16];;
						//31:24
						if(rs1[31:24] > rs2[31:24])
							rd[31:24] = rs1[31:24] - rs2[31:24];
						else
							rd[31:24] = rs2[31:24] - rs1[31:24];
						//39:32
						if(rs1[39:32] > rs2[39:32])
							rd[39:32] = rs1[39:32] - rs2[39:32];
						else
							rd[39:32] = rs2[39:32] - rs1[39:32];
						//47:40
						if(rs1[47:40] > rs2[47:40])
							rd[47:40] = rs1[47:40] - rs2[47:40];
						else
							rd[47:40] = rs2[47:40] - rs1[47:40];
						//55:48
						if(rs1[55:48] > rs2[55:48])
							rd[55:48] = rs1[55:48] - rs2[55:48];
						else
							rd[55:48] = rs2[55:48] - rs1[55:48];
						//63:56
						if(rs1[63:56] > rs2[63:56])
							rd[63:56] = rs1[63:56] - rs2[63:56];
						else
							rd[63:56] = rs2[63:56] - rs1[63:56];
						//71:64
						if(rs1[71:64] > rs2[71:64])
							rd[71:64] = rs1[71:64] - rs2[71:64];
						else
							rd[71:64] = rs2[71:64] - rs1[71:64];
						//79:72
						if(rs1[79:72] > rs2[79:72])
							rd[79:72] = rs1[79:72] - rs2[79:72];
						else
							rd[79:72] = rs2[79:72] - rs1[79:72];
						//87:80
						if(rs1[87:80] > rs2[87:80])
							rd[87:80] = rs1[87:80] - rs2[87:80];
						else
							rd[87:80] = rs2[87:80] - rs1[87:80];
						//95:88
						if(rs1[95:88] > rs2[95:88])
							rd[95:88] = rs1[95:88] - rs2[95:88];
						else
							rd[95:88] = rs2[95:88] - rs1[95:88];
						//103:96
						if(rs1[103:96] > rs2[103:96])
							rd[103:96] = rs1[103:96] - rs2[103:96];
						else
							rd[103:96] = rs2[103:96] - rs1[103:96];
						//111:104
						if(rs1[111:104] > rs2[111:104])
							rd[111:104] = rs1[111:104] - rs2[111:104];
						else
							rd[111:104] = rs2[111:104] - rs1[111:104];
						//119:112
						if(rs1[119:112] > rs2[119:112])
							rd[119:112] = rs1[119:112] - rs2[119:112];
						else
							rd[119:112] = rs2[119:112] - rs1[119:112];
						//127:120
						if(rs1[127:120] > rs2[127:120])
							rd[127:120] = rs1[127:120] - rs2[127:120];
						else
							rd[127:120] = rs2[127:120] - rs1[127:120];
				end
				else if (alu_control == 12) begin
						//15:0
						rd[15:0] = rs1[15:0] + rs2[15:0];
						//31:16
						rd[31:16] = rs1[31:16] + rs2[31:16];
						//47:32
						rd[47:32] = rs1[47:32] + rs2[47:32];
						//63:48
						rd[63:48] = rs1[63:48] + rs2[63:48];	
						//79:64
						rd[79:64] = rs1[79:64] + rs2[79:64];
						//95:80
						rd[95:80] = rs1[95:80] + rs2[95:80];
						//111:96
						rd[111:96] = rs1[111:96] + rs2[111:96];
						//127:112
						rd[127:112] = rs1[127:112] + rs2[127:112];	
				end
				else if (alu_control == 13) begin	
						//15:0
						rd[15:0] = $signed(rs1[15:0]) + $signed(rs2[15:0]);
						if((rs1[15] == 1) && (rs2[15] == 1) && (rd[15] == 0))
							rd[15:0] = 16'sb1000000000000000; 
						else if((rs1[15] == 0) && (rs2[15] == 0) && (rd[15] == 1))
							rd[15:0] = 16'sb0111111111111111; 
						else
							rd[15:0] = $signed(rd[15:0]);
						//31:16
						rd[31:16] = $signed(rs1[31:16]) + $signed(rs2[31:16]);
						if((rs1[31] == 1) && (rs2[31] == 1) && (rd[31] == 0))
							rd[31:16] = 16'sb1000000000000000; 
						else if((rs1[31] == 0) && (rs2[31] == 0) && (rd[31] == 1))
							rd[31:16] = 16'sb0111111111111111; 
						else
							rd[31:16] = $signed(rd[31:16]);
						//47:32
						rd[47:32] = $signed(rs1[47:32]) + $signed(rs2[47:32]);
						if((rs1[47] == 1) && (rs2[47] == 1) && (rd[47] == 0))
							rd[47:32] = 16'sb1000000000000000; 
						else if((rs1[47] == 0) && (rs2[47] == 0) && (rd[47] == 1))
							rd[47:32] = 16'sb0111111111111111; 
						else
							rd[47:32] = $signed(rd[47:32]);
						//63:48
						rd[63:48] = $signed(rs1[63:48]) + $signed(rs2[63:48]);
						if((rs1[63] == 1) && (rs2[63] == 1) && (rd[63] == 0))
							rd[63:48] = 16'sb1000000000000000; 
						else if((rs1[63] == 0) && (rs2[15] == 0) && (rd[15] == 1))
							rd[63:48] = 16'sb0111111111111111; 
						else
							rd[63:48] = $signed(rd[63:48]);
						//79:64
						rd[79:64] = $signed(rs1[79:64]) + $signed(rs2[79:64]);
						if((rs1[79] == 1) && (rs2[79] == 1) && (rd[79] == 0))
							rd[79:64] = 16'sb1000000000000000; 
						else if((rs1[79] == 0) && (rs2[79] == 0) && (rd[79] == 1))
							rd[79:64] = 16'sb0111111111111111; 
						else
							rd[79:64] = $signed(rd[79:64]);
						//95:80
						rd[95:80] = $signed(rs1[95:80]) + $signed(rs2[95:80]);
						if((rs1[95] == 1) && (rs2[95] == 1) && (rd[95] == 0))
							rd[95:80] = 16'sb1000000000000000; 
						else if((rs1[95] == 0) && (rs2[95] == 0) && (rd[95] == 1))
							rd[95:0] = 16'sb0111111111111111; 
						else
							rd[95:80] = $signed(rd[95:80]);
						//111:96
						rd[111:96] = $signed(rs1[111:96]) + $signed(rs2[111:96]);
						if((rs1[111] == 1) && (rs2[111] == 1) && (rd[111] == 0))
							rd[111:96] = 16'sb1000000000000000; 
						else if((rs1[111] == 0) && (rs2[111] == 0) && (rd[111] == 1))
							rd[111:96] = 16'sb0111111111111111; 
						else
							rd[111:96] = $signed(rd[111:96]);
						//127:112
						rd[127:112] = $signed(rs1[127:112]) + $signed(rs2[127:112]);
						if((rs1[127] == 1) && (rs2[127] == 1) && (rd[127] == 0))
							rd[127:112] = 16'sb1000000000000000; 
						else if((rs1[127] == 0) && (rs2[127] == 0) && (rd[127] == 1))
							rd[127:112] = 16'sb0111111111111111; 
						else
							rd[127:112] = $signed(rd[127:112]);
				end	
				else if (alu_control == 14) 
					rd = rs1 & rs2;
				else if (alu_control == 15) begin
						//31:0
						rd[31:0] = rs1[31:0];  
						//63:32
						rd[63:32] = rs1[31:0];
						//95:64
						rd[95:64] = rs1[31:0];
						//127:96
						rd[127:96] = rs1[31:0];
				end
				else if (alu_control == 16) begin
						//31:0
						if($signed(rs1[31:0]) > $signed(rs2[31:0]))
							rd[31:0] = $signed(rs1[31:0]);
						else
							rd[31:0] = $signed(rs2[31:0]);  
						//63:32
						if($signed(rs1[63:32]) > $signed(rs2[63:32]))
							rd[63:32] = $signed(rs1[63:32]);
						else
							rd[63:32] = $signed(rs2[63:32]);
						//95:64
						if($signed(rs1[95:64]) > $signed(rs2[95:64]))
							rd[95:64] = $signed(rs1[95:64]);
						else
							rd[95:64] = $signed(rs2[95:64]);
						//127:96
						if($signed(rs1[127:96]) > $signed(rs2[127:96]))
							rd[127:96] = $signed(rs1[127:96]);
						else
							rd[127:96] = $signed(rs2[127:96]);
				end
				else if (alu_control == 17) begin	
						//31:0
						if($signed(rs1[31:0]) < $signed(rs2[31:0]))
							rd[31:0] = $signed(rs1[31:0]);
						else
							rd[31:0] = $signed(rs2[31:0]);  
						//63:32
						if($signed(rs1[63:32]) < $signed(rs2[63:32]))
							rd[63:32] = $signed(rs1[63:32]);
						else
							rd[63:32] = $signed(rs2[63:32]);
						//95:64
						if($signed(rs1[95:64]) < $signed(rs2[95:64]))
							rd[95:64] = $signed(rs1[95:64]);
						else
							rd[95:64] = $signed(rs2[95:64]);
						//127:96
						if($signed(rs1[127:96]) < $signed(rs2[127:96]))
							rd[127:96] = $signed(rs1[127:96]);
						else
							rd[127:96] = $signed(rs2[127:96]);
				end
				else if (alu_control == 18) begin
						//31:0
						rd[31:0] = rs1[15:0] * rs2[15:0]; 
						//63:32
						rd[63:32] = rs1[47:32] * rs2[47:32];
						//95:64
						rd[95:64] = rs1[79:64] * rs2[79:64];
						//127:96
						rd[127:96] = rs1[111:96] * rs2[111:96];	 
				end
				else if (alu_control == 19) begin
						//31:0
						rd[31:0] = rs1[15:0] * imm[9:5]; 
						//63:32
						rd[63:32] = rs1[47:32] * imm[9:5];
						//95:64
						rd[95:64] = rs1[79:64] * imm[9:5];
						//127:96
						rd[127:96] = rs1[111:96] * imm[9:5];
				end
				else if (alu_control == 20) 
					rd = rs1 | rs2;
				else if (alu_control == 21) begin	
						//31:0 
						count_1 = 0;
						for(int i = 0; i < 32; i++) begin
							count_1 += rs1[i];
						end
						rd[31:0] = count_1;
						//63:32	
						count_2 = 0;
						for(int i = 32; i < 64; i++) begin
							count_2 += rs1[i];
						end
						rd[63:32] = count_2;	
						//95:64	
						count_3 = 0;
						for(int i = 64; i < 96; i++) begin
							count_3 += rs1[i];
						end
						rd[95:64] = count_3;
						//127:96	
						count_4 = 0;
						for(int i = 96; i < 128; i++) begin
							count_4 += rs1[i];							  					 	
						end
						rd[127:96] = count_4;
							
				end	
				else if (alu_control == 22) begin
						//31:0	
						temp[31:0] = rs1[31:0];
						for(int i = 0; i < rs2[4:0]; i++) begin
							hold = temp[0];
							temp[30:0] = temp[31:1];	
							temp[31] = hold;
						end
						rd[31:0] = temp[31:0];	 
						//63:32	
						temp[63:32] = rs1[63:32];
						for(int i = 0; i < rs2[36:32]; i++)	begin
							hold = temp[32];
							temp[62:32] = temp[63:33];
							temp[63] = hold;
						end
						rd[63:32] = temp[63:32];
						//95:64
						temp[95:64] = rs1[95:64];
						for(int i = 0; i < rs2[68:64]; i++)	begin
							hold = temp[64];
							temp[94:64] = temp[95:65];
							temp[95] = hold;
						end
						rd[95:64] = temp[95:64];
						//127:96
						temp[127:96] = rs1[127:96];
						for(int i = 0; i < rs2[100:96]; i++) begin
							hold = temp[96];
							temp[126:96] = temp[127:97];
							temp[127] = hold;
						end
						rd[127:96] = temp[127:96];	
				end	
				else if (alu_control == 23) begin
						//15:0
						rd[15:0] = $signed(rs2[15:0]) - $signed(rs1[15:0]);
						if((rs2[15] == 1) && (rs1[15] == 0) && (rd[15] == 0))
							rd[15:0] = 16'sb1000000000000000; 
						else if((rs2[15] == 0) && (rs1[15] == 1) && (rd[15] == 1))
							rd[15:0] = 16'sb0111111111111111; 
						else
							rd[15:0] = $signed(rd[15:0]);
						//31:16
						rd[31:16] = $signed(rs2[31:16]) - $signed(rs1[31:16]);
						if((rs2[31] == 1) && (rs1[31] == 0) && (rd[31] == 0))
							rd[31:16] = 16'sb1000000000000000; 
						else if((rs2[31] == 0) && (rs1[31] == 1) && (rd[31] == 1))
							rd[31:16] = 16'sb0111111111111111; 
						else
							rd[31:16] = $signed(rd[31:16]);
						//47:32
						rd[47:32] = $signed(rs2[47:32]) - $signed(rs1[47:32]);
						if((rs2[47] == 1) && (rs1[47] == 0) && (rd[47] == 0))
							rd[47:32] = 16'sb1000000000000000; 
						else if((rs2[47] == 0) && (rs1[47] == 1) && (rd[47] == 1))
							rd[47:32] = 16'sb0111111111111111; 
						else
							rd[47:32] = $signed(rd[47:32]);
						//63:48
						rd[63:48] = $signed(rs2[63:48]) - $signed(rs1[63:48]);
						if((rs2[63] == 1) && (rs1[63] == 0) && (rd[63] == 0))
							rd[63:48] = 16'sb1000000000000000; 
						else if((rs2[63] == 0) && (rs1[63] == 1) && (rd[63] == 1))
							rd[63:48] = 16'sb0111111111111111; 
						else
							rd[63:48] = $signed(rd[63:48]);
						//79:64
						rd[79:64] = $signed(rs2[79:64]) - $signed(rs1[79:64]);
						if((rs2[79] == 1) && (rs1[79] == 0) && (rd[79] == 0))
							rd[79:64] = 16'sb1000000000000000; 
						else if((rs2[79] == 0) && (rs1[79] == 1) && (rd[79] == 1))
							rd[79:64] = 16'sb0111111111111111; 
						else
							rd[79:64] = $signed(rd[79:64]);
						//95:80
						rd[95:80] = $signed(rs2[95:80]) - $signed(rs1[95:80]);
						if((rs2[95] == 1) && (rs1[95] == 0) && (rd[95] == 0))
							rd[95:80] = 16'sb1000000000000000; 
						else if((rs2[95] == 0) && (rs1[95] == 1) && (rd[95] == 1))
							rd[95:0] = 16'sb0111111111111111; 
						else
							rd[95:80] = $signed(rd[95:80]);
						//111:96
						rd[111:96] = $signed(rs2[111:96]) - $signed(rs1[111:96]);
						if((rs2[111] == 1) && (rs1[111] == 0) && (rd[111] == 0))
							rd[111:96] = 16'sb1000000000000000; 
						else if((rs2[111] == 0) && (rs1[111] == 1) && (rd[111] == 1))
							rd[111:96] = 16'sb0111111111111111; 
						else
							rd[111:96] = $signed(rd[111:96]);
						//127:112
						rd[127:112] = $signed(rs2[127:112]) - $signed(rs1[127:112]);
						if((rs2[127] == 1) && (rs1[127] == 0) && (rd[127] == 0))
							rd[127:112] = 16'sb1000000000000000; 
						else if((rs2[127] == 0) && (rs1[127] == 1) && (rd[127] == 1))
							rd[127:112] = 16'sb0111111111111111; 
						else
							rd[127:112] = $signed(rd[127:112]);
				end			
				else begin
						//31:0
						rd[31:0] = rs2[31:0] - rs1[31:0];	
						//63:32
						rd[63:32] = rs2[63:32] - rs1[63:32];
						//95:64
						rd[95:64] = rs2[95:64] - rs1[95:64];
						//127:96
						rd[127:96] = rs2[127:96] - rs1[127:96];
				end	
			end
			
		
			always_ff @(posedge clk) begin  
				exe_wr_en <= ID_wr_en;
				exe_rd <= ID_rd;
				exe_alu_result <= rd;
				
			end
endmodule		   


module ins_decoder(clk, wb_wr_en, instruction, wb_rd, wb_alu_result, r1_value, r2_value, r3_value, rd_value, ID_rd, ID_wr_en, alu_control, index, immidiate, reg1, reg2, reg3);
	input [24:0] instruction;
	input [4:0] wb_rd;	
	input[127:0] wb_alu_result;
	output logic [127:0] r1_value, r2_value, r3_value, rd_value;  
	output logic [4:0] reg1, reg2, reg3;
	input  clk, wb_wr_en;			 
	logic [127:0] data_reg[31:0];	
	output logic [4:0] ID_rd; 
	output logic [15:0] immidiate; 
	output logic ID_wr_en; 
	output logic [4:0] alu_control;	   
	output logic [2:0] index;  
	logic aaa;
	
	//initial $readmemb("data_reg.txt", data_reg);		
	
	always_comb begin
		 if (wb_wr_en)
            data_reg[wb_rd] = wb_alu_result; 	 
		 else
			data_reg[wb_rd]	= data_reg[wb_rd];
			
	end
	
	always_ff @(posedge clk) begin
        r1_value <= data_reg[instruction[9:5]];	  
		r2_value <= data_reg[instruction[14:10]];	
		r3_value <= data_reg[instruction[19:15]];
		rd_value <= data_reg[instruction[4:0]];
		reg1 <= instruction[9:5];	  
		reg2 <= instruction[14:10];	
		reg3 <= instruction[19:15];
		ID_rd <= instruction[4:0];
		immidiate <= instruction[20:5];
		index <= instruction[23:21];
		
		if(instruction[24] == 0) begin 
			ID_wr_en <= 1;
			alu_control <= 0;
		end
		else if((instruction[24:23] == 2) && (instruction[22:20] == 0)) begin
			ID_wr_en <= 1;
			alu_control <= 1;
		end
		else if((instruction[24:23] == 2) && (instruction[22:20] == 1)) begin
			ID_wr_en <= 1;
			alu_control <= 2;
		end
		else if((instruction[24:23] == 2) && (instruction[22:20] == 2)) begin
			ID_wr_en <= 1;
			alu_control <= 3;
		end
		else if((instruction[24:23] == 2) && (instruction[22:20] == 3)) begin
			ID_wr_en <= 1;
			alu_control <= 4;
		end
		else if((instruction[24:23] == 2) && (instruction[22:20] == 4)) begin
			ID_wr_en <= 1;
			alu_control <= 5;
		end
		else if((instruction[24:23] == 2) && (instruction[22:20] == 5)) begin
			ID_wr_en <= 1;
			alu_control <= 6;
		end
		else if((instruction[24:23] == 2) && (instruction[22:20] == 6)) begin
			ID_wr_en <= 1;
			alu_control <= 7;
		end
		else if((instruction[24:23] == 2) && (instruction[22:20] == 7)) begin
			ID_wr_en <= 1;
			alu_control <= 8;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 0)) begin
			ID_wr_en <= 0;
			alu_control <= 9;
		end	 
		else if((instruction[24:23] == 3) && (instruction[18:15] == 1)) begin
			ID_wr_en <= 1;
			alu_control <= 10;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 2)) begin
			ID_wr_en <= 1;
			alu_control <= 11;
		end	
		else if((instruction[24:23] == 3) && (instruction[18:15] == 3)) begin
			ID_wr_en <= 1;
			alu_control <= 12;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 4)) begin
			ID_wr_en <= 1;
			alu_control <= 13;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 5)) begin
			ID_wr_en <= 1;
			alu_control <= 14;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 6)) begin
			ID_wr_en <= 1;
			alu_control <= 15;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 7)) begin
			ID_wr_en <= 1;
			alu_control <= 16;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 8)) begin
			ID_wr_en <= 1;
			alu_control <= 17;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 9)) begin
			ID_wr_en <= 1;
			alu_control <= 18;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 10)) begin
			ID_wr_en <= 1;
			alu_control <= 19;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 11)) begin
			ID_wr_en <= 1;
			alu_control <= 20;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 12)) begin
			ID_wr_en <= 1;
			alu_control <= 21;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 13)) begin
			ID_wr_en <= 1;
			alu_control <= 22;
		end	
		else if((instruction[24:23] == 3) && (instruction[18:15] == 14)) begin
			ID_wr_en <= 1;
			alu_control <= 23;
		end
		else if((instruction[24:23] == 3) && (instruction[18:15] == 15)) begin
			ID_wr_en <= 1;
			alu_control <= 24;
		end
    end
endmodule

module ins_buffer(instruction, clk, reset, mem, pc);
	output logic[5:0] pc;   
	input clk, reset;
	output logic[24:0] instruction;	   	
	input logic [24:0] mem[63:0];	
	
	//initial $readmemb("instruction.txt", mem);	 
	
	always_ff @(posedge clk) begin	
		if(reset == 1)
			pc <= 0;
		else begin
			pc <= pc + 1;
			instruction <= mem[pc];	 
		end
	end		 	
endmodule