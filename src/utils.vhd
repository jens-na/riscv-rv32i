library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.opcodes.all;

package utils is

    -- Constant and type definitions
    
    constant cpu_word_length : natural := 32;
    subtype cpu_word is std_logic_vector(cpu_word_length - 1 downto 0);
    
    constant reg_idx_length : natural := 5;
    subtype reg_idx is std_logic_vector(reg_idx_length - 1 downto 0);
    
    type cpu_word_1x2 is array (1 downto 0) of cpu_word;
    type cpu_word_1x16 is array (15 downto 0) of cpu_word;

    function to_cpu_word(b : in boolean) return cpu_word;
    function to_cpu_word(v : in bit_vector) return cpu_word;
    
end package;

package body utils is 

    
    -- Converts a boolean in a cpu_word. If boolean is true the function
    -- returns '1', '0' otherwise.
    -- Input: b : boolean
    -- Output: cpu_word
    function to_cpu_word(b: boolean) return cpu_word is
    begin
        if b then
            return ('1', others => '0');
        else
            return (others => '0');
        end if;
    end function to_cpu_word;
    
    -- Converts a bit_vector in a cpu_word. 
    -- Input: v : the bit_vector
    -- Output: cpu_word
    function to_cpu_word(v: bit_vector) return cpu_word is
    begin
        return to_stdlogicvector(v);
    end function to_cpu_word;
    
end utils;