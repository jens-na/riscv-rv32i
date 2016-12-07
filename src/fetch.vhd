library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;

entity fetch is
  Port ( 
    addr_in : in cpu_word;
    ram_addr : out cpu_word;
    ram_write : out boolean;
    ram_enable : out boolean
  );
end fetch;

architecture Behavioral of fetch is

begin
  ram_addr <= addr_in;
  ram_write <= false;
  ram_enable <= true;
end Behavioral;