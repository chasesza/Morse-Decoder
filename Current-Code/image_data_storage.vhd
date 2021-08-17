----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/04/2021 02:54:03 PM
-- Design Name: 
-- Module Name: image_data_storage - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: If new_data is high, the d vector will be added to the bottom page. If the bottom page is filled,
--                      the pages will be shifted up. 
--                      If output_next_data is high, the next vector will be output to q and the output_column (and/or output_page)
--                      will be incremented. 
--                      If read_from_top is high, output_column and ouput_page will be set to '0' for the next clock cycle.
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

entity image_data_storage is
    Port ( clk : in STD_LOGIC;
           new_data : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (7 downto 0);
           read_from_top : in STD_LOGIC;
           output_next_data : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (7 downto 0);
           new_character : out STD_LOGIC;
           last_data : out STD_LOGIC
         );
end image_data_storage;

architecture RTL of image_data_storage is

constant max_column : integer := 127;
constant max_page_data_index : integer := 7;
constant max_page : integer := 3;

type page_type is array (max_column downto 0) of std_logic_vector(max_page_data_index downto 0);
type screen_type is array (max_page downto 0) of page_type;
signal screen : screen_type := (others=>(others=>(others=>'0')));

--                  max_column,         ..,     col3,               col2,               col1,               col0
--
--      MaxPage     mPgDataIndx..0,     ..,     mPgDataIndx..0,     mPgDataIndx..0,     mPgDataIndx..0,     mPgDataIndx..0
--      .           mPgDataIndx..0,     ..,     mPgDataIndx..0,     mPgDataIndx..0,     mPgDataIndx..0,     mPgDataIndx..0
--      Page1       mPgDataIndx..0,     ..,     mPgDataIndx..0,     mPgDataIndx..0,     mPgDataIndx..0,     mPgDataIndx..0
--      Page0       mPgDataIndx..0,     ..,     mPgDataIndx..0,     mPgDataIndx..0,     mPgDataIndx..0,     mPgDataIndx..0

signal col : integer range 0 to max_column := max_column;

signal output_column : integer range 0 to max_column := max_column;
signal output_page  : integer range 0 to max_page := max_page;

constant empty_page : page_type := (others=>(others=>'0'));

signal prev_new_data : std_logic := '0';

signal sent_new_data_signal: std_logic := '1';

begin

    clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            prev_new_data <= new_data;
            
            --store new data
            if new_data = '1' then
                --store new data
                screen(0)(col) <= d;
             
                --increment col
                if col > 0 then
                    col <= col - 1; 
                else --shift pages up, reset col
                    screen <= screen(max_page-1 downto 0) & empty_page;
                    col <= max_column;
                end if;
                
                --there is new data that hasn't been sent
                sent_new_data_signal <= '0';
                
                --new character not done yet
                new_character <= '0';
            elsif new_data = '0' and prev_new_data = '0' and sent_new_data_signal = '0' then
                new_character <= '1';
                sent_new_data_signal <= '1';
            else
                new_character <= '0';
            end if;
            
            --output next data
            if output_next_data  = '1' then
                --output current vector
                q <= screen(output_page)(output_column);
                
                --go to next vector
                if output_column > 0 then
                    output_column <= output_column - 1;
                else
                    --rollover column
                    output_column <= max_column;
                    --go to next page
                    if output_page > 0 then
                        output_page <= output_page - 1;
                    --rollover page
                    else
                        output_page <= max_page;
                        last_data <= '1';
                    end if;
                end if;    
            end if;
            
            --set next output vector to the top left corner if read_from_top is high
            if  read_from_top = '1' then
                output_page <= max_page;
                output_column <= max_column;
                last_data <= '0';
            end if;
            
        end if;
    end process clk_proc;

end RTL;
