library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package opcodes is

    -- Opcodes as defined in https://riscv.org/specifications/ - Chapter 9
    constant opcode_length : natural := 7;
    subtype opcode is std_logic_vector(opcode_length - 1 downto 0);
    
    --
    -- Opcodes
    --
    constant OP_LUI : opcode := "0110111";
    constant OP_JAL : opcode := "1101111";
    constant OP_JALR : opcode := "1100111";
    constant OP_BEQ : opcode := "1100011";
    constant OP_BNE : opcode := "1100011";
    constant OP_ADDI : opcode := "0010011";

end opcodes;

package body opcodes is 

    -- Function for opcode use
    
end opcodes;