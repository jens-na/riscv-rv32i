library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.utils.all;
use work.opcodes.all;

entity alu is
  Port (
    data_in1 : in cpu_word;
    data_in2 : in cpu_word;
    op_in : in alu_op;
    result : out cpu_word;
    zero_flag : out boolean
);
end alu;

architecture Behavioral of alu is
    signal zero_flag_next : boolean;
begin
    process(data_in1, data_in2, op_in) is 
    begin
    
        case op_in is
                when ALU_ADD =>
                    result <= cpu_word(signed(data_in1) + signed(data_in2));
                    zero_flag_next <= false;
                when ALU_SUB =>
                    result <= cpu_word(signed(data_in1) - signed(data_in2));
                    zero_flag_next <= false;
                when ALU_SLL =>
                    result <= cpu_word(signed(data_in1) sll
                              to_integer(signed(data_in2(5 downto 0))));
                    zero_flag_next <= false;
                when ALU_SLT =>
                    zero_flag_next <= signed(data_in1) < signed(data_in2);
                    if signed(data_in1) < signed(data_in2) then
                        result(0) <= '1';
                    else
                        result(0) <= '0';
                    end if;
                    result(cpu_word_length -1 downto 1) <= (others => '0');
                when ALU_SLTU =>
                    zero_flag_next <= unsigned(data_in1) < unsigned(data_in2);
                    
                    if unsigned(data_in1) = 0 and unsigned(data_in2) = 0 then
                        result(0) <= '0'; -- assembler pseudo-op SNEZ rd, rs
                    else
                        if unsigned(data_in1) < unsigned(data_in2) then
                            result(0) <= '1';
                        else
                            result(0) <= '0';
                        end if;
                    end if;
                    result(cpu_word_length -1 downto 1) <= (others => '0');
                when ALU_XOR =>
                    result <= cpu_word(signed(data_in1) xor signed(data_in2));
                    zero_flag_next <= false;
                when ALU_SRL =>
                    result <= cpu_word(signed(data_in1) srl
                              to_integer(signed(data_in2(5 downto 0))));
                    zero_flag_next <= false;
                when ALU_SRA =>
                    result <= to_cpu_word(to_bitvector(data_in1) sra
                              to_integer(signed(data_in2(5 downto 0))));
                    zero_flag_next <= false;
                when ALU_OR =>
                    result <= cpu_word(signed(data_in1) or signed(data_in2));
                    zero_flag_next <= false;
                when ALU_AND =>
                    zero_flag_next <= signed(data_in1) = signed(data_in2);
                    --zero_flag <= zero_flag_next;
                    result <= cpu_word(signed(data_in1) and signed(data_in2));
        end case;
    end process;
    zero_flag <= zero_flag_next;
end Behavioral;
