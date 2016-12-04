library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
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
-- Array of 31 register blocks: zero is not created as this always returns 0
type reg_block_t is array (1 to 2**reg_idx_length) of std_logic_vector(cpu_word_length - 1 downto 0);
signal reg_blocks : reg_block_t;

begin

--Asynchronous write to outputs:
data_out1 <= reg_blocks(to_integer(unsigned(rs1)));
data_out2 <= reg_blocks(to_integer(unsigned(rs2)));

--Synchronous read from input:



end Behavioral;
