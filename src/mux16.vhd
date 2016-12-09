library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.utils.all;

entity mux16 is
  Port ( 
    selector : in std_logic_vector(3 downto 0);
    x : in cpu_word_1x16;
    y : out cpu_word
  );
end mux16;

architecture Behavioral of mux16 is
begin
    y <= x(to_integer(unsigned(selector)));
end Behavioral;