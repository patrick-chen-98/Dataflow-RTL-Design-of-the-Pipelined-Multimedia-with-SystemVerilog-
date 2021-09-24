The Assembler is built to convert an assembly file to a binary code file using C++.
The input of the Assembler is a text file contains a list of instructions. And the instructions follow a set of formats that same as the given format of ALU instructions.
For example, the input format should be:
	For load immediate: li index imm rd
	For R4 type: name rs3 rs2 rs1 rd
	For R3 type: name rs2 rs1 rd
The output of our Assembler will be a text file contains the instructions in binary format which can be directly used as the input of System Verilog project.
We include an assembly code as an example in the folder.