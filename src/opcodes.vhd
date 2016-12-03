library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package opcodes is

    -- Opcodes as defined in https://riscv.org/specifications/ - Chapter 9
    constant opcode_length : natural := 7;
    subtype opcode is std_logic_vector(opcode_length - 1 downto 0);
    
    --
    -- Opcodes
    --
    constant I_TYPE_AL : opcode := "0010011"; -- Register/Immediate (ADDI, ...)
    constant I_TYPE_LOAD : opcode := "0000011"; -- Loads
    constant I_TYPE_JALR : opcode := "1100111"; -- JALR only
    constant R_TYPE : opcode := "0110011"; -- Register/Register (ADD, ...)
    constant S_TYPE : opcode := "0100011"; -- Store
    constant SB_TYPE : opcode := "1100011"; -- Branch
    constant U_TYPE_LUI : opcode := "0110111"; -- Upper immediate
    constant U_TYPE_AUIPC : opcode := "0010111"; -- Upper immediate
    constant UJ_TYPE : opcode := "1101111"; --Jump and Link
    
    type alu_op is (
        ALU_ADD, -- Add
        ALU_SUB, -- Substract
        ALU_SLL, -- Shift left logical
        ALU_SLT, -- set less than
        ALU_SLTU, -- set less than (unsigned)
        ALU_XOR, -- logical xor
        ALU_SRL, -- shift right logical
        ALU_SRA, -- shift right arithmetic
        ALU_OR, -- logical or
        ALU_AND -- logical and
    );
    
    function is_i_type(val : in opcode) return boolean;
    function is_r_type(val : in opcode) return boolean;
    function is_s_type(val : in opcode) return boolean;
    function is_sb_type(val : in opcode) return boolean;
    function is_u_type(val : in opcode) return boolean;
    function is_uj_type(val : in opcode) return boolean;
    
end opcodes;

package body opcodes is 

    -- Checks if the given opcode belongs to an I-type instruction
    -- Input: val : opcode
    -- Output: boolean
    function is_i_type(val : in opcode) return boolean is
    begin
        case val is
            when I_TYPE_AL => return true;
            when I_TYPE_LOAD => return true;
            when I_TYPE_JALR => return true;
            when others => return false;
        end case;
    end function is_i_type;
    
    -- Checks if the given opcode belongs to an R-type instruction
    -- Input: val : opcode
    -- Output: boolean
    function is_r_type(val : in opcode) return boolean is
    begin
        case val is
            when R_TYPE => return true;
            when others => return false;
        end case;
    end function is_r_type;
    
    -- Checks if the given opcode belongs to an S-type instruction
    -- Input: val : opcode
    -- Output: boolean
    function is_s_type(val : in opcode) return boolean is
    begin
        case val is
            when S_TYPE => return true;
            when others => return false;
        end case;
    end function is_s_type;
    
     -- Checks if the given opcode belongs to an SB-type instruction
     -- Input: val : opcode
     -- Output: boolean
     function is_sb_type(val : in opcode) return boolean is
     begin
         case val is
             when SB_TYPE => return true;
             when others => return false;
         end case;
     end function is_sb_type;
     
     -- Checks if the given opcode belongs to an U-type instruction
     -- Input: val : opcode
     -- Output: boolean
     function is_u_type(val : in opcode) return boolean is
     begin
         case val is
             when U_TYPE_LUI => return true;
             when U_TYPE_AUIPC => return true;
             when others => return false;
         end case;
     end function is_u_type;
     
     -- Checks if the given opcode belongs to an UJ-type instruction
     -- Input: val : opcode
     -- Output: boolean
     function is_uj_type(val : in opcode) return boolean is
     begin
         case val is
             when UJ_TYPE => return true;
             when others => return false;
         end case;
     end function is_uj_type;
    
end opcodes;