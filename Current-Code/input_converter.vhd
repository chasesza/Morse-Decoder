----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/07/2021 12:07:26 PM
-- Design Name: 
-- Module Name: input_converter - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Converts character codes to 8x8 pixel images.
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

entity input_converter is
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (5 downto 0);
           new_data : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (7 downto 0);
           update : out STD_LOGIC);
end input_converter;

architecture RTL of input_converter is

type char_image is array(5 downto 0) of STD_LOGIC_VECTOR(7 downto 0);
signal char_to_output : char_image;

--6 x 6 font with one pixel spacing on top and bottom
constant char_a : char_image := ("01111100", "01111110", "00010010", "00010010", "01111110", "01111100");
constant char_b : char_image := ("01111110", "01111110", "01001010", "01001010", "01111110", "00110100");
constant char_c : char_image := ("00111100", "01111110", "01000010", "01000010", "01100110", "00100100");
constant char_d : char_image := ("01111110", "01111110", "01000010", "01000010", "01111110", "00111100");
constant char_e : char_image := ("01111110", "01111110", "01001010", "01001010", "01001010", "01000010");
constant char_f : char_image := ("01111110", "01111110", "00010010", "00010010", "00010010", "00000010");
constant char_g : char_image := ("00111100", "01111110", "01000010", "01010010", "01110110", "01110100");
constant char_h : char_image := ("01111110", "01111110", "00001000", "00001000", "01111110", "01111110");
constant char_i : char_image := ("00000000", "01000010", "01111110", "01111110", "01000010", "00000000");
constant char_j : char_image := ("00100000", "01100000", "01000000", "01000010", "01111110", "00111110");
constant char_k : char_image := ("01111110", "01111110", "00011000", "00111100", "01100110", "01000010");
constant char_l : char_image := ("01111110", "01111110", "01000000", "01000000", "01000000", "01000000");
constant char_m : char_image := ("01111110", "01111110", "00001100", "00011000", "00001100", "01111110");
constant char_n : char_image := ("01111110", "01111110", "00001100", "00011000", "00110000", "01111110");
constant char_o : char_image := ("00111100", "01111110", "01000010", "01000010", "01111110", "00111100");
constant char_p : char_image := ("01111110", "01111110", "00010010", "00010010", "00011110", "00001100");
constant char_q : char_image := ("00111100", "01111110", "01000010", "01010010", "00111110", "01011100");
constant char_r : char_image := ("01111110", "01111110", "00010010", "00010010", "01111110", "01101100");
constant char_s : char_image := ("00100100", "01101110", "01001010", "01001010", "01111010", "00110000");
constant char_t : char_image := ("00000010", "00000010", "01111110", "01111110", "00000010", "00000010");
constant char_u : char_image := ("00111110", "01111110", "01000000", "01000000", "01111110", "00111110");
constant char_v : char_image := ("00011110", "00111110", "01100000", "01100000", "00111110", "00011110");
constant char_w : char_image := ("01111110", "01111110", "00110000", "00011000", "00110000", "01111110");
constant char_x : char_image := ("01100110", "01111110", "00011000", "00011000", "01111110", "01100110");
constant char_y : char_image := ("00001110", "00011110", "01110000", "01110000", "00011110", "00001110");
constant char_z : char_image := ("01100010", "01110010", "01111010", "01011110", "01001110", "01000110");
constant char_0 : char_image := ("00111100", "01111110", "01010010", "01001010", "01111110", "00111100");
constant char_1 : char_image := ("00000000", "01000100", "01111110", "01111110", "01000000", "00000000");
constant char_2 : char_image := ("01100100", "01110110", "01010010", "01010010", "01011110", "01001100");
constant char_3 : char_image := ("00100000", "01100010", "01001010", "01001010", "01111110", "00110100");
constant char_4 : char_image := ("00110000", "00111000", "00101100", "01111110", "01111110", "00100000");
constant char_5 : char_image := ("00101110", "01101110", "01001010", "01001010", "01111010", "00110000");
constant char_6 : char_image := ("00111100", "01111110", "01001010", "01001010", "01111010", "00110000");
constant char_7 : char_image := ("00000110", "00000110", "01100010", "01110010", "00011110", "00001110");
constant char_8 : char_image := ("00110100", "01111110", "01001010", "01001010", "01111110", "00110100");
constant char_9 : char_image := ("00001100", "01011110", "01010010", "01010010", "01111110", "00111100");
constant char_space : char_image := ("00000000", "00000000", "00000000", "00000000", "00000000", "00000000");

--fsm outputs for chars
constant input_vector_a : STD_LOGIC_VECTOR(5 downto 0) := ("000000");
constant input_vector_b : STD_LOGIC_VECTOR(5 downto 0) := ("000001");
constant input_vector_c : STD_LOGIC_VECTOR(5 downto 0) := ("000010");
constant input_vector_d : STD_LOGIC_VECTOR(5 downto 0) := ("000011");
constant input_vector_e : STD_LOGIC_VECTOR(5 downto 0) := ("000100");
constant input_vector_f : STD_LOGIC_VECTOR(5 downto 0) := ("000101");
constant input_vector_g : STD_LOGIC_VECTOR(5 downto 0) := ("000110");
constant input_vector_h : STD_LOGIC_VECTOR(5 downto 0) := ("000111");
constant input_vector_i : STD_LOGIC_VECTOR(5 downto 0) := ("001000");
constant input_vector_j : STD_LOGIC_VECTOR(5 downto 0) := ("001001");
constant input_vector_k : STD_LOGIC_VECTOR(5 downto 0) := ("001010");
constant input_vector_l : STD_LOGIC_VECTOR(5 downto 0) := ("001011");
constant input_vector_m : STD_LOGIC_VECTOR(5 downto 0) := ("001100");
constant input_vector_n : STD_LOGIC_VECTOR(5 downto 0) := ("001101");
constant input_vector_o : STD_LOGIC_VECTOR(5 downto 0) := ("001110");
constant input_vector_p : STD_LOGIC_VECTOR(5 downto 0) := ("001111");
constant input_vector_q : STD_LOGIC_VECTOR(5 downto 0) := ("010000");
constant input_vector_r : STD_LOGIC_VECTOR(5 downto 0) := ("010001");
constant input_vector_s : STD_LOGIC_VECTOR(5 downto 0) := ("010010");
constant input_vector_t : STD_LOGIC_VECTOR(5 downto 0) := ("010011");
constant input_vector_u : STD_LOGIC_VECTOR(5 downto 0) := ("010100");
constant input_vector_v : STD_LOGIC_VECTOR(5 downto 0) := ("010101");
constant input_vector_w : STD_LOGIC_VECTOR(5 downto 0) := ("010110");
constant input_vector_x : STD_LOGIC_VECTOR(5 downto 0) := ("010111");
constant input_vector_y : STD_LOGIC_VECTOR(5 downto 0) := ("011000");
constant input_vector_z : STD_LOGIC_VECTOR(5 downto 0) := ("011001");
constant input_vector_0 : STD_LOGIC_VECTOR(5 downto 0) := ("011010");
constant input_vector_1 : STD_LOGIC_VECTOR(5 downto 0) := ("011011");
constant input_vector_2 : STD_LOGIC_VECTOR(5 downto 0) := ("011100");
constant input_vector_3 : STD_LOGIC_VECTOR(5 downto 0) := ("011101");
constant input_vector_4 : STD_LOGIC_VECTOR(5 downto 0) := ("011110");
constant input_vector_5 : STD_LOGIC_VECTOR(5 downto 0) := ("011111");
constant input_vector_6 : STD_LOGIC_VECTOR(5 downto 0) := ("100000");
constant input_vector_7 : STD_LOGIC_VECTOR(5 downto 0) := ("100001");
constant input_vector_8 : STD_LOGIC_VECTOR(5 downto 0) := ("100010");
constant input_vector_9 : STD_LOGIC_VECTOR(5 downto 0) := ("100011");
constant input_vector_space : STD_LOGIC_VECTOR(5 downto 0) := ("101011");

signal current_byte : integer range 0 to 7 := 7;
signal outputting : std_logic := '0';

begin

    clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            if outputting = '1' then
                if current_byte = 0 then
                    current_byte <= 7;
                    q <= "00000000";
                    outputting <= '0';
                elsif current_byte = 7 then
                    current_byte <= current_byte - 1;
                    q <= "00000000";
                else
                    current_byte <= current_byte - 1;
                    q <= char_to_output(current_byte-1);
                end if;
                update <= '1';
            elsif new_data = '1'then
                update <= '0';
                outputting <= '1';
                if d = input_vector_a then
                    char_to_output <= char_a;
                elsif d = input_vector_b then
                    char_to_output <= char_b;
                elsif d = input_vector_c then
                    char_to_output <= char_c;
                elsif d = input_vector_d then
                    char_to_output <= char_d;
                elsif d = input_vector_e then
                    char_to_output <= char_e;
                elsif d = input_vector_f then
                    char_to_output <= char_f;
                elsif d = input_vector_g then
                    char_to_output <= char_g;
                elsif d = input_vector_h then
                    char_to_output <= char_h;
                elsif d = input_vector_i then
                    char_to_output <= char_i;
                elsif d = input_vector_j then
                    char_to_output <= char_j;
                elsif d = input_vector_k then
                    char_to_output <= char_k;
                elsif d = input_vector_l then
                    char_to_output <= char_l;
                elsif d = input_vector_m then
                    char_to_output <= char_m;
                elsif d = input_vector_n then
                    char_to_output <= char_n;
                elsif d = input_vector_o then
                    char_to_output <= char_o;
                elsif d = input_vector_p then
                    char_to_output <= char_p;
                elsif d = input_vector_q then
                    char_to_output <= char_q;
                elsif d = input_vector_r then
                    char_to_output <= char_r;
                elsif d = input_vector_s then
                    char_to_output <= char_s;
                elsif d = input_vector_t then
                    char_to_output <= char_t;
                elsif d = input_vector_u then
                    char_to_output <= char_u;
                elsif d = input_vector_v then
                    char_to_output <= char_v;
                elsif d = input_vector_w then
                    char_to_output <= char_w;
                elsif d = input_vector_x then
                    char_to_output <= char_x;
                elsif d = input_vector_y then
                    char_to_output <= char_y;
                elsif d = input_vector_z then
                    char_to_output <= char_z;
                elsif d = input_vector_0 then
                    char_to_output <= char_0;
                elsif d = input_vector_1 then
                    char_to_output <= char_1;
                elsif d = input_vector_2 then
                    char_to_output <= char_2;
                elsif d = input_vector_3 then
                    char_to_output <= char_3;
                elsif d = input_vector_4 then
                    char_to_output <= char_4;
                elsif d = input_vector_5 then
                    char_to_output <= char_5;
                elsif d = input_vector_6 then
                    char_to_output <= char_6;
                elsif d = input_vector_7 then
                    char_to_output <= char_7;
                elsif d = input_vector_8 then
                    char_to_output <= char_8;
                elsif d = input_vector_9 then
                    char_to_output <= char_9;
                elsif d = input_vector_space then
                    char_to_output <= char_space;
                end if;
            else
                update <= '0';
            end if;
        end if;
        
    end process clk_proc;

end RTL;
