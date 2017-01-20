library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.utils.all;
use work.opcodes.all;


entity pc is


    Port ( clk : in std_logic;
		   set : in std_logic;
           set_value : in cpu_word;
		   reset : in std_logic;
		   value_out: out cpu_word
	   );
end pc;

architecture Behavioral of pc is

	signal cnt_reg : cpu_word;
	signal cnt_next : cpu_word;

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
    
    cnt_next <= std_logic_vector(unsigned(cnt_reg) + 2);

            

	-- output logic
	value_out <= cnt_reg when 
                (( to_integer(unsigned(cnt_reg))) mod 4) = 0 else
                std_logic_vector(unsigned(cnt_reg) - 2);

end Behavioral;
