----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/15/2021 08:32:21 PM
-- Design Name: 
-- Module Name: three_button_input - RTL
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

entity three_button_input is
    Port(
        clk : in STD_LOGIC;
        space : in STD_LOGIC;
        end_char : in STD_LOGIC;
        dot_in : in STD_LOGIC;
        dash_in : in STD_LOGIC;
        dot_out : out STD_LOGIC;
        dash_out : out STD_LOGIC;
        update : out STD_LOGIC
    );
end three_button_input;

architecture RTL of three_button_input is

signal delay : integer range 0 to 255 := 0;
signal prev_end_char : STD_LOGIC := '0';
signal prev_space : STD_LOGIC := '0';
signal prev_dot : STD_LOGIC := '0';
signal prev_dash : STD_LOGIC := '0';

begin

clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            update <= '0';
            prev_space <= space;
            prev_end_char <= end_char;
            prev_dot <= dot_in;
            prev_dash <= dash_in;
            if delay = 255 then
                --send end char signal
                if end_char = '1' and prev_end_char = '0' then
                    dash_out <= '0';
                    dot_out <= '0';
                    delay <= 0;
                    update <= '1';
                --send space
                elsif space = '1' and prev_space = '0' then
                    dash_out <= '1';
                    dot_out <= '1';
                    delay <= 0;
                    update <= '1';
                --send new input
                elsif (dot_in = '1' and prev_dot = '0') or (dash_in = '1' and prev_dash = '0') then
                    dash_out <= dash_in;
                    dot_out <= dot_in;
                    delay <= 0;
                    update <= '1';
                end if;
            else
                delay <= delay + 1;
            end if;
            
        end if;
        
    end process clk_proc;

end RTL;
