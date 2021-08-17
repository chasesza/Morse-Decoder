----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2021 08:04:30 PM
-- Design Name: 
-- Module Name: oled_communication_test_bench - Behavioral
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

entity oled_communication_test_bench is
end oled_communication_test_bench;

architecture Behavioral of oled_communication_test_bench is

    component oled_communication is
        Port ( clk : in STD_LOGIC;
           power_off : in STD_LOGIC;
           d: in STD_LOGIC_VECTOR (7 downto 0);
           new_character : in STD_LOGIC;
           get_next_data : out STD_LOGIC;
           goto_first_data : out STD_LOGIC;
           data_n_cmd : out STD_LOGIC;
           n_vbat : out STD_LOGIC;
           n_vdd : out STD_LOGIC;
           n_rst : out STD_LOGIC;
           sclk : out STD_LOGIC;
           mosi : out STD_LOGIC;
           n_cs : out STD_LOGIC);
    end component;

    signal clk : STD_LOGIC := '0';
    signal power_off : STD_LOGIC := '0';
    signal d: STD_LOGIC_VECTOR (7 downto 0);
    signal new_character : STD_LOGIC;
    signal get_next_data : STD_LOGIC;
    signal goto_first_data : STD_LOGIC;
    signal data_n_cmd : STD_LOGIC;
    signal n_vbat : STD_LOGIC;
    signal n_vdd : STD_LOGIC;
    signal n_rst : STD_LOGIC;
    signal sclk : STD_LOGIC;
    signal mosi : STD_LOGIC;
    signal n_cs : STD_LOGIC;

begin

    uut: oled_communication
    PORT MAP(
        clk => clk,
        power_off => power_off,
        d => d,
        new_character => new_character,
        get_next_data => get_next_data,
        goto_first_data => goto_first_data,
        data_n_cmd => data_n_cmd,
        n_vbat => n_vbat,
        n_vdd => n_vdd,
        n_rst => n_rst,
        sclk => sclk,
        mosi => mosi,
        n_cs => n_cs
    );
    
    clk_proc: process
    begin
        clk <= not clk;
        wait for 100 ns;
    end process clk_proc;

    stim_proc: process
    begin
        wait for 150 ms;
        power_off <= '1';
        wait;
    end process stim_proc;

end Behavioral;
