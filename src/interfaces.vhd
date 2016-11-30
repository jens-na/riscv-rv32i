library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

package interfaces is

    type alu_req is record
        op : alu_op;
        rs1 : cpu_word;
        rs2 : cpu_word;
        imm : cpu_word;
    end record;
    
end package;

package body interfaces is 

    -- Function for general use
    
end interfaces;