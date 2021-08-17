----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/19/2021 08:42:37 PM
-- Design Name: 
-- Module Name: data_storage_to_screen_test_bench - Behavioral
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

entity data_storage_to_screen_test_bench is
--  Port ( );
end data_storage_to_screen_test_bench;

architecture Behavioral of data_storage_to_screen_test_bench is

    component oled_communication is
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
    end component;
    
    component input_converter is
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC;
           new_data : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (7 downto 0);
           update : out STD_LOGIC);
    end component;
    
    component image_data_storage is
        Port ( clk : in STD_LOGIC;
               new_data : in STD_LOGIC;
               d : in STD_LOGIC_VECTOR (7 downto 0);
               read_from_top : in STD_LOGIC;
               output_next_data : in STD_LOGIC;
               q : out STD_LOGIC_VECTOR (7 downto 0);
               new_character : out STD_LOGIC;
               last_data : out STD_LOGIC
             );
    end component;

    signal clk : STD_LOGIC := '0';
    signal q_image_data_storage: STD_LOGIC_VECTOR(7 downto 0);
    signal new_character: STD_LOGIC;
    signal get_next_data: STD_LOGIC;
    signal goto_first_data: STD_LOGIC;
    signal q_input_converter : STD_LOGIC_VECTOR(7 downto 0);
    signal update_input_converter: STD_LOGIC;
    signal last_data: STD_LOGIC;
    
    signal power_off : STD_LOGIC := '0';
    signal data_n_cmd : STD_LOGIC;
    signal n_vbat : STD_LOGIC;
    signal n_vdd : STD_LOGIC;
    signal n_rst: STD_LOGIC;
    signal sclk : STD_LOGIC;
    signal mosi : STD_LOGIC;
    signal n_cs : STD_LOGIC;
    
    signal d_input_converter : STD_LOGIC := '0';
    signal new_data_input_converter : STD_LOGIC := '0';
    
begin
    
    inst_oled_com: oled_communication
    port map(
        clk => clk,
        power_off => power_off,
        d => q_image_data_storage,
        new_character => new_character,
        last_data => last_data,
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
    
    inst_input_converter: input_converter
    port map(
        clk => clk,
        d => d_input_converter,
        new_data => new_data_input_converter,
        q => q_input_converter,
        update => update_input_converter
    );
    
    inst_image_data_storage: image_data_storage
    port map(
        clk => clk,
        new_data => update_input_converter,
        d => q_input_converter,
        read_from_top => goto_first_data,
        output_next_data => get_next_data,
        q => q_image_data_storage,
        new_character => new_character,
        last_data => last_data
    );

    clk_proc: process
    begin
        wait for 100 ns;
        clk <= not clk;
    end process clk_proc;
    
    stim_proc: process
    begin
        wait for 150 ms;
            d_input_converter <= '1';
            wait until clk = '0';
            new_data_input_converter <= '1';
            wait until clk = '0';
            new_data_input_converter <= '0';
            
            
            wait until clk = '0';
            new_data_input_converter <= '1';
            wait until clk = '0';
            new_data_input_converter <= '0';
            
            
            wait until clk = '0';
            new_data_input_converter <= '1';
            wait until clk = '0';
            new_data_input_converter <= '0';
            
            
            wait until clk = '0';
            new_data_input_converter <= '1';
            wait until clk = '0';
            new_data_input_converter <= '0';
            
            
            wait until clk = '0';
            new_data_input_converter <= '1';
            wait until clk = '0';
            new_data_input_converter <= '0';
            
            wait for 5 ms;
            
            wait until clk = '0';
            new_data_input_converter <= '1';
            wait until clk = '0';
            new_data_input_converter <= '0';
            
            
            wait until clk = '0';
            new_data_input_converter <= '1';
            wait until clk = '0';
            new_data_input_converter <= '0';
        wait;
    end process stim_proc;

end Behavioral;
