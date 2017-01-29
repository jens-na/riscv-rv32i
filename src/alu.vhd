library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.utils.all;
use work.opcodes.all;

-- LUI => nichts
-- AUIPC => ADDI (Addieren Upper Immediate auf PC)
-- JAL => ADDI (Immediate auf PC)
-- JALR => ADDI
-- BEQ => AND (Zero Flag), ADDI
-- BNE => AND (Zero Flag), ADDI
-- BLT => LT (Zero Flag), ADDI
-- BGE => GE (Zero Flag), ADDI
-- BLTU => fragen
-- BGEU => fragen
-- LB => ADDI
-- LH => ADDI
-- LW => ADDI
-- LBU => ADDI
-- LHU => ADDI
-- SB => ADDI (rs1 + imm ergibt Speicheradresse, da hin muss rs2 geschrieben werden)
-- SH => ADDI
-- SW => ADDI
-- ADDI => trvial
-- SLTI => trvial
-- SLTIU => trvial
-- XORI => trivial
-- ORI => trivial
-- ANDI => trivial
-- SLLI => trivial, (Left shift, immer 0 schieben)
-- SRLI => trivial, (Right shift, immer 0 schieben)
-- SRAI => trivial, (Right shift, MSB schieben)
-- ADD => trivial
-- SUB => trivial
-- SLL => trivial
-- SLT => trivial
-- SLTU => trivial
-- XOR => trivial
-- SRL => trivial
-- SRA => trivial
-- OR => trivial
-- AND => trivial
entity alu is
  Port (
--    clk : in std_logic;
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
                when ALU_SUB =>
                    result <= cpu_word(signed(data_in1) - signed(data_in2));
                when ALU_SLL =>
                    result <= cpu_word(signed(data_in1) sll to_integer(signed(data_in2)));
                when ALU_SLT =>
                    zero_flag_next <= signed(data_in1) < signed(data_in2);
					--zero_flag <= zero_flag_next;
                    result <= to_cpu_word(zero_flag_next);
                when ALU_SLTU =>
                    zero_flag_next <= unsigned(data_in1) < unsigned(data_in2);
					--zero_flag <= zero_flag_next;
                    result <= to_cpu_word(zero_flag_next);
                when ALU_XOR =>
                    result <= cpu_word(signed(data_in1) xor signed(data_in2));
                when ALU_SRL =>
                    result <= cpu_word(signed(data_in1) srl to_integer(signed(data_in2)));
                when ALU_SRA =>
                    result <= to_cpu_word(to_bitvector(data_in1) sra to_integer(signed(data_in2)));
                when ALU_OR =>
                    result <= cpu_word(signed(data_in1) or signed(data_in2));
                when ALU_AND =>
                    zero_flag_next <= signed(data_in1) = signed(data_in2);
                    --zero_flag <= zero_flag_next;
                    result <= cpu_word(signed(data_in1) and signed(data_in2));
        end case;
    end process;
    zero_flag <= zero_flag_next;
end Behavioral;
