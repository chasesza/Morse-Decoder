----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08/15/2021 06:49:11 PM
-- Design Name: 
-- Module Name: decoder_instantiation_btns_to_oled - RTL
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

entity decoder_instantiation_btns_to_oled is
Port(
          CLK100MHZ : in STD_LOGIC;
          btn    : in STD_LOGIC_VECTOR (3 downto 0);
          sw       : in STD_LOGIC_VECTOR (3 downto 0);
          ja      : out STD_LOGIC_VECTOR (7 downto 0)
        );
end decoder_instantiation_btns_to_oled;

architecture RTL of decoder_instantiation_btns_to_oled is

    --Vivado Clocking Wizard - 100MHz clock to 5MHz clock signal
    component clk_wiz_0
    port
     (-- Clock in ports
      -- Clock out ports
      clk_out1          : out    std_logic;
      clk_in1           : in     std_logic
     );
    end component;
    
    component three_button_input is
    Port(
        clk : in STD_LOGIC;
        space : in STD_LOGIC;
        end_char : in STD_LOGIC;
        dot_in : in STD_LOGIC;
        dash_in : in STD_LOGIC;
        dot_out : out STD_LOGIC;
        dash_out : out STD_LOGIC;
        update : out STD_LOGIC
        );
    end component;
    
    -- takes stream of morse, outputs characters
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

    --turns the screen on, updates the output, and turns it off
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
    
    --converts output from the state machine to 8x8 blocks for image_data_storage
    component input_converter is
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC_VECTOR (5 downto 0);
           new_data : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (7 downto 0);
           update : out STD_LOGIC);
    end component;
    
    --stores informtion that will be displayed on the screen
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

    --clk_wiz_0 output signal
    signal clk : STD_LOGIC;
    
    --three button input signals
    signal three_btn_input_dot_out : STD_LOGIC := '0';
    signal three_btn_input_dash_out : STD_LOGIC := '0';
    signal three_btn_input_update : STD_LOGIC := '0';
    
    --fsm/decoder_block output signals
    signal z_decoder_block : STD_LOGIC_VECTOR (5 downto 0);
    signal update_decoder_block : STD_LOGIC;
    
    --screen control block signals
    signal q_image_data_storage: STD_LOGIC_VECTOR(7 downto 0);
    signal new_character: STD_LOGIC;
    signal get_next_data: STD_LOGIC;
    signal goto_first_data: STD_LOGIC;
    signal q_input_converter : STD_LOGIC_VECTOR(7 downto 0);
    signal update_input_converter: STD_LOGIC;
    signal last_data: STD_LOGIC;
    
begin
    
    inst_clk_wiz: clk_wiz_0 PORT MAP(
        clk_out1 => clk,
        clk_in1 => CLK100MHZ
    );
    
    inst_3_btn_input: three_button_input
    port map(
        clk => clk,
        space => btn(0),
        end_char => btn(1),
        dot_in => btn(3),
        dash_in => btn(2),
        dot_out => three_btn_input_dot_out,
        dash_out => three_btn_input_dash_out,
        update => three_btn_input_update
    );
    
    inst_fsm: fsm 
    port map(
         dot => three_btn_input_dot_out,
         dash => three_btn_input_dash_out,
         clk => clk,
		 new_data => three_btn_input_update,
         z => z_decoder_block,
         update => update_decoder_block
    );
    
    inst_oled_com: oled_communication
    port map(
        clk => clk,
        power_off => sw(3),
        d => q_image_data_storage,
        new_character => new_character,
        last_data => last_data,
        get_next_data => get_next_data,
        goto_first_data => goto_first_data,
        data_n_cmd => ja(4),
        n_vbat => ja(6),
        n_vdd => ja(7),
        n_rst => ja(5),
        sclk => ja(3),
        mosi => ja(1),
        n_cs => ja(0)
    );
    
    inst_input_converter: input_converter
    port map(
        clk => clk,
        d => z_decoder_block,
        new_data => update_decoder_block,
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
    
    
end RTL;
