library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

use work.utils.all;
use work.opcodes.all;

entity mux16_tb is

end mux16_tb;

architecture Behavioral of mux16_tb is
	constant clk_period : time := 10 ns;
    signal clk : std_logic;

    signal selector : std_logic_vector(3 downto 0);
    signal x : cpu_word_arr(15 downto 0);
    signal y : cpu_word;
begin
    UUT: entity work.mux
    generic map(N => 16)
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
        x(2) <= to_cpu_word("00000000000000000000000000000010"); 
        x(3) <= to_cpu_word("00000000000000000000000000000011"); 
        x(4) <= to_cpu_word("00000000000000000000000000000100"); 
        x(5) <= to_cpu_word("00000000000000000000000000000101"); 
        x(6) <= to_cpu_word("00000000000000000000000000000110"); 
        selector <= "0000";
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        selector <= "0001";
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        selector <= "0100";
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        selector <= "0110";
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        selector <= "0001";
        wait until falling_edge(clk);
        wait until falling_edge(clk);
    end process;

end Behavioral;
