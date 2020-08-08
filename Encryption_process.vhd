----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:20:31 02/01/2020 
-- Design Name: 
-- Module Name:    Encryption_process - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity Encryption_process is
	port(
			clk : in STD_LOGIC;
			start : in STD_LOGIC;
			plain_text : in STD_LOGIC_VECTOR(127 downto 0);
			cipher_key : in STD_LOGIC_VECTOR(127 downto 0);
			cipher_text : out STD_LOGIC_VECTOR(127 downto 0);
			ready : out STD_LOGIC
	);
end Encryption_process;

architecture Behavioral of Encryption_process is
------------------------------------------------------------------------------------
Type matrix_4_4 is array (0 to 3,0 to 3) of STD_LOGIC_VECTOR(7 downto 0);
Type matrix_16_16 is array (0 to 15, 0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
Type array_256 is array (0 to 255) of STD_LOGIC_VECTOR(7 downto 0);
Type array_4 is array (0 to 3) of STD_LOGIC_VECTOR(7 downto 0);
---------------------------------------------------------------------------------------
function to_matrix (input_text : STD_LOGIC_VECTOR(127 downto 0)) return matrix_4_4 is 
variable mat_out : matrix_4_4;
variable counter : integer range 0 to 255 := 0;
begin
	for i in 0 to 3 loop
		for j in 0 to 3 loop
			mat_out(i,j) := input_text((127 - (counter *8)) downto 128 - ((counter + 1 ) *8));
			counter := counter + 1;
		end loop;
	end loop;
	return mat_out;
end to_matrix;
--------------------------------------------------------------------------------------
function add_round_key (text_in, key_in : matrix_4_4) return matrix_4_4 is
variable mat_out : matrix_4_4;
begin 
	for i in 0 to 3 loop
		for j in 0 to 3 loop
			mat_out(i,j) := text_in(i,j) xor key_in(i,j);
		end loop;
	end loop;
	return mat_out;
end add_round_key;
---------------------------------------------------------------------------------------
function sub_bytes (text_in : matrix_4_4) return matrix_4_4 is
variable mat_out : matrix_4_4;
variable aes_s_box : matrix_16_16 := ((X"63", X"7C", X"77", X"7B", X"F2", X"6b", X"6F", X"C5", X"30", X"01", X"67", X"2B", X"FE", X"D7", X"AB", X"76"),
												  (X"CA", X"82", X"C9", X"7D", X"FA", X"59", X"47", X"F0", X"AD", X"D4", X"A2", X"AF", X"9C", X"A4", X"72", X"C0"),
												  (X"B7", X"FD", X"93", X"26", X"36", X"3F", X"F7", X"CC", X"34", X"A5", X"E5", X"F1", X"71", X"D8", X"31", X"15"),
												  (X"04", X"C7", X"23", X"C3", X"18", X"96", X"05", X"9A", X"07", X"12", X"80", X"E2", X"EB", X"27", X"B2", X"75"),
												  (X"09", X"83", X"2C", X"1A", X"1B", X"6E", X"5A", X"A0", X"52", X"3B", X"D6", X"B3", X"29", X"E3", X"2F", X"84"),
												  (X"53", X"D1", X"00", X"ED", X"20", X"FC", X"B1", X"5B", X"6A", X"CB", X"BE", X"39", X"4A", X"4C", X"58", X"CF"),
												  (X"D0", X"EF", X"AA", X"FB", X"43", X"4D", X"33", X"85", X"45", X"F9", X"02", X"7F", X"50", X"3C", X"9F", X"A8"),
												  (X"51", X"A3", X"40", X"8F", X"92", X"9D", X"38", X"F5", X"BC", X"B6", X"DA", X"21", X"10", X"FF", X"F3", X"D2"),
												  (X"CD", X"0C", X"13", X"EC", X"5F", X"97", X"44", X"17", X"C4", X"A7", X"7E", X"3D", X"64", X"5D", X"19", X"73"),
												  (X"60", X"81", X"4F", X"DC", X"22", X"2A", X"90", X"88", X"46", X"EE", X"B8", X"14", X"DE", X"5E", X"0B", X"DB"),
												  (X"E0", X"32", X"3A", X"0A", X"49", X"06", X"24", X"5C", X"C2", X"D3", X"AC", X"62", X"91", X"95", X"E4", X"79"),
												  (X"E7", X"C8", X"37", X"6D", X"8D", X"D5", X"4E", X"A9", X"6C", X"56", X"F4", X"EA", X"65", X"7A", X"AE", X"08"),
												  (X"BA", X"78", X"25", X"2E", X"1C", X"A6", X"B4", X"C6", X"E8", X"DD", X"74", X"1F", X"4B", X"BD", X"8B", X"8A"),
												  (X"70", X"3E", X"B5", X"66", X"48", X"03", X"F6", X"0E", X"61", X"35", X"57", X"B9", X"86", X"C1", X"1D", X"9E"),
												  (X"E1", X"F8", X"98", X"11", X"69", X"D9", X"8E", X"94", X"9B", X"1E", X"87", X"E9", X"CE", X"55", X"28", X"DF"),
												  (X"8C", X"A1", X"89", X"0D", X"BF", X"E6", X"42", X"68", X"41", X"99", X"2D", X"0F", X"B0", X"54", X"BB", X"16"));
begin
	for i in 0 to 3 loop
		for j in 0 to 3 loop
			mat_out(i,j) := aes_s_box(conv_integer(text_in(i,j)(7 downto 4)), conv_integer(text_in(i,j)(3 downto 0)));
		end loop;
	end loop;
	return mat_out;
end sub_bytes;
-----------------------------------------------------------------------------------------
function shift_rows (text_in : matrix_4_4) return matrix_4_4 is
variable mat_out : matrix_4_4 := text_in;
variable temp, temp2 : STD_LOGIC_VECTOR(7 downto 0);
begin
	temp := mat_out(1,0);
	mat_out(1,0) := mat_out(1,1); 
	mat_out(1,1) := mat_out(1,2);
	mat_out(1,2) := mat_out(1,3);
	mat_out(1,3) := temp;
	
	temp := mat_out(2,0);
	mat_out(2,0) := mat_out(2,2);
	temp2 := mat_out(2,1);
	mat_out(2,1) := mat_out(2,3);
	mat_out(2,2) := temp;
	mat_out(2,3) := temp2;
	
	temp := mat_out(3,0);
	mat_out(3,0) := mat_out(3,3);
	mat_out(3,3) := mat_out(3,2);
	mat_out(3,2) := mat_out(3,1);
	mat_out(3,1) := temp;
	
	return mat_out;
end shift_rows;
-----------------------------------------------------------------------------------------
function mix_columns (text_in : matrix_4_4) return matrix_4_4 is
variable mat_out : matrix_4_4;
variable mult_2 : array_256 := (X"00", X"02", X"04", X"06", X"08", X"0a", X"0c", X"0e", X"10", X"12", X"14", X"16", X"18", X"1a", X"1c", X"1e",
										  X"20", X"22", X"24", X"26", X"28", X"2a", X"2c", X"2e", X"30", X"32", X"34", X"36", X"38", X"3a", X"3c", X"3e",
										  X"40", X"42", X"44", X"46", X"48", X"4a", X"4c", X"4e", X"50", X"52", X"54", X"56", X"58", X"5a", X"5c", X"5e",
										  X"60", X"62", X"64", X"66", X"68", X"6a", X"6c", X"6e", X"70", X"72", X"74", X"76", X"78", X"7a", X"7c", X"7e",
										  X"80", X"82", X"84", X"86", X"88", X"8a", X"8c", X"8e", X"90", X"92", X"94", X"96", X"98", X"9a", X"9c", X"9e",
										  X"a0", X"a2", X"a4", X"a6", X"a8", X"aa", X"ac", X"ae", X"b0", X"b2", X"b4", X"b6", X"b8", X"ba", X"bc", X"be",
										  X"c0", X"c2", X"c4", X"c6", X"c8", X"ca", X"cc", X"ce", X"d0", X"d2", X"d4", X"d6", X"d8", X"da", X"dc", X"de",
										  X"e0", X"e2", X"e4", X"e6", X"e8", X"ea", X"ec", X"ee", X"f0", X"f2", X"f4", X"f6", X"f8", X"fa", X"fc", X"fe",
										  X"1b", X"19", X"1f", X"1d", X"13", X"11", X"17", X"15", X"0b", X"09", X"0f", X"0d", X"03", X"01", X"07", X"05",
										  X"3b", X"39", X"3f", X"3d", X"33", X"31", X"37", X"35", X"2b", X"29", X"2f", X"2d", X"23", X"21", X"27", X"25",
										  X"5b", X"59", X"5f", X"5d", X"53", X"51", X"57", X"55", X"4b", X"49", X"4f", X"4d", X"43", X"41", X"47", X"45",
										  X"7b", X"79", X"7f", X"7d", X"73", X"71", X"77", X"75", X"6b", X"69", X"6f", X"6d", X"63", X"61", X"67", X"65",
										  X"9b", X"99", X"9f", X"9d", X"93", X"91", X"97", X"95", X"8b", X"89", X"8f", X"8d", X"83", X"81", X"87", X"85",
										  X"bb", X"b9", X"bf", X"bd", X"b3", X"b1", X"b7", X"b5", X"ab", X"a9", X"af", X"ad", X"a3", X"a1", X"a7", X"a5",
										  X"db", X"d9", X"df", X"dd", X"d3", X"d1", X"d7", X"d5", X"cb", X"c9", X"cf", X"cd", X"c3", X"c1", X"c7", X"c5",
										  X"fb", X"f9", X"ff", X"fd", X"f3", X"f1", X"f7", X"f5", X"eb", X"e9", X"ef", X"ed", X"e3", X"e1", X"e7", X"e5");

variable mult_3 : array_256 := (X"00", X"03", X"06", X"05", X"0c", X"0f", X"0a", X"09", X"18", X"1b", X"1e", X"1d", X"14", X"17", X"12", X"11",
										  X"30", X"33", X"36", X"35", X"3c", X"3f", X"3a", X"39", X"28", X"2b", X"2e", X"2d", X"24", X"27", X"22", X"21",
										  X"60", X"63", X"66", X"65", X"6c", X"6f", X"6a", X"69", X"78", X"7b", X"7e", X"7d", X"74", X"77", X"72", X"71",
										  X"50", X"53", X"56", X"55", X"5c", X"5f", X"5a", X"59", X"48", X"4b", X"4e", X"4d", X"44", X"47", X"42", X"41",
										  X"c0", X"c3", X"c6", X"c5", X"cc", X"cf", X"ca", X"c9", X"d8", X"db", X"de", X"dd", X"d4", X"d7", X"d2", X"d1",
										  X"f0", X"f3", X"f6", X"f5", X"fc", X"ff", X"fa", X"f9", X"e8", X"eb", X"ee", X"ed", X"e4", X"e7", X"e2", X"e1",
										  X"a0", X"a3", X"a6", X"a5", X"ac", X"af", X"aa", X"a9", X"b8", X"bb", X"be", X"bd", X"b4", X"b7", X"b2", X"b1",
										  X"90", X"93", X"96", X"95", X"9c", X"9f", X"9a", X"99", X"88", X"8b", X"8e", X"8d", X"84", X"87", X"82", X"81",
										  X"9b", X"98", X"9d", X"9e", X"97", X"94", X"91", X"92", X"83", X"80", X"85", X"86", X"8f", X"8c", X"89", X"8a",
										  X"ab", X"a8", X"ad", X"ae", X"a7", X"a4", X"a1", X"a2", X"b3", X"b0", X"b5", X"b6", X"bf", X"bc", X"b9", X"ba",
										  X"fb", X"f8", X"fd", X"fe", X"f7", X"f4", X"f1", X"f2", X"e3", X"e0", X"e5", X"e6", X"ef", X"ec", X"e9", X"ea",
										  X"cb", X"c8", X"cd", X"ce", X"c7", X"c4", X"c1", X"c2", X"d3", X"d0", X"d5", X"d6", X"df", X"dc", X"d9", X"da",
										  X"5b", X"58", X"5d", X"5e", X"57", X"54", X"51", X"52", X"43", X"40", X"45", X"46", X"4f", X"4c", X"49", X"4a",
										  X"6b", X"68", X"6d", X"6e", X"67", X"64", X"61", X"62", X"73", X"70", X"75", X"76", X"7f", X"7c", X"79", X"7a",
										  X"3b", X"38", X"3d", X"3e", X"37", X"34", X"31", X"32", X"23", X"20", X"25", X"26", X"2f", X"2c", X"29", X"2a",
										  X"0b", X"08", X"0d", X"0e", X"07", X"04", X"01", X"02", X"13", X"10", X"15", X"16", X"1f", X"1c", X"19", X"1a");

begin
	mat_out(0,0) := (mult_2(conv_integer(text_in(0,0))) xor mult_3(conv_integer(text_in(1,0)))) xor (text_in(2,0) xor text_in(3,0));
	mat_out(1,0) := (mult_2(conv_integer(text_in(1,0))) xor mult_3(conv_integer(text_in(2,0)))) xor (text_in(0,0) xor text_in(3,0));
	mat_out(2,0) := (mult_2(conv_integer(text_in(2,0))) xor mult_3(conv_integer(text_in(3,0)))) xor (text_in(0,0) xor text_in(1,0));
	mat_out(3,0) := (mult_2(conv_integer(text_in(3,0))) xor mult_3(conv_integer(text_in(0,0)))) xor (text_in(1,0) xor text_in(2,0));
	
	mat_out(0,1) := (mult_2(conv_integer(text_in(0,1))) xor mult_3(conv_integer(text_in(1,1)))) xor (text_in(2,1) xor text_in(3,1));
	mat_out(1,1) := (mult_2(conv_integer(text_in(1,1))) xor mult_3(conv_integer(text_in(2,1)))) xor (text_in(0,1) xor text_in(3,1));
	mat_out(2,1) := (mult_2(conv_integer(text_in(2,1))) xor mult_3(conv_integer(text_in(3,1)))) xor (text_in(0,1) xor text_in(1,1));
	mat_out(3,1) := (mult_2(conv_integer(text_in(3,1))) xor mult_3(conv_integer(text_in(0,1)))) xor (text_in(1,1) xor text_in(2,1));
	
	mat_out(0,2) := (mult_2(conv_integer(text_in(0,2))) xor mult_3(conv_integer(text_in(1,2)))) xor (text_in(2,2) xor text_in(3,2));
	mat_out(1,2) := (mult_2(conv_integer(text_in(1,2))) xor mult_3(conv_integer(text_in(2,2)))) xor (text_in(0,2) xor text_in(3,2));
	mat_out(2,2) := (mult_2(conv_integer(text_in(2,2))) xor mult_3(conv_integer(text_in(3,2)))) xor (text_in(0,2) xor text_in(1,2));
	mat_out(3,2) := (mult_2(conv_integer(text_in(3,2))) xor mult_3(conv_integer(text_in(0,2)))) xor (text_in(1,2) xor text_in(2,2));
	
	mat_out(0,3) := (mult_2(conv_integer(text_in(0,3))) xor mult_3(conv_integer(text_in(1,3)))) xor (text_in(2,3) xor text_in(3,3));
	mat_out(1,3) := (mult_2(conv_integer(text_in(1,3))) xor mult_3(conv_integer(text_in(2,3)))) xor (text_in(0,3) xor text_in(3,3));
	mat_out(2,3) := (mult_2(conv_integer(text_in(2,3))) xor mult_3(conv_integer(text_in(3,3)))) xor (text_in(0,3) xor text_in(1,3));
	mat_out(3,3) := (mult_2(conv_integer(text_in(3,3))) xor mult_3(conv_integer(text_in(0,3)))) xor (text_in(1,3) xor text_in(2,3));

	
	return mat_out;
end mix_columns;
-------------------------------------------------------------------------------------
function to_array (text_in : matrix_4_4) return STD_LOGIC_VECTOR is
variable array_out : STD_LOGIC_VECTOR(127 downto 0);
variable counter : integer range 0 to 255 := 0;
begin
	for i in 0 to 3 loop
		for j in 0 to 3 loop
			array_out((127 - (counter *8)) downto 128 - ((counter + 1 ) *8)) := text_in(i,j);
			counter := counter + 1;
		end loop;
	end loop;
	return array_out;
end to_array;
------------------------------------------------------------------------------------
function sub_bytes_key (text_in : array_4) return array_4 is
variable array_out : array_4;
variable aes_s_box : matrix_16_16 := ((X"63", X"7C", X"77", X"7B", X"F2", X"6b", X"6F", X"C5", X"30", X"01", X"67", X"2B", X"FE", X"D7", X"AB", X"76"),
												  (X"CA", X"82", X"C9", X"7D", X"FA", X"59", X"47", X"F0", X"AD", X"D4", X"A2", X"AF", X"9C", X"A4", X"72", X"C0"),
												  (X"B7", X"FD", X"93", X"26", X"36", X"3F", X"F7", X"CC", X"34", X"A5", X"E5", X"F1", X"71", X"D8", X"31", X"15"),
												  (X"04", X"C7", X"23", X"C3", X"18", X"96", X"05", X"9A", X"07", X"12", X"80", X"E2", X"EB", X"27", X"B2", X"75"),
												  (X"09", X"83", X"2C", X"1A", X"1B", X"6E", X"5A", X"A0", X"52", X"3B", X"D6", X"B3", X"29", X"E3", X"2F", X"84"),
												  (X"53", X"D1", X"00", X"ED", X"20", X"FC", X"B1", X"5B", X"6A", X"CB", X"BE", X"39", X"4A", X"4C", X"58", X"CF"),
												  (X"D0", X"EF", X"AA", X"FB", X"43", X"4D", X"33", X"85", X"45", X"F9", X"02", X"7F", X"50", X"3C", X"9F", X"A8"),
												  (X"51", X"A3", X"40", X"8F", X"92", X"9D", X"38", X"F5", X"BC", X"B6", X"DA", X"21", X"10", X"FF", X"F3", X"D2"),
												  (X"CD", X"0C", X"13", X"EC", X"5F", X"97", X"44", X"17", X"C4", X"A7", X"7E", X"3D", X"64", X"5D", X"19", X"73"),
												  (X"60", X"81", X"4F", X"DC", X"22", X"2A", X"90", X"88", X"46", X"EE", X"B8", X"14", X"DE", X"5E", X"0B", X"DB"),
												  (X"E0", X"32", X"3A", X"0A", X"49", X"06", X"24", X"5C", X"C2", X"D3", X"AC", X"62", X"91", X"95", X"E4", X"79"),
												  (X"E7", X"C8", X"37", X"6D", X"8D", X"D5", X"4E", X"A9", X"6C", X"56", X"F4", X"EA", X"65", X"7A", X"AE", X"08"),
												  (X"BA", X"78", X"25", X"2E", X"1C", X"A6", X"B4", X"C6", X"E8", X"DD", X"74", X"1F", X"4B", X"BD", X"8B", X"8A"),
												  (X"70", X"3E", X"B5", X"66", X"48", X"03", X"F6", X"0E", X"61", X"35", X"57", X"B9", X"86", X"C1", X"1D", X"9E"),
												  (X"E1", X"F8", X"98", X"11", X"69", X"D9", X"8E", X"94", X"9B", X"1E", X"87", X"E9", X"CE", X"55", X"28", X"DF"),
												  (X"8C", X"A1", X"89", X"0D", X"BF", X"E6", X"42", X"68", X"41", X"99", X"2D", X"0F", X"B0", X"54", X"BB", X"16"));
begin
	for i in 0 to 3 loop
		array_out(i) := aes_s_box(conv_integer(text_in(i)(7 downto 4)), conv_integer(text_in(i)(3 downto 0)));
	end loop;
	return array_out;
end sub_bytes_key;
-------------------------------------------------------------------------------------
type state is (load_plain, load_cipher, round0, text_sub_bytes, text_shift_rows, text_mix_columns, key_schedule, add_round_key, round10_sub_bytes, round10_shift_rows, round10_key_schedule, round10_add_round_key, to_array);
signal cur_state : state := load_plain;
signal text_mat, key_mat : matrix_4_4;
begin

	process(clk)
	variable counter : integer range 0 to 10 := 1;
	variable rcon : integer range 0 to 3000 := 1;
	variable array_temp : array_4;
	variable matrix_temp: matrix_4_4;
	begin
		if(clk'event and clk = '1')then
			case cur_state is
			
				when load_plain =>
					text_mat <= to_matrix(plain_text);
					cur_state <= load_cipher;
					
				when load_cipher =>
					key_mat <= to_matrix(cipher_key);
					cur_state <= round0;
				
				when round0 =>
					if(start = '1')then
						rcon := 1;
						ready<= '0';
						text_mat <= add_round_key(text_mat, key_mat);
						cur_state <= text_sub_bytes;
					end if;
					
				when text_sub_bytes =>
					text_mat <= sub_bytes(text_mat);
					cur_state <= text_shift_rows;
					
				when text_shift_rows =>
					text_mat <= shift_rows(text_mat);
					cur_state <= text_mix_columns;
				
				when text_mix_columns =>
					text_mat <= mix_columns(text_mat);
					cur_state <= key_schedule;

				when key_schedule =>
				
					matrix_temp(0,0) := key_mat(1,3);
					matrix_temp(1,0) := key_mat(2,3);
					matrix_temp(2,0) := key_mat(3,3);
					matrix_temp(3,0) := key_mat(0,3);
				
					array_temp := (matrix_temp(0,0), matrix_temp(1,0), matrix_temp(2,0),matrix_temp(3,0));
					array_temp := sub_bytes_key(array_temp);
					matrix_temp(0,0) := array_temp(0);
					matrix_temp(1,0) := array_temp(1);
					matrix_temp(2,0) := array_temp(2);
					matrix_temp(3,0) := array_temp(3);
					
					if(counter = 9) then
						rcon := 27;
					elsif (counter = 10)then
						rcon := 54;
					end if;
					
					matrix_temp(0,0) := (key_mat(0,0) xor matrix_temp(0,0)) xor conv_std_logic_vector(rcon, 8);
					matrix_temp(1,0) := key_mat(1,0) xor matrix_temp(1,0);
					matrix_temp(2,0) := key_mat(2,0) xor matrix_temp(2,0);
					matrix_temp(3,0) := key_mat(3,0) xor matrix_temp(3,0);
				
					for i in 0 to 3 loop
						for j in 1 to 3 loop
							matrix_temp(i,j) := matrix_temp(i,j-1) xor key_mat(i,j);
						end loop;
					end loop;
					
					rcon := rcon *2;
					
					for i in 0 to 3 loop
						for j in 0 to 3 loop
							key_mat(i,j) <= matrix_temp(i,j);
						end loop;
					end loop;
					
					cur_state <= add_round_key;
					
				when add_round_key =>	 		
					text_mat <= add_round_key(text_mat, key_mat);
					counter := counter + 1;
					if(counter = 10)then
						cur_state <= round10_sub_bytes;
						counter := 0;
					else
						cur_state <= text_sub_bytes;
					end if;
					
				when round10_sub_bytes =>
					text_mat <= sub_bytes(text_mat);
					cur_state <= round10_shift_rows;
					
				when round10_shift_rows =>
					text_mat <= shift_rows(text_mat);
					cur_state <= round10_key_schedule;
				
				when round10_key_schedule =>
					matrix_temp(0,0) := key_mat(1,3);
					matrix_temp(1,0) := key_mat(2,3);
					matrix_temp(2,0) := key_mat(3,3);
					matrix_temp(3,0) := key_mat(0,3);
				
					array_temp := (matrix_temp(0,0), matrix_temp(1,0), matrix_temp(2,0),matrix_temp(3,0));
					array_temp := sub_bytes_key(array_temp);
					matrix_temp(0,0) := array_temp(0);
					matrix_temp(1,0) := array_temp(1);
					matrix_temp(2,0) := array_temp(2);
					matrix_temp(3,0) := array_temp(3);
					
					if(counter = 9) then
						rcon := 27;
					elsif (counter = 10)then
						rcon := 54;
					end if;
					
					matrix_temp(0,0) := (key_mat(0,0) xor matrix_temp(0,0)) xor conv_std_logic_vector(rcon, 8);
					matrix_temp(1,0) := key_mat(1,0) xor matrix_temp(1,0);
					matrix_temp(2,0) := key_mat(2,0) xor matrix_temp(2,0);
					matrix_temp(3,0) := key_mat(3,0) xor matrix_temp(3,0);
				
					for i in 0 to 3 loop
						for j in 1 to 3 loop
							matrix_temp(i,j) := matrix_temp(i,j-1) xor key_mat(i,j);
						end loop;
					end loop;
					
					for i in 0 to 3 loop
						for j in 0 to 3 loop
							key_mat(i,j) <= matrix_temp(i,j);
						end loop;
					end loop;
					
					cur_state <= round10_add_round_key;

				when round10_add_round_key =>
					text_mat <= add_round_key(text_mat, key_mat);
					cur_state <= to_array;
					
				when others =>
					cipher_text <= to_array(text_mat);
					cur_state <= load_plain;
					ready<='1';
				
				end case;
			
		end if;
	end process;
	
end Behavioral;

