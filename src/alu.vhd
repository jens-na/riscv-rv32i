library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    clk : in std_logic;
    data_in1 : in cpu_word;
    data_in2 : in cpu_word;
    op_in : in alu_op;
    result : out cpu_word
);
end alu;

architecture Behavioral of alu is
begin
     
end Behavioral;