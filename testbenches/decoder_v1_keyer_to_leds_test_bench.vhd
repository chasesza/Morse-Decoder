----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/01/2021 03:17:12 PM
-- Design Name: 
-- Module Name: decoder_v1_keyer_to_leds_test_bench - Behavioral
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

entity decoder_v1_keyer_to_leds_test_bench is
end decoder_v1_keyer_to_leds_test_bench;

architecture Behavioral of decoder_v1_keyer_to_leds_test_bench is

    component decoder_instantiation_v1_keyer_to_leds is
    Port(
          CLK100MHZ : in STD_LOGIC;
          ck_io0    : in STD_LOGIC;
          sw       : in STD_LOGIC_VECTOR (3 downto 0);
          led      : out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;

    signal clk: std_logic := '0';
    signal d: std_logic := '1';
    signal sw : std_logic_vector (3 downto 0) := "0000";
    signal led : std_logic_vector (3 downto 0);
    
    constant clk_period : time:= 100 ns;
begin

    uut: decoder_instantiation_v1_keyer_to_leds PORT MAP(
        CLK100MHZ => clk,
        ck_io0 => d,
        sw => sw,
        led => led
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
		d <= '0';
		wait for 39 ms;
		d <= '1';
		wait for 13 ms;
		
		--92 wpm dot
		d <= '0';
		wait for 13 ms;
		d <= '1';
		wait for 13 ms;
		
		wait for 65 ms; -- space (when combined with previous 13ms wait)
		wait for 6 ms; -- de-synchronize timing
		
		--92 wpm dot
		d <= '0';
		wait for 13 ms;
		d <= '1';
		wait for 13 ms;
		
		--92 wpm dah
		d <= '0';
		wait for 39 ms;
		d <= '1';
		wait for 13 ms;
		
        wait;
    end process;

end Behavioral;
