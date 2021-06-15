----------------------------------------------------------------------------------
-- Name: 				Chase Szafranski
-- 
-- Create Date:  		22:14:10 06/11/2021 
-- Module Name:  		fsm - Behavioral 
-- Project Name: 		Morse Decoder
-- Target Devices:	Arty A7: Artix-7 FPGA Development Board
-- Tool versions:  	ISE 14.7
-- Description: 		Converts the series of dots and dashes to text.
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
	port(
		dot		: in std_logic;
		dash		: in std_logic;
		clk		: in std_logic;
		new_data	: in std_logic;
		z			: out std_logic_vector (5 downto 0);
		update	: out std_logic
		  );
		
end fsm;

architecture Behavioral of fsm is
	type states is (STINVALID, STCLR, STA, STB, STC, STD, STE, STF, STG, STH, STI,
				STJ, STK, STL, STM, STN, STO, STP, STQ, STR, STS,
				STT, STU, STV, STW, STX, STY, STZ, STVE, STUT, STUTE,
				STRT, STBT, STBTE, STBK, STKN, STAS, STAR, STSK, STIMI,
				ST0, ST1, ST2, ST3, ST4, ST5, ST6, ST7, ST8, ST9, STOE, STOT, STSPACE);
	signal pST 	: states := STCLR;
	signal nST	: states;
	signal prev_new_data	: std_logic;

begin
	clk_proc: process(clk)
	begin
		if rising_edge(clk) then
			prev_new_data <= new_data;
			if ( (new_data = '1' or new_data ='H') and (prev_new_data = '0' or prev_new_data = 'L') ) then
				if ( (dot = '0') and (dash = '0') ) then
					nST <= STCLR;
				elsif ( (dot = '1') and (dash = '0') ) then
					case pST is
						when STCLR => nST <= STE;
						when STE => nST <= STI;
						when STI => nST <= STS;
						when STS => nST <= STH;
						when STH => nST <= ST5;
						when STV => nST <= STVE;
						when STU => nST <= STF;
						when STUT => nST <= STUTE;
						when STUTE => nST <= STIMI;
						when STA => nST <= STR;
						when STR => nST <= STL;
						when STL => nST <= STAS;
						when STRT => nST <= STAR;
						when STW => nST <= STP;
						when STT => nST <= STN;
						when STN => nST <= STD;
						when STD => nST <= STB;
						when STB => nST <= ST6;
						when STBT => nST <= STBTE;
						when STK => nST <= STC;
						when STY => nST <= STKN;
						when STM => nST <= STG;
						when STG => nST <= STZ;
						when STZ => nST <= ST7;
						when STO => nST <= STOE;
						when STOE => nST <= ST8;
						when STOT => nST <= ST9;
						when others => nST <= STINVALID;
					end case;
				elsif ( (dot = '0') and (dash = '1') ) then
					case pST is
						when STCLR => nST <= STT;
						when STT => nST <= STM;
						when STM => nST <= STO;
						when STO => nST <= STOT;
						when STOT => nST <= ST0;
						when STG => nST <= STQ;
						when STN => nST <= STK;
						when STK => nST <= STY;
						when STD => nST <= STX;
						when STB => nST <= STBT;
						when STBTE => nST <= STBK;
						when STE => nST <= STA;
						when STA => nST <= STW;
						when STW => nST <= STJ;
						when STJ => nsT <= ST1;
						when STR => nST <= STRT;
						when STI => nST <= STU;
						when STU => nST <= STUT;
						when STUT => nST <= ST2;
						when STS => nST <= STV;
						when STV => nST <= ST3;
						when STVE => nST <= STSK;
						when STH => nST <= ST4;
						when others => nST <= STINVALID;
					end case;
				elsif ( (dot = '1') and (dash = '1') ) then
					nST <= STSPACE;
				else
					nST <= STINVALID;
				end if;
			end if;
		end if;
	end process clk_proc;
	
	st_update_proc: process(nST)
	begin
		--A = 0 -> Z = 25
		--0 = 26 -> 9 = 35
		--IMI/? = 36, SK = 37, AS = 38
		--AR = 39, BT = 40, BK = 41, KN = 42
		--Space = 43, Invalid = 44
		if nST = STCLR then
			case pST is
				when STA => z <= "000000";
				when STB => z <= "000001";
				when STC => z <= "000010";
				when STD => z <= "000011";
				when STE => z <= "000100";
				when STF => z <= "000101";
				when STG => z <= "000110";
				when STH => z <= "000111";
				when STI => z <= "001000";
				when STJ => z <= "001001";
				when STK => z <= "001010";
				when STL => z <= "001011";
				when STM => z <= "001100";
				when STN => z <= "001101";
				when STO => z <= "001110";
				when STP => z <= "001111";
				when STQ => z <= "010000";
				when STR => z <= "010001";
				when STS => z <= "010010";
				when STT => z <= "010011";
				when STU => z <= "010100";
				when STV => z <= "010101";
				when STW => z <= "010110";
				when STX => z <= "010111";
				when STY => z <= "011000";
				when STZ => z <= "011001";
				when ST0 => z <= "011010";
				when ST1 => z <= "011011";
				when ST2 => z <= "011100";
				when ST3 => z <= "011101";
				when ST4 => z <= "011110";
				when ST5 => z <= "011111";
				when ST6 => z <= "100000";
				when ST7 => z <= "100001";
				when ST8 => z <= "100010";
				when ST9 => z <= "100011";
				when STIMI => z <= "100100";
				when STSK => z <= "100101";
				when STAS => z <= "100110";
				when STAR => z <= "100111";
				when STBT => z <= "101000";
				when STBK => z <= "101001";
				when STKN => z <= "101010";
				when STSPACE => z <= "101011";
				when others => z <= "101100"; -- 44, code for invalid 
			end case;
			update <= '1';
			pST <= nST;
		elsif nST = STINVALID then
			z <= "101100";	-- 44, code for invalid 
			pST <= STCLR;
			update <= '1';
		elsif nST = STSPACE then
			z <= "101011";
			pST <= STCLR;
			update <= '1';
		else
			pST <= nST;
			update <= '0';
		end if;
	end process st_update_proc;

end Behavioral;

