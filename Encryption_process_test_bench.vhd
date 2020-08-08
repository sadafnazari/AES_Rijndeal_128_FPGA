--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:26:56 02/02/2020
-- Design Name:   
-- Module Name:   D:/University/FPGA/Project/AES_Rijndael_Cipher/Encryption_process_test_bench.vhd
-- Project Name:  AES_Rijndael_Cipher
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Encryption_process
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY Encryption_process_test_bench IS
END Encryption_process_test_bench;
 
ARCHITECTURE behavior OF Encryption_process_test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Encryption_process
    PORT(
         clk : IN  std_logic;
         start : IN  std_logic;
         plain_text : IN  std_logic_vector(127 downto 0);
         cipher_key : IN  std_logic_vector(127 downto 0);
         cipher_text : OUT  std_logic_vector(127 downto 0);
         ready : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal plain_text : std_logic_vector(127 downto 0) := (others => '0');
   signal cipher_key : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal cipher_text : std_logic_vector(127 downto 0);
   signal ready : std_logic;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Encryption_process PORT MAP (
          clk => clk,
          start => start,
          plain_text => plain_text,
          cipher_key => cipher_key,
          cipher_text => cipher_text,
          ready => ready
        );
	clk <= NOT(clk) after 100 ns;
	start<='1' after 10 ns;
	plain_text <= X"328831e0435a3137f6309807a88da234" after 100 ns;   
	cipher_key <= X"2b28ab097eaef7cf15d2154f16a6883c" after 100 ns;

END;
