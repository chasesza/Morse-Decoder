----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/15/2021 08:21:28 PM
-- Design Name: 
-- Module Name: screen_control - RTL
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: I refered to Digilent's example program for the com port and charge pump settings.
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

entity screen_control is
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
end screen_control;

architecture RTL of screen_control is
    type state is (start, vdd, dispOff, waitForSpi, chargePump1, chargePump2, preCharge1, preCharge2, vBat, comConfig1, comConfig2, setAddressingMode, setHorizontal, dispOn, active, wait3ms, wait100ms, resetOn, resetOff, clearScreen,
                    invertDisp1, invertDisp2, setPageAddressCmd, setPageStart, setPageEnd, queueData1, queueData2, queueData3, offSeqStart, vbatOff, vddOff, done);
    signal pres_state : state := start;
    signal next_state : state;
    
    signal wait_counter : integer range 0 to 495000;
    
    signal power_off_started : STD_LOGIC := '0';
    
    signal one_clock_spi_delay : STD_LOGIC := '1';
    
    signal clear_screen_byte_counter : integer range 0 to 1023 := 0;
    
    signal prev_last_data : STD_LOGIC := '0';
    
    constant wait_time_3ms : integer := 15000;
    constant wait_time_100ms : integer := 495000;
    
begin
    
    clk_proc: process(clk)
    begin
        if rising_edge(clk) then
            if power_off = '1' and power_off_started = '0' then
                pres_state <= offSeqStart;
                power_off_started <= '1';
            elsif pres_state = start then
                new_output <= '0';
                n_vbat <= '1';
                n_vdd <= '1';
                n_rst <= '1';
                
                pres_state <= vdd;
                
                get_next_data <= '0';
                goto_first_data <= '0';
            elsif pres_state = vdd then
                n_vdd <= '0';
                pres_state <= wait3ms;
                next_state <= dispOff;
                wait_counter <= 0;
            elsif pres_state = dispOff then
                    data_n_cmd <= '0';
                    q <= "10101110";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= resetOn;
            elsif pres_state = resetOn then
                    n_rst <= '0';
                    
                    wait_counter <= 0;
                    pres_state <= wait3ms;
                    next_state <= resetOff;
            elsif pres_state = resetOff then
                    n_rst <= '1';
                    
                    wait_counter <= 0;
                    pres_state <= wait3ms;
                    next_state <= chargePump1;
            elsif pres_state = chargePump1 then --change charge pump setting
                    data_n_cmd <= '0';
                    q <= "10001101";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= chargePump2;
            elsif pres_state = chargePump2 then --enable charge pump
                    data_n_cmd <= '0';
                    q <= "00010100";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= preCharge1;
            elsif pres_state = preCharge1 then --change pre charge period command
                    data_n_cmd <= '0';
                    q <= "11011001";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= preCharge2;
            elsif pres_state = preCharge2 then --new pre-charge value, taken from digilent's pmod oled exambple code
                    data_n_cmd <= '0';
                    q <= "11110001";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= vbat;
            elsif pres_state = vbat then
                    n_vbat <= '0';
                    
                    wait_counter <= 0;
                    pres_state <= wait100ms;
                    next_state <= invertDisp1;
            elsif pres_state = invertDisp1 then --column address 127 is mapped to seg0
                    data_n_cmd <= '0';
                    q <= "10100001";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= invertDisp2;
            elsif pres_state = invertDisp2 then --swap com scanning direction
                    data_n_cmd <= '0';
                    q <= "11001000";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= comConfig1;
            elsif pres_state = comConfig1 then --change com configuration command
                    data_n_cmd <= '0';
                    q <= "11011010";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= comConfig2;
            elsif pres_state = comConfig2 then --set to left/right remap, sequential configuration
                    data_n_cmd <= '0';
                    q <= "00100010";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= setAddressingMode;
            elsif pres_state = setAddressingMode then --chnage adressing mode command
                    data_n_cmd <= '0';
                    q <= "00100000";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= setHorizontal;
            elsif pres_state = setHorizontal then --set to horizontal addressing mode
                    data_n_cmd <= '0';
                    q <= "00000000";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= setPageAddressCmd;
            elsif pres_state = setPageAddressCmd then --change page start and end addresses
                    data_n_cmd <= '0';
                    q <= "00100010";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= setPageStart;
            elsif pres_state = setPageStart then --set page start address
                    data_n_cmd <= '0';
                    q <= "00000000";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= setPageEnd;
            elsif pres_state = setPageEnd then --set page end  address
                    data_n_cmd <= '0';
                    q <= "00000011";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= clearScreen;
            elsif pres_state = clearScreen then
                    data_n_cmd <= '1';
                    q <= "00000000";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
            
                    if clear_screen_byte_counter < 511 then
                        clear_screen_byte_counter <= clear_screen_byte_counter + 1;
                        next_state <= clearScreen;
                    else
                        next_state <= dispOn;
                        clear_screen_byte_counter <= 0;
                    end if;
            elsif pres_state = dispOn then
                    data_n_cmd <= '0';
                    q <= "10101111";
                    new_output <= '1';
                    
                    pres_state <= waitForSpi;
                    next_state <= active;
            elsif pres_state = wait3ms then
                if wait_counter = wait_time_3ms then
                    pres_state <= next_state;
                 else
                    wait_counter <= wait_counter+1;
                 end if;
            elsif pres_state = wait100ms then
                if wait_counter = wait_time_100ms then
                    pres_state <= next_state;
                 else
                    wait_counter <= wait_counter+1;
                 end if;
            elsif pres_state = waitForSpi then
                new_output <= '0';
                if one_clock_spi_delay = '1' then
                    one_clock_spi_delay <= '0';
                end if;
                
                if one_clock_spi_delay = '0' and n_cs = '1' then
                    pres_state <= next_state;
                    one_clock_spi_delay <= '1';
                end if;
            elsif pres_state = offSeqStart then --send display off command
                data_n_cmd <= '0';
                q <= "10101110";
                new_output <= '1';
                
                pres_state <= waitForSpi;
                next_state <= vbatOff;
            elsif pres_state = vbatOff then --turn off screen
                n_vbat <= '1';
                
                wait_counter <= 0;
                pres_state <= wait100ms;
                next_state <= vddOff;
            elsif pres_state = vddOff then --turn off logic
                n_vdd <= '1';
                
                pres_state <= done;
            elsif pres_state = done then
                if power_off = '0' then
                    pres_state <= start;
                    power_off_started <= '0';
                end if;
            elsif pres_state = active then
                if new_character = '1' then
                    prev_last_data <= '0';
                    data_n_cmd <= '1';
                    goto_first_data <= '1';
                    pres_state <= queueData1;
                end if;
            elsif pres_state = queueData1 then
                goto_first_data <= '0';
                if prev_last_data = '0' then
                    get_next_data <= '1';
                    pres_state <= queueData2;
                else
                    pres_state <= active;
                end if;
            elsif pres_state = queueData2 then -- lower get_next_data signal and delay one clock before reading the data
                get_next_data <= '0';
                
                pres_state <= queueData3;
            elsif pres_state = queueData3 then
                prev_last_data <= last_data;
                
                q <= d;
                new_output <= '1';
                
                pres_state <= waitForSpi;
                next_state <= queueData1;
            end if;
        end if;
    end process clk_proc;
    
end RTL;
