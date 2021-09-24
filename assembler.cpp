#include <iostream>
#include <math.h>
#include <fstream>
#include <cstdlib>
#include <string>
using namespace std;

void decToBinary(int n, ofstream & fout)
{
	
	int binaryNum[32];

	// counter for binary array
	int i = 0;
	while (n > 0) {

		// storing remainder in binary array
		binaryNum[i] = n % 2;
		n = n / 2;
		i++;
	}
	
		for (int j = 4; j > i - 1; j--) {
			fout << '0';
		}
	
	
	
	
	for (int j = i - 1; j >= 0; j--)
		fout << binaryNum[j];
}
void decToBinary_index(int n, ofstream & fout)
{
	
	int binaryNum[32];

	
	int i = 0;
	while (n > 0) {

		
		binaryNum[i] = n % 2;
		n = n / 2;
		i++;
	}
	if (i < 3) {
		for (int j = 2; j > i - 1; j--) {
			fout << '0';
		}
	}


	
	for (int j = i - 1; j >= 0; j--)
		fout << binaryNum[j];
}
void decToBinary_imm(int n, ofstream & fout)
{
	
	int binaryNum[32];

	// counter for binary array
	int i = 0;
	while (n > 0) {

		// storing remainder in binary array
		binaryNum[i] = n % 2;
		n = n / 2;
		i++;
	}
	for (int j = 15; j > i - 1; j--) {
		fout << '0';
	}

	// printing binary array in reverse order
	for (int j = i - 1; j >= 0; j--)
		fout << binaryNum[j];
}
void register_search(string rd, ofstream &fout) {
	if (rd == "r0")
		decToBinary(0, fout);

	else if (rd == "r1")
		decToBinary(1, fout);

	else if (rd == "r2") {
		decToBinary(2, fout);

	}

	else if (rd == "r3")
		decToBinary(3, fout);

	else if (rd == "r4")
		decToBinary(4, fout);

	else if (rd == "r5")
		decToBinary(5, fout);

	else if (rd == "r6")
		decToBinary(6, fout);

	else if (rd == "r7")
		decToBinary(7, fout);

	else if (rd == "r8")
		decToBinary(8, fout);

	else if (rd == "r9")
		decToBinary(9, fout);

	else if (rd == "r10")
		decToBinary(10, fout);

	else if (rd == "r11")
		decToBinary(11, fout);

	else if (rd == "r12")
		decToBinary(12, fout);

	else if (rd == "r13")
		decToBinary(13, fout);

	else if (rd == "r14")
		decToBinary(14, fout);

	else if (rd == "r15")
		decToBinary(15, fout);

	else if (rd == "r16")
		decToBinary(16, fout);

	else if (rd == "r17")
		decToBinary(17, fout);

	else if (rd == "r18")
		decToBinary(18, fout);

	else if (rd == "r19")
		decToBinary(19, fout);

	else if (rd == "r20")
		decToBinary(20, fout);

	else if (rd == "r21")
		decToBinary(21, fout);

	else if (rd == "r22")
		decToBinary(22, fout);

	else if (rd == "r23")
		decToBinary(23, fout);

	else if (rd == "r24")
		decToBinary(24, fout);

	else if (rd == "r25")
		decToBinary(25, fout);

	else if (rd == "r26")
		decToBinary(26, fout);

	else if (rd == "r27")
		decToBinary(27, fout);

	else if (rd == "r28")
		decToBinary(28, fout);

	else if (rd == "r29")
		decToBinary(29, fout);

	else if (rd == "r30")
		decToBinary(30, fout);

	else if (rd == "r31")
		decToBinary(31, fout);
	else
		cout << " The destination register doesn't exsit.";
}
int main() {
    
	ifstream fin("assembly_code.txt");
	ofstream fout;
	string ins;
	string op;
	int index;
	int imm;
	string type;
	string li, rs1, rs2, rs3, rd;
	
	
	fout.open("binary_instruction.txt");

	if (!fin) {
		cerr << "cannot open " << "inputfile.txt" << endl;
		exit(1);
	}
	if (!fout) {
		cerr << "cannot open " << "outputfile.txt" << endl;
		exit(1);
	} 
	if (fin.is_open())
	{
		while (fin >> ins) { //take word and print
			

			if (ins == "li")
			{
				fout << '0';
				fin >> index;


				decToBinary_index(index, fout);
				fin >> imm;
				decToBinary_imm(imm, fout);

				fin >> rd;

				register_search(rd, fout);
				fout << endl;
			}


			else if (ins == "mals" || ins == "mahs" || ins == "msls" || ins == "mshs" || ins == "lmals" || ins == "lmahs" || ins == "lmsls" || ins == "lmshs") {
				fout << "10";
				if (ins == "mals") {
					fout << "000";
					fin >> rs3;
					register_search(rs3, fout);
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "mahs") {
					fout << "001";
					fin >> rs3;
					register_search(rs3, fout);
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "msls") {
					fout << "010";
					fin >> rs3;
					register_search(rs3, fout);
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "mshs") {
					fout << "011";
					fin >> rs3;
					register_search(rs3, fout);
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "lmals") {
					fout << "100";
					fin >> rs3;
					register_search(rs3, fout);
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "lmahs") {
					fout << "101";
					fin >> rs3;
					register_search(rs3, fout);
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "lmsls") {
					fout << "110";
					fin >> rs3;
					register_search(rs3, fout);
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "lmshs") {
					fout << "111";
					fin >> rs3;
					register_search(rs3, fout);
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				fout << endl;
			}
			else if (ins == "nop" || ins == "au" || ins == "absdb" || ins == "ahu" || ins == "ahs" || ins == "and" || ins == "bcw" || ins == "maxws"
				|| ins == "minws" || ins == "mlhu" || ins == "mlhcu" || ins == "or" || ins == "pcntw" || ins == "rotw" || ins == "sfhs" || ins == "sfw")
			{
				fout << "11";

				if (ins == "nop")
					fout << "00000000000000000000000";
				else if (ins == "au") {
					fout << "00010001";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "absdb") {
					fout << "00010010";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "ahu") {
					fout << "00010011";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "ahs") {
					fout << "00010100";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "and") {
					fout << "00010101";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}

				else if (ins == "maxws") {
					fout << "00010111";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "minws") {
					fout << "00001000";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "mlhu") {
					fout << "00011001";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "mlhcu") {
					fout << "00011010";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "or") {
					fout << "00011011";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "pcntw") {
					fout << "00011100";
					fout << "00010";
					fin >> rs1;

					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "rotw") {
					fout << "00011101";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "sfhs") {
					fout << "00011110";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "sfw") {
				
					fout << "00011111";
					fin >> rs2;
					register_search(rs2, fout);
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else if (ins == "bcw") {
				
					fout << "00010110";
					fout << "00000";
					fin >> rs1;
					register_search(rs1, fout);
					fin >> rd;
					register_search(rd, fout);
				}
				else
					fout << "Error" << endl;



				fout << endl;
			}


		}
		
	}
	fin.close();
	}
	
	
	
