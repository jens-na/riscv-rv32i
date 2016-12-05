library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;

entity fetch is
  Port ( 
    clk : in std_logic;
    addr_in : in cpu_word;
    instr_out : out cpu_word
  );
end fetch;

architecture Behavioral of fetch is
  -- Fetch instruction from BRAM
begin


end Behavioral;
