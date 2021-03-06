----------------------------------------------------------------------------------
-- Created by: 				Chase Szafranski
-- 
-- Create Date:    	    23:23:49 06/14/2021
-- Module Name:    	    dot_dash_decoder - RTL 
-- Project Name: 	 	Morse Decoder
-- Target Devices: 	    Arty A7: Artix-7 FPGA Development Board
-- Tool versions: 	    Vivado
-- Description: 		Converts morse units to dots and dashes
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity dot_dash_decoder is
    Port ( d : in  STD_LOGIC;
           new_data : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           dot : out  STD_LOGIC;
           dash : out  STD_LOGIC;
			  too_long	: out STD_LOGIC;
           update : out  STD_LOGIC);
end dot_dash_decoder;

architecture RTL of dot_dash_decoder is

	type states is (STIDLE, STOFF, STON);

	signal pST : states := STIDLE;
	signal nST : states;
	signal prev_new_data : std_logic;
	signal counter : integer range 0 to 6;

begin

	clk_proc: process(clk)
	begin
		if rising_edge(clk) then
			prev_new_data <= new_data;
			update <= '0';
			too_long <= '0';
			if ( (new_data = '1' or new_data = 'H') and (prev_new_data = '0' or prev_new_data ='L') ) then
				if pST = STIDLE then
					if d = '1' then --first dot unit
						pST <= STON;
						counter <= 0;
					else
						pST <= STIDLE;
					end if;
				elsif pST = STON then
					if d = '1' then
						if counter > 4 then -- indicate that the current morse signal unit is too long
							counter <= 0;
							too_long <= '1';
							pST <= STIDLE;
						else  -- add one to the unit counter
							counter <= counter + 1;
							pST <= STON;
						end if;
					else -- end of morse unit
						counter <= 0;
						if counter < 2 then -- dot
							update <= '1';
							dot <= '1';
							dash <= '0';
							pST <= STOFF;
						elsif counter < 5 then -- dash
							update <= '1';
							dot <= '0';
							dash <= '1';
							pST <= STOFF;
						else -- signal is too long
							too_long <= '1';
							pST <= STOFF;
						end if;
					end if;
				else -- pST = STOFF
					if d = '1' then
						counter <= 0;
						if counter < 2 then --new morse signal
							pST <= STON;
						elsif counter < 5 then -- new character
							update <= '1';
							dot <= '0';
							dash <= '0';
							pST <= STON;
						else -- space
							update <= '1';
							dot <= '1';
							dash <= '1';
							pST <= STON;
						end if;
					else
						-- sends a new character on the third time unit
						-- first unit sets counter = 0, second sets to 1, third sets to 2
						if counter = 2 then
							update <= '1';
							dot <= '0';
							dash <= '0';
							pST <= STOFF;
						end if;
						
						if counter < 5 then
							counter <= counter + 1;
							pST <= STOFF;
						else -- send space and wait for new input 
							counter <= 0;
							update <= '1';
							dot <= '1';
							dash <= '1';
							pST <= STIDLE;
						end if;
					end if;
				end if;
			end if;
		end if;
	end process clk_proc;

end RTL;

