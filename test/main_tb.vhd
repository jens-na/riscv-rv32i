library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity main_tb is
--  Port ( );
end main_tb;

architecture Behavioral of main_tb is

	constant clk_period : time := 10 ns;
    signal m_clk : std_logic;

    signal m_set : std_logic;
    signal m_set_value : cpu_word;
    signal m_reset : std_logic;
    signal m_ram_addr : cpu_word;
    signal m_ram_write : boolean;
    signal m_ram_enable : boolean;
    
begin

    UUT : entity work.main port map (
        m_clk => m_clk,
        m_set => m_set,
        m_set_value => m_set_value,
        m_reset => m_reset,
        m_ram_addr => m_ram_addr,
        m_ram_write => m_ram_write,
        m_ram_enable => m_ram_enable
    );
    
    process
    begin
        m_clk <= '1';
        wait for clk_period / 2;

        m_clk <= '0';
        wait for clk_period / 2;
    end process;
    
    process
    begin
    	m_set <= '0';
        m_set_value <= (others => '1');
        m_reset <= '1';
        wait until falling_edge(m_clk);
        m_reset <= '0';
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        m_set <= '1';
        wait until falling_edge(m_clk);
        m_set <= '0';
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
        wait until falling_edge(m_clk);
    end process;

end Behavioral;
