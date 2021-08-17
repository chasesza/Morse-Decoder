----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/15/2021 05:43:57 PM
-- Design Name: 
-- Module Name: spi - RTL
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

entity spi is
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (7 downto 0);
           new_input : in STD_LOGIC;
           sclk : out STD_LOGIC;
           mosi : out STD_LOGIC;
           n_cs : out STD_LOGIC);
end spi;

architecture RTL of spi is

signal n_cs_signal : STD_LOGIC := '1';
signal prev_new_input : STD_LOGIC;
signal data : STD_LOGIC_VECTOR(7 downto 0);
signal current_bit : integer range 0 to 7;
signal next_sclk : STD_LOGIC;
signal last_bit : STD_LOGIC;

begin
    n_cs <= n_cs_signal;

    clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            -- used to detect whether this is new input or potentially a couple clocks old
            prev_new_input <= new_input;
            
            --handles the spi output
            if n_cs_signal = '0' then
                sclk <= next_sclk;
                next_sclk <= not next_sclk;
                
                --prep new bit
                if next_sclk = '0' then
                    if last_bit = '1' then
                        n_cs_signal <= '1';
                    else
                        mosi <= data(current_bit);
                        if current_bit = 0 then
                            last_bit <= '1';
                        else
                            current_bit <= current_bit - 1;
                        end if;
                    end if;
                end if;
            --gets new data to send
            elsif new_input = '1' and prev_new_input /= '1' then
                data <= d;
                current_bit <= 7;
                next_sclk <= '0';
                sclk <= '0';
                n_cs_signal <= '0';
                last_bit <= '0';
            end if;
        end if;
    end process clk_proc;


end RTL;

