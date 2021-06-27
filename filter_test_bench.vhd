----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/26/2021 03:57:27 PM
-- Design Name: 
-- Module Name: filter_test_bench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filter_test_bench is
end filter_test_bench;

ARCHITECTURE Behavioral OF filter_test_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT filter is
    Port ( d : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           too_long : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC;
           update : out  STD_LOGIC);
    end COMPONENT;
 
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
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal q_filter : std_logic;

 	--Outputs
   signal dot : std_logic;
   signal dash : std_logic;
   signal too_long : std_logic;
   signal update_filter : std_logic;
   
   signal update_dot_dash_decoder : std_logic;

	--FSM Outputs
	signal z_fsm	: std_logic_vector(5 downto 0);
	signal update_fsm	: std_logic;

   -- Clock period definitions
   constant clk_period : time := 0.2 us;
	
	signal clk2 : std_logic := '0';
	
	constant clk2_period : time := 60 us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: filter PORT MAP(
        d => d,
        clk => clk,
        too_long => too_long,
        rst => rst,
        q => q_filter,
        update => update_filter
    );
	
   inst_dot_dash_decoder: dot_dash_decoder PORT MAP (
          d => q_filter,
          new_data => update_filter,
          clk => clk,
          dot => dot,
          dash => dash,
          too_long => too_long,
          update => update_dot_dash_decoder
        );
	
	inst_fsm: fsm PORT MAP (
				dot => dot,
				dash => dash,
				clk => clk,
				new_data => update_dot_dash_decoder,
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
		
		--92 wpm dot
		d <= '1';
		wait for 13 ms;
		d <= '0';
		wait for 13 ms;
		
		--92 wpm dash
		d <= '1';
		wait for 39 ms;
		d <= '0';
		wait for 13 ms;
		
		--92 wpm dot
		d <= '1';
		wait for 13 ms;
		d <= '0';
		wait for 13 ms;
				
      wait;
   end process;

END Behavioral;
