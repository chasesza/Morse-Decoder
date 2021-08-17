----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/17/2021 07:25:44 PM
-- Design Name: 
-- Module Name: oled_communication - RTL
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

entity oled_communication is
    Port ( clk : in STD_LOGIC;
           power_off : in STD_LOGIC;
           d: in STD_LOGIC_VECTOR (7 downto 0);
           new_character : in STD_LOGIC;
           last_data : in STD_LOGIC;
           get_next_data : out STD_LOGIC;
           goto_first_data : out STD_LOGIC;
           data_n_cmd : out STD_LOGIC;
           n_vbat : out STD_LOGIC;
           n_vdd : out STD_LOGIC;
           n_rst : out STD_LOGIC;
           sclk : out STD_LOGIC;
           mosi : out STD_LOGIC;
           n_cs : out STD_LOGIC);
end oled_communication;

architecture RTL of oled_communication is

    component screen_control is
        Port ( clk : in STD_LOGIC;
           n_cs : in STD_LOGIC;
           power_off : in STD_LOGIC;
           d: in STD_LOGIC_VECTOR (7 downto 0);
           new_character : in STD_LOGIC;
           last_data : in STD_LOGIC;
           get_next_data : out STD_LOGIC;
           goto_first_data : out STD_LOGIC;
           q : out STD_LOGIC_VECTOR (7 downto 0);
           new_output : out STD_LOGIC;
           data_n_cmd : out STD_LOGIC;
           n_vbat : out STD_LOGIC;
           n_vdd : out STD_LOGIC;
           n_rst : out STD_LOGIC);
    end component;

    component spi is
        Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (7 downto 0);
           new_input : in STD_LOGIC;
           sclk : out STD_LOGIC;
           mosi : out STD_LOGIC;
           n_cs : out STD_LOGIC);
    end component;
    
    --Screen control outputs
    signal q_scr_ctl : STD_LOGIC_VECTOR (7 downto 0);
    signal new_output_scr_ctl : STD_LOGIC;
    
    signal n_cs_spi : STD_LOGIC;
    
begin

    inst_screen_ctl: screen_control 
    PORT MAP(
        clk => clk,
        n_cs => n_cs_spi,
        power_off => power_off,
        d => d,
        new_character => new_character,
        last_data => last_data,
        get_next_data => get_next_data,
        goto_first_data => goto_first_data,
        q => q_scr_ctl,
        new_output => new_output_scr_ctl,
        data_n_cmd => data_n_cmd,
        n_vbat => n_vbat,
        n_vdd => n_vdd,
        n_rst => n_rst
    );
    
    inst_spi: spi
    PORT MAP(
        clk => clk,
        d => q_scr_ctl,
        new_input => new_output_scr_ctl,
        sclk => sclk,
        mosi => mosi,
        n_cs => n_cs_spi
    );

    n_cs <= n_cs_spi;

end RTL;
