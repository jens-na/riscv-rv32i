library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

use work.utils.all;
use work.opcodes.all;

entity mux2_tb is

end mux2_tb;

architecture Behavioral of mux2_tb is
	constant clk_period : time := 10 ns;
    signal clk : std_logic;

    signal selector : std_logic_vector(0 downto 0);
    signal x : cpu_word_arr(1 downto 0);
    signal y : cpu_word;
begin
    UUT: entity work.mux
    generic map(N => 2)
    port map(
        selector => selector,
        x => x,
        y => y
    );
    process
    begin
		clk <= '1';
		wait for clk_period / 2;

		clk <= '0';
		wait for clk_period / 2;
    end process;

    process
    begin
        x(0) <= to_cpu_word("00000000000000000000000000000000"); 
        x(1) <= to_cpu_word("00000000000000000000000000000001"); 
        selector(0) <= '0';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        selector(0) <= '1';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
    end process;

end Behavioral;
