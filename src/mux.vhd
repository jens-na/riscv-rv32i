library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

use work.utils.all;

entity mux is
    generic (N : natural);
    Port ( 
        selector : in std_logic_vector((ceillog2(N)-1) downto 0);
        x : in cpu_word_arr;
        y : out cpu_word
    );
end mux;

architecture Behavioral of mux is
begin
    y <= x(to_integer(unsigned(selector)));
end Behavioral;
