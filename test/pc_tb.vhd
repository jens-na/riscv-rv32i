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
	signal set_value, value_out : cpu_word;

begin
	UUT : entity work.pc port map (clk => clk, set => set, reset => reset,
										set_value => set_value, value_out => value_out);

	process
	begin
		clk <= '1';
		wait for clk_period / 2;

		clk <= '0';
		wait for clk_period / 2;
	end process;

	process
	begin
		reset <= '1';
		wait for 3ns;
		reset <= '0';
		wait for 100ns;
	end process;
	
end Behavioral;
