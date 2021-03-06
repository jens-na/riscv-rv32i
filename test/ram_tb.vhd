----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2016 12:44:24 PM
-- Design Name: 
-- Module Name: ram_tb - Behavioral
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

entity ram_tb is
--  Port ( );
end ram_tb;

architecture Behavioral of ram_tb is
    component block_ram
        port ( 
            clk : in std_logic;
            reset : in std_logic;
            data_in : in cpu_word;
            addr : in cpu_word;
            en_write : in boolean;
            width : in std_logic_vector(2 downto 0);
            data_out : out cpu_word
       );
    end component;
    
    --signals
    signal clk : std_logic := '0';
    signal reset : std_logic := '0';
    signal data_in : cpu_word;
    signal addr : cpu_word;
    signal en_write : boolean;
    signal width : std_logic_vector(2 downto 0);
    signal data_out : cpu_word;
      
    --clock cycle
    constant clk_period : time := 10ns;
    
begin

    UUT: block_ram port map(clk => clk, reset => reset, data_in => data_in, addr => addr,
    en_write => en_write, width => width, data_out => data_out);


    clk <=  '1' after clk_period when clk = '0' else
        '0' after clk_period when clk = '1';

    stim_process : process
    begin
        -- store word 
        en_write <= true;
        width <= "010";
        
        addr <= std_logic_vector(to_unsigned(5, 32));
        data_in <= (others => '1');
        
        wait for 22ns;
        
        -- store halfword
        width <= "001";
        addr <= std_logic_vector(to_unsigned(0, 32));

        wait for 22ns;
        
        -- store byte
        width <= "000";
        addr <= std_logic_vector(to_unsigned(3, 32));

        wait for 22ns;

        -- make sure id doesn't write
        addr <= std_logic_vector(to_unsigned(10, 32));
        data_in <= (others => '1');
        en_write <= false;
        
        wait for 22ns;
        
        addr <= std_logic_vector(to_unsigned(3, 32));
        
        wait for 22ns;
        
    end process;
    
    

end Behavioral;
