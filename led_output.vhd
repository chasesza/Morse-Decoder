----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/01/2021 01:01:38 PM
-- Design Name: 
-- Module Name: led_output - RTL
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity led_output is
    Port ( clk : in STD_LOGIC;
           new_data : in STD_LOGIC;
           rst      : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (5 downto 0);
           z : out STD_LOGIC_VECTOR (3 downto 0));
end led_output;

architecture RTL of led_output is

signal prev_new_data : STD_LOGIC := '0';

begin
    clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            prev_new_data <= new_data;
            if rst = '1' then
                z <= "0000";
            elsif new_data = '1' and prev_new_data /= '1' then
            
                --if d<15 add one and output binary to leds (a=0001, b=0010,...), else turn leds off
                if unsigned(d) < 15 then
                    z <= std_logic_vector(to_unsigned(to_integer(unsigned(d))+1,4));
                else
                    z <= "0000";
                end if; 
            end if;
        end if;
    end process clk_proc;

end RTL;
