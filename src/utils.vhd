library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.opcodes.all;

package utils is

    -- Constant and type definitions
    constant cpu_word_length : natural := 32;
    subtype cpu_word is std_logic_vector(cpu_word_length - 1 downto 0);
    
end package;

package body utils is 

    -- Function for general use
    
end utils;