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
    en_write : in boolean;
    data_out1 : out cpu_word;
    data_out2 : out cpu_word;
    status : out status_led_output
  );
end registerfile;

architecture Behavioral of registerfile is
-- Constant for zero register
-- constant zero_reg : std_logic_vector(reg_idx_length downto 0):= "00000";

-- Array of 31 register blocks: zero is not created as this always returns 0
type reg_block_t is array (1 to 2**reg_idx_length) of std_logic_vector(cpu_word_length - 1 downto 0);
signal reg_blocks : reg_block_t := (
    others => (others => '0')
);

begin
    
    --status_flag
    status <= reg_blocks(10)(15 downto 0);

    process(clk, rs1, rs2, rd, reg_blocks)
    begin
    
        --async read out
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
            
        if rising_edge(clk) then
            --sync write to register
           
            if (en_write = true) and (unsigned(rd) /= 0) then
                reg_blocks(to_integer(unsigned(rd))) <= data_in;
            end if;
            
        end if;
        
    end process;

end Behavioral;
