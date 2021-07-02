----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/01/2021 02:34:10 PM
-- Design Name: 
-- Module Name: decoder_instantiation_v1_keyer_to_leds - RTL
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

entity decoder_instantiation_v1_keyer_to_leds is
    Port(
          CLK100MHZ : in STD_LOGIC;
          ck_io0    : in STD_LOGIC;
          sw0       : in STD_LOGIC;
          led      : out STD_LOGIC_VECTOR (3 downto 0)
        );
end decoder_instantiation_v1_keyer_to_leds;

architecture RTL of decoder_instantiation_v1_keyer_to_leds is

    --Vivado Clocking Wizard - 100MHz clock to 5MHz clock signal
    component clk_wiz_0
    port
     (-- Clock in ports
      -- Clock out ports
      clk_out1          : out    std_logic;
      clk_in1           : in     std_logic
     );
    end component;
    
    -- q <= not d, updated every clock cycle
    component keyer_input is
        Port ( clk : in STD_LOGIC;
               d : in STD_LOGIC;
               q : out STD_LOGIC
             );
    end component;
    
    -- takes stream of morse, outputs characters
    component decoder_block is
        Port ( clk : in STD_LOGIC;
               d : in STD_LOGIC;
               rst : in STD_LOGIC;
               z : out STD_LOGIC_VECTOR (5 downto 0);
               update : out STD_LOGIC
              );
    end component;
    
    -- test led output - binary leds for A-M
    component led_output is
        Port ( clk : in STD_LOGIC;
               new_data : in STD_LOGIC;
               rst : in STD_LOGIC;
               d : in STD_LOGIC_VECTOR (5 downto 0);
               z : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    --clk_wiz_0 output signal
    signal clk : STD_LOGIC;
    
    --keyer_input output signal
    signal q_keyer_input : STD_LOGIC;
    
    --decoder_block output signals
    signal z_decoder_block : STD_LOGIC_VECTOR (5 downto 0);
    signal update_decoder_block : STD_LOGIC;
    
    
begin
    
    inst_clk_wiz: clk_wiz_0 PORT MAP(
        clk_out1 => clk,
        clk_in1 => CLK100MHZ
    );
    
    inst_keyer_input: keyer_input PORT MAP(
        clk => clk,
        d => ck_io0,
        q => q_keyer_input
    );
    
    inst_decoder_block: decoder_block PORT MAP(
        clk => clk,
        d => q_keyer_input,
        rst => sw0,
        z => z_decoder_block,
        update => update_decoder_block
    );
    
    inst_led_output: led_output PORT MAP(
        clk => clk,
        new_data => update_decoder_block,
        rst => sw0,
        d => z_decoder_block,
        z => led
    );

end RTL;
