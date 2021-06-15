--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:19:59 06/15/2021
-- Design Name:   
-- Module Name:   /home/ise/MorseDecoder/dot_dash_decoder_test_bench.vhd
-- Project Name:  MorseDecoder
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: dot_dash_decoder
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
 
ENTITY dot_dash_decoder_test_bench IS
END dot_dash_decoder_test_bench;
 
ARCHITECTURE behavior OF dot_dash_decoder_test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT dot_dash_decoder
    PORT(
         d : IN  std_logic;
         new_data : IN  std_logic;
         clk : IN  std_logic;
         dot : OUT  std_logic;
         dash : OUT  std_logic;
         too_long : OUT  std_logic;
         update : OUT  std_logic
        );
    END COMPONENT;
    
	COMPONENT fsm
    PORT(
         dot : IN  std_logic;
         dash : IN  std_logic;
         clk : IN  std_logic;
			new_data	: IN std_logic;
         z : OUT  std_logic_vector(5 downto 0);
         update : OUT  std_logic
        );
    END COMPONENT;

   --Inputs
   signal d : std_logic := '0';
   signal new_data : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal dot : std_logic;
   signal dash : std_logic;
   signal too_long : std_logic;
   signal update : std_logic;

	--FSM Outputs
	signal z_fsm	: std_logic_vector(5 downto 0);
	signal update_fsm	: std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	signal clk2 : std_logic := '0';
	
	constant clk2_period : time := 60 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: dot_dash_decoder PORT MAP (
          d => d,
          new_data => new_data,
          clk => clk,
          dot => dot,
          dash => dash,
          too_long => too_long,
          update => update
        );
	
	inst_fsm: fsm PORT MAP (
				dot => dot,
				dash => dash,
				clk => clk,
				new_data => update,
				z => z_fsm,
				update => update_fsm
			);

   -- Clock process definitions
   clk_process: process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;

	clk2_process: process
	begin
		clk2 <= '0';
		wait for clk2_period/2;
		clk2 <= '1';
		wait for clk2_period/2;
	end process;

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here
		
		--a
		--dot
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		--dash
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		-- end letter
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		--n
		--dash
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		--dot
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		-- end letter
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		
		--t
		--dash
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		-- end letter and space
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		--n
		--dash
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		--dot
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		-- end letter
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		
		--a
		--dot
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		--dash
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		-- end letter
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		
		
		--m
		--dash
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		--dash
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		-- end letter
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		
		--e
		--dot
		wait until clk2 = '1';
		d <= '1';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		-- end letter
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
		wait until clk2 = '1';
		d <= '0';
		new_data <= '1';
		wait until clk2 = '0';
		new_data <= '0';
		
      wait;
   end process;

END;
