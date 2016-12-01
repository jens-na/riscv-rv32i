library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity tb_alu is
--  Port ( );
end tb_alu;

architecture Behavioral of tb_alu is
    component alu
        port(
            clk : in std_logic;
            data_in1 : in cpu_word;
            data_in2 : in cpu_word;
            op_in : in alu_op;
            result : out cpu_word;
            zero_flag : out std_logic
        );
    end component;
    
    signal clk: std_logic := '0';
    signal x : cpu_word;
    signal y : cpu_word;
    signal o : alu_op;
    signal result : cpu_word;
    signal zero_flag : std_logic;
    
begin
clk <=  '1' after 0.5 ns when clk = '0' else
        '0' after 0.5 ns when clk = '1';
    
    UUT: alu port map(
        clk => clk,
        data_in1 => x,
        data_in2 => y,
        op_in => o,
        result => result,
        zero_flag => zero_flag
    );
    
    process
    begin
        wait for 10ns;
        x <= (2 downto 0 => '1', others => '0');
        y <= (1 downto 0 => '1', others => '0');
        o <= ALU_ADD;
        wait for 10ns;
        o <= ALU_SUB;
        x <= (4 downto 2 => '1', others => '0');
        y <= (2 downto 0 => '1', others => '0');
        
    end process;

end Behavioral;
