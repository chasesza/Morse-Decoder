--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   02:48:49 06/12/2021
-- Design Name:   
-- Module Name:   /home/ise/MorseDecoder/morse_decoder_fsm_test_bench.vhd
-- Project Name:  MorseDecoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: fsm
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
 
ENTITY morse_decoder_fsm_test_bench IS
END morse_decoder_fsm_test_bench;
 
ARCHITECTURE behavior OF morse_decoder_fsm_test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fsm
    PORT(
         dot : IN  std_logic;
         dash : IN  std_logic;
         clk : IN  std_logic;
         z : OUT  std_logic_vector(5 downto 0);
         update : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal dot : std_logic := '0';
   signal dash : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal z : std_logic_vector(5 downto 0);
   signal update : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fsm PORT MAP (
          dot => dot,
          dash => dash,
          clk => clk,
          z => z,
          update => update
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 
		wait until clk = '1';
		dot <= '0';
		dash <= '0';
		
		--Q
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '1';
		dash <= '0';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '0';
		
		--S
		wait until clk = '1';
		dot <= '1';
		dash <= '0';
		wait until clk = '1';
		dot <= '1';
		dash <= '0';
		wait until clk = '1';
		dot <= '1';
		dash <= '0';
		wait until clk = '1';
		dot <= '0';
		dash <= '0';
		
		--O
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		
		--2
		dot <= '0';
		dash <= '0';
		wait until clk = '1';
		dot <= '1';
		dash <= '0';
		wait until clk = '1';
		dot <= '1';
		dash <= '0';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '0';
		
		--0
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '0';
		
		--0
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '0';
		
		--1
		wait until clk = '1';
		dot <= '1';
		dash <= '0';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '1';
		wait until clk = '1';
		dot <= '0';
		dash <= '0';
		
      wait;
   end process;

END;
