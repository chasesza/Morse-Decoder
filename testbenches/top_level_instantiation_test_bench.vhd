----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/19/2021 07:29:28 PM
-- Design Name: 
-- Module Name: top_level_instantiation_test_bench - Behavioral
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

entity top_level_instantiation_test_bench is
--  Port ( );
end top_level_instantiation_test_bench;

architecture Behavioral of top_level_instantiation_test_bench is

    component top_level_instantiation is
        Port ( CLK100MHZ : in STD_LOGIC; --100MHz clk
            sw : in STD_LOGIC_VECTOR(3 downto 0); --switches, sw[3] = poweroff, sw[0] = d
            btn : in STD_LOGIC_VECTOR(3 downto 0);
            ja : out STD_LOGIC_VECTOR(7 downto 0) --pmod header A
          );
    end component;

    signal CLK100MHZ : STD_LOGIC := '0';
    signal sw : STD_LOGIC_VECTOR(3 downto 0);
    signal btn : STD_LOGIC_VECTOR(3 downto 0);
    signal ja : STD_LOGIC_VECTOR(7 downto 0);
    
begin

    uut: top_level_instantiation
    port map(
        CLK100MHZ => CLK100MHZ,
        sw => sw,
        btn => btn,
        ja => ja
    );
    
    clk_proc: process
    begin
        wait for 5 ns;
        CLK100MHZ <= not CLK100MHZ;
    end process clk_proc;
    
    stim_proc: process
    begin
        btn <= "0000";
        sw <= "0000";
        
        wait for 150 ms;
        
        sw(0) <= '1';
        
        btn(3) <= '1';
        wait for 200 ns;
        btn(3) <= '0';
        
        wait;
    end process stim_proc;

end Behavioral;
