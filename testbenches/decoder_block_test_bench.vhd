----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/01/2021 11:57:47 AM
-- Design Name: 
-- Module Name: decoder_block_test_bench - Behavioral
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

entity decoder_block_test_bench is
end decoder_block_test_bench;

architecture Behavioral of decoder_block_test_bench is
    component decoder_block is
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC;
           rst : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (5 downto 0);
           update : out STD_LOGIC);
    end component;
    
    --Inputs
    signal clk : STD_LOGIC := '0';
    signal d : STD_LOGIC := '0';
    signal rst : STD_LOGIC := '0';
    
    --Outputs
    signal z : STD_LOGIC_VECTOR (5 downto 0);
    signal update : STD_LOGIC;
    
    --Constants
    constant clk_period : time := 0.2 us;
    
begin

    uut: decoder_block PORT MAP(
        clk => clk,
        d => d,
        rst => rst,
        z => z,
        update => update
    );
    
    clk_process: process
        begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    stim_proc: process
    begin
        
        --Let project settle
        wait for 10 ms;
        
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
		
		wait for 65 ms; -- space (when combined with previous 13ms wait)
		wait for 6 ms; -- de-synchronize timing
		
		--92 wpm dot
		d <= '1';
		wait for 13 ms;
		d <= '0';
		wait for 13 ms;
		
		--92 wpm dah
		d <= '1';
		wait for 39 ms;
		d <= '0';
		wait for 13 ms;
		
        wait;
    end process;

end Behavioral;
