library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.utils.all;
use work.opcodes.all;

entity pc_tb is
--  Port ( );
end pc_tb;

architecture Behavioral of pc_tb is

	constant clk_period : time := 10 ns;

    signal clk, set, reset : std_logic;
	signal set_value, value_out, value_out_next : cpu_word;

begin
	UUT : entity work.pc port map (clk => clk, set => set, reset => reset,
										set_value => set_value, value_out => value_out, 
										value_out_next => value_out_next);

	process
	begin
		clk <= '1';
		wait for clk_period / 2;

		clk <= '0';
		wait for clk_period / 2;
	end process;

	process
	begin
	    set <= '0';
	    reset <= '1';   
		wait until falling_edge(clk);
		reset <= '0';
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
		wait until falling_edge(clk);
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        set <= '1';
        set_value <= (5 => '1', others => '0');
        wait until falling_edge(clk);
        set <= '0';
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        wait until falling_edge(clk);
        wait until falling_edge(clk);
	end process;
	
end Behavioral;
