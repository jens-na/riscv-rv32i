library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity main_tb is
--  Port ( );
end main_tb;

architecture Behavioral of main_tb is

	constant clk_period : time := 10 ns;
    signal s_clk : std_logic;
    signal s_pc_reset : std_logic;
    signal s_bram_reset : std_logic;
    signal s_register_reset : std_logic;
    signal s_register_status : cpu_word;
    
begin

    uut : entity work.main port map (
        m_clk => s_clk,
        m_pc_reset => s_pc_reset,
        m_bram_reset => s_bram_reset,
        m_register_reset => s_register_reset,
        m_status_flag => s_register_status
    );
    
    process
    begin
        s_clk <= '1';
        wait for clk_period / 2;

        s_clk <= '0';
        wait for clk_period / 2;
    end process;
    
    process
    
    begin


		s_pc_reset <= '1';
		wait for 3ns;
		s_pc_reset <= '0';
		wait for 1500ns;
    end process;

end Behavioral;
