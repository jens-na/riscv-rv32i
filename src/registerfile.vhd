library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;

entity registerfile is
  Port (
    clk : in std_logic;
    reset : in std_logic;
    rs1 : in reg_idx;
    rs2 : in reg_idx;
    rd : in reg_idx;
    data_in : in cpu_word;
    data_out1 : out cpu_word;
    data_out2 : out cpu_word
  );
end registerfile;

architecture Behavioral of registerfile is

begin


end Behavioral;
