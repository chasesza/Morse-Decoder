----------------------------------------------------------------------------------
-- Created by:                Chase Szafranski
-- 
-- Create Date:         20:39:47 06/15/2021
-- Module Name:         filter - RTL 
-- Project Name: 		Morse Decoder
-- Target Devices:	    Arty A7: Artix-7 FPGA Development Board
-- Tool versions:  	    Vivado
-- Description: 		Determines the speed of the morse code (0.715wpm to 100wpm), then processes
--                      the input as units of the proper time period (12ms for 1wpm to 1.68s for 0.715wpm).
--                      0.715wpm is the minumum speed as it maximizes a counter of 2^23-1 bits at a clock speed of 5MHz.
--                      Note that the maximum speed could be increased beyond 100 wpm, but any faster signal on the air
--                      is almost certainly noise. Morse code that is not computer generated tends to cap at 60wpm.
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

entity filter is
    Port ( d : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           too_long : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC;
           update : out  STD_LOGIC);
end filter;

architecture RTL of filter is

    signal cycle_counter : unsigned (22 downto 0);
    signal input_counter : unsigned (22 downto 0);
    signal unit_length : unsigned (22 downto 0) := (others => '0');
    signal assume_dot : unsigned (22 downto 0) := (others => '0');
    signal assume_dash : unsigned (22 downto 0) := (others => '0');
    signal assume_dash_delay : unsigned (1 downto 0) := "00";
    signal zero_seq_len : unsigned (1 downto 0) := "00";
    signal one_seq_len : unsigned(3 downto 0);
    
    signal wait_for_zero : std_logic;
    
    constant fastest_speed: unsigned (15 downto 0) := "1110101001100000"; -- 6*10^4
    
    type states is (idle, counting, changing_speed);
    signal pST : states := idle;
    
    type counter_type is (dot_counter, dash_counter);
    signal current_counter : counter_type;

begin

    clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            
            if rst = '1' then
                assume_dot <= (others => '0');
                assume_dash <= (others => '0');
                pST <= idle;
            else
                if too_long = '1' then -- fix morse unit length
                    wait_for_zero <= '1'; -- re-synchronize timing
                    zero_seq_len <= (others => '0');
                    if current_counter = dash_counter then --fix the incorrect assumption that the first signal was a dash
                        unit_length <= assume_dot;
                        current_counter <= dot_counter;
                        pST <= counting;
                    else -- something is wrong, reset the unit length
                        assume_dash <= (others => '0');
                        assume_dot <= (others => '0');
                        pST <= idle;
                    end if;
                elsif wait_for_zero = '1' then
                    if zero_seq_len = "11" then
                        zero_seq_len <= (others=>'0');
                        wait_for_zero <= '0';
                    elsif d = '0' then
                        zero_seq_len <= zero_seq_len + 1;
                    else
                        zero_seq_len <= zero_seq_len;
                    end if;
                elsif pST = changing_speed then
                    -- increment the assume_dash counter
                    assume_dot <= assume_dot + 1;
                    if assume_dash_delay = "10" then
                        assume_dash_delay <= "00";
                        assume_dash <= assume_dash + 1;
                    else
                        assume_dash_delay <= assume_dash_delay + 1;
                    end if;
                    if d = '0' then
                        zero_seq_len <= zero_seq_len + 1; -- don't want to stop incrementing the dot length due to a little noise
                        if zero_seq_len = "11" then -- stop incrementing morse unit length
                            zero_seq_len <= "00";
                            unit_length <= assume_dash;
                            assume_dash_delay <= "00";
                            pST <= counting;
                            current_counter <= dash_counter;
                            cycle_counter <= (others => '0');
                            input_counter <= (others => '0');
                            one_seq_len <= (others => '0');
                        else
                            zero_seq_len <= zero_seq_len + 1;
                            pST <= changing_speed;
                        end if;
                    else -- d = '1'
                        zero_seq_len <= "00";
                    end if;
                elsif pST = counting then
                    
                    if cycle_counter >= unit_length then
                        cycle_counter <= (others => '0');
                        input_counter <= (others => '0');
                        if input_counter >= unit_length / 2 then
                            q <= '1';
                        else
                            q <= '0';
                        end if;
                        update <= '1';
                    else
                        update <= '0';
                        cycle_counter <= cycle_counter + 1;
                        if d = '1' then
                            input_counter <= input_counter + 1;
                            if input_counter < cycle_counter/4 then
                                if one_seq_len = "1111" then -- Re-synchronize decoder if the gaps between signals weren't perfect morse units
                                    input_counter <= (others => '0');
                                    cycle_counter <= (others => '0');
                                    if cycle_counter >= unit_length/2 then
                                        q <= '0';
                                        update <= '1';
                                    end if;
                                else
                                    one_seq_len <= one_seq_len + 1;
                                end if;
                            end if;
                        else
                            one_seq_len <= (others => '0');
                            input_counter <= input_counter;
                        end if;
                    end if;
                else
                    if d = '1' then
                        pST <= changing_speed;
                        assume_dash <= (others => '0');
                        assume_dot <= (others => '0');
                    else
                        pST <= idle;
                    end if;
                end if;
            end if;
        end if;
    end process clk_proc;

end RTL;

