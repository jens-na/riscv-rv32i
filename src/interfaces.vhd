library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

package interfaces is

    --
    -- ALU
    --
    type alu_req is record
        par1 : cpu_word;
        par2 : cpu_word;
        op: opcode;
        res : cpu_word;
    end record;
    
end package;

package body interfaces is 

    -- Function for general use
    
end interfaces;