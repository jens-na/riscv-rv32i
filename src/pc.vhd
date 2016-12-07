library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.utils.all;
use work.opcodes.all;


entity pc is

	generic(N : integer := 32;
		    M : integer := 4);

    Port ( clk : in std_logic;
		   set : in std_logic;
           set_value : in std_logic_vector(N-1 downto 0);
		   reset : in std_logic;
		   value_out: out std_logic_vector(N-1 downto 0)
	   );
end pc;

architecture Behavioral of pc is

	signal cnt_reg : std_logic_vector(N-1 downto 0);
	signal cnt_next : std_logic_vector(N-1 downto 0);

begin
	process(clk, reset)
	begin 
		if (reset = '1') then
			cnt_reg <= (others => '0');
		elsif (rising_edge(clk)) then
			if (set = '1') then
				cnt_reg <= set_value;
			else
				cnt_reg <= cnt_next;
			end if;
		end if;
	end process;

	-- next state logic
	cnt_next <= std_logic_vector(unsigned(cnt_reg) + M);
	
	-- output logic
	value_out <= cnt_next;

end Behavioral;
