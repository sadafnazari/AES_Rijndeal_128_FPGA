--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:26:28 02/02/2020
-- Design Name:   
-- Module Name:   D:/Users/RijndaelDecryption/Decryption_process_test.vhd
-- Project Name:  RijndaelDecryption
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Decryption_process
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
 
ENTITY Decryption_process_test IS
END Decryption_process_test;
 
ARCHITECTURE behavior OF Decryption_process_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Decryption_process
    PORT(
         clk : IN  std_logic;
         start : IN  std_logic;
         plain_text : OUT  std_logic_vector(127 downto 0);
         cipher_key : IN  std_logic_vector(127 downto 0);
         cipher_text : IN  std_logic_vector(127 downto 0);
         ready : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal start : std_logic := '0';
   signal cipher_key : std_logic_vector(127 downto 0) := (others => '0');
   signal cipher_text : std_logic_vector(127 downto 0) := (others => '0');

 	--Outputs
   signal plain_text : std_logic_vector(127 downto 0);
   signal ready : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Decryption_process PORT MAP (
          clk => clk,
          start => start,
          plain_text => plain_text,
          cipher_key => cipher_key,
          cipher_text => cipher_text,
          ready => ready
        );
		  
   -- Clock process definitions
   clk <= NOT(clk) after 100 ns;
	start<='1' after 10 ns;
	cipher_text <= X"3902dc1925dc116a8409850b1dfb9732" after 100 ns;   
	cipher_key <= X"2b28ab097eaef7cf15d2154f16a6883c" after 100 ns;

END;
