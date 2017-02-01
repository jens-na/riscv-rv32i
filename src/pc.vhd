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
		   value_out: out cpu_word;
		   value_out_next: out cpu_word
	   );
end pc;

architecture Behavioral of pc is

	signal cnt_reg : cpu_word;
	signal cnt_next : cpu_word;
	signal out_s: cpu_word;
	signal enable: std_logic := '0';
	signal enable_next: std_logic;

begin
	process(clk, reset)
	begin 
		if (reset = '1') then
			cnt_reg <= (others => '0');
		elsif (rising_edge(clk)) then
		    if (enable = '1') then
                if (set = '0' or set = 'U') then
                    cnt_reg <= cnt_next;
                else
                    cnt_reg <= std_logic_vector(signed(cnt_next) +
                               signed(set_value));
                end if; 
            end if;
		end if;
	end process;
	
	process(clk)
	begin
        if (rising_edge(clk)) then
            enable <= enable_next;
        end if;
	end process;

    enable_next <= not enable;
    
    -- next state logic
    cnt_next <= std_logic_vector(unsigned(cnt_reg) + 4);

	-- output logic
	value_out <= cnt_reg;            
    value_out_next <= cnt_next;
    
end Behavioral;
