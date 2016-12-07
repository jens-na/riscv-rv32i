----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/04/2016 04:11:40 PM
-- Design Name: 
-- Module Name: registerfile_tb - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.utils.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity registerfile_tb is
--  Port ( );
end registerfile_tb;

architecture Behavioral of registerfile_tb is
    component registerfile
        port(
        clk : in std_logic;
        reset : in std_logic;
        rs1 : in reg_idx;
        rs2 : in reg_idx;
        rd : in reg_idx;
        data_in : in cpu_word;
        data_out1 : out cpu_word;
        data_out2 : out cpu_word);
    end component;
      
    --signals
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal rs1 : reg_idx;
    signal rs1 : reg_idx;
    signal rd : reg_idx;
    signal data_in : cpu_word;
    signal data_out1 : cpu_word;
    signal data_out2 : cpu_word;
      
    --clock cycle
    constant clk_period : time := 1000ns;

begin

    UUT: registerfile port map(clk => clk, reset => reset, rs1 => rs1, rs2 => rs2,
        rd => rd, data_in => data_in, data_out1 => data_out1, data_out2 => data_out2);

    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_process : process
    begin
        wait for 2300ns;
        
        rd <= '3';
        data_in <= (0 => '1', 1 => '0', 2 => '1', others => '0');
        
        wait for 2300ns;

        rd <= '5';
        data_in <= (0 => '0', 1 => '1', 2 => '0', others => '1');
        
        wait for 2300ns;
        
        data_out1 <= '3';
        data_out2 <= '5';
        
       wait for 2300ns;
        
        
    end process;
    
end Behavioral;
