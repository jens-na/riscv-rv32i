library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.utils.all;


entity registerfile is
  Port (
    clk : in std_logic;
    reset : in std_logic;
    rs1 : in reg_idx;
    rs2 : in reg_idx;
    rd : in reg_idx;
    data_in : in cpu_word;
    data_out1 : out cpu_word;
    data_out2 : out cpu_word
  );
end registerfile;

architecture Behavioral of registerfile is
-- Constant for zero register
-- constant zero_reg : std_logic_vector(reg_idx_length downto 0):= "00000";

-- Array of 31 register blocks: zero is not created as this always returns 0
type reg_block_t is array (1 to 2**reg_idx_length) of std_logic_vector(cpu_word_length - 1 downto 0);
signal reg_blocks : reg_block_t := (
    1 => (0 => '1', others => '0'), -- 1
    2 => (1 => '1', others => '0'), -- 2
    others => (others => '0')
);

begin
    
    --Asymc write:
    --data_out1 <= reg_blocks(to_integer(unsigned(rs1))) when (unsigned(rs1) = 0) else (others => '0');
    --data_out2 <= reg_blocks(to_integer(unsigned(rs2))) when (unsigned(rs2) = 0) else (others => '0');
     -- data_out2 <= reg_blocks(to_integer(unsigned(rs2))) when (rs2 /= zero_reg) else (others => '0');

    process(clk)
    begin
    
        --sync read out
        if rising_edge(clk) then
            if (unsigned(rs1) /= 0) then
                data_out1 <= reg_blocks(to_integer(unsigned(rs1)));
            else
                data_out1 <= (others => '0');
            end if;
            
            if (unsigned(rs2) /= 0) then
                data_out2 <= reg_blocks(to_integer(unsigned(rs2)));
            else
                data_out2 <= (others => '0');
            end if;
            
            --sync write to register
            
            if (unsigned(rd) /= 0) then
                reg_blocks(to_integer(unsigned(rd))) <= data_in;
            end if;
            
            --data_out1 <= (others => '1');
        end if;
        
    end process;

end Behavioral;
