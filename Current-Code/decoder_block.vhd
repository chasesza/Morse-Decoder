----------------------------------------------------------------------------------
-- Created by:                Chase Szafranski
-- 
-- Create Date:         07/01/2021 11:44:04 AM
-- Module Name:         decoder_block - RTL
-- Project Name:        Morse Decoder
-- Target Devices:      Arty A7: Artix-7 FPGA Development Board
-- Tool versions:  	    Vivado 2020.2
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

entity decoder_block is
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC;
           rst : in STD_LOGIC;
           z : out STD_LOGIC_VECTOR (5 downto 0);
           update : out STD_LOGIC
          );
end decoder_block;

architecture RTL of decoder_block is

 COMPONENT filter is
    Port ( d : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           too_long : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           q : out  STD_LOGIC;
           update : out  STD_LOGIC);
    end COMPONENT;
 
    COMPONENT dot_dash_decoder
    PORT(
         d : IN  std_logic;
         new_data : IN  std_logic;
         clk : IN  std_logic;
         dot : OUT  std_logic;
         dash : OUT  std_logic;
         too_long : OUT  std_logic;
         update : OUT  std_logic
        );
    END COMPONENT;
    
	COMPONENT fsm
    PORT(
         dot : IN  std_logic;
         dash : IN  std_logic;
         clk : IN  std_logic;
		 new_data	: IN std_logic;
         z : OUT  std_logic_vector(5 downto 0);
         update : OUT  std_logic
        );
    END COMPONENT;
    
    --Filter output
    signal q_filter : std_logic;
    signal update_filter : std_logic;
    
    --Dot_dash_decoder_output
    signal dot : std_logic;
    signal dash : std_logic;
    signal too_long : std_logic;
    signal update_dot_dash_decoder : std_logic;
    
    

begin
     inst_filter: filter PORT MAP(
        d => d,
        clk => clk,
        too_long => too_long,
        rst => rst,
        q => q_filter,
        update => update_filter
    );
	
   inst_dot_dash_decoder: dot_dash_decoder PORT MAP (
          d => q_filter,
          new_data => update_filter,
          clk => clk,
          dot => dot,
          dash => dash,
          too_long => too_long,
          update => update_dot_dash_decoder
        );
	
	inst_fsm: fsm PORT MAP (
				dot => dot,
				dash => dash,
				clk => clk,
				new_data => update_dot_dash_decoder,
				z => z,
				update => update
			);

end RTL;
