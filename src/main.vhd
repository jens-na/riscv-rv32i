----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/31/2016 01:16:18 PM
-- Design Name: 
-- Module Name: main - Behavioral
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

-- TEST

--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
  Port ( 
    O_BIT1: out std_logic
  );
end main;

architecture Behavioral of main is
    signal BIT1: std_logic;
    signal CLK : std_logic := '0';
begin
    clk <= not clk after 1 ns; 

    ToggleProcess: process(CLK)
    begin
        if rising_edge(CLK) then
            if BIT1 = '0' then
                BIT1 <= '1';
            else
                BIT1 <= '0';
            end if;
        end if;
    end process;
      
    O_BIT1 <= BIT1;

end Behavioral;