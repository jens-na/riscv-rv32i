library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity mux is
  Port ( 
    selector : in std_logic_vector(3 downto 0);
    x : in std_logic_vector(15 downto 0);
    y : out std_logic
  );
end mux;

architecture Behavioral of mux is
begin
    y <= x(to_integer(unsigned(selector)));
end Behavioral;