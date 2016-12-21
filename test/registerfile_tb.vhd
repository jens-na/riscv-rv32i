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
    signal rs2 : reg_idx;
    signal rd : reg_idx;
    signal data_in : cpu_word;
    signal data_out1 : cpu_word;
    signal data_out2 : cpu_word;
      
    --clock cycle
    constant clk_period : time := 10ns;

begin

    UUT: registerfile port map(clk => clk, reset => reset, rs1 => rs1, rs2 => rs2,
        rd => rd, data_in => data_in, data_out1 => data_out1, data_out2 => data_out2);


    clk <=  '1' after clk_period when clk = '0' else
        '0' after clk_period when clk = '1';

    stim_process : process
    begin
    
        
        wait for 23ns;
        
        data_in <= std_logic_vector(to_unsigned(1000, 32));
        rd <= std_logic_vector(to_unsigned(5, 5));
        
        wait for 22ns;
        
        data_in <= std_logic_vector(to_unsigned(10000, 32));
        rd <= std_logic_vector(to_unsigned(3, 5));

        wait for 22ns;
        
        rs1 <= std_logic_vector(to_unsigned(5, 5));
        rs2 <= std_logic_vector(to_unsigned(3, 5));
        
        wait for 22ns;
        
    end process;
    
end Behavioral;
