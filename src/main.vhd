library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

use work.utils.all;
use work.opcodes.all;
use work.interfaces.all;

entity main is
  Port (
    clk: in std_logic;
    req: in alu_req;
    res: out cpu_word 
  );
end main;

architecture Behavioral of main is
begin
    process(req.par1, req.par2, req.op) is
    begin
        case req.op is
            when OP_ADDI =>
                res <= req.par1 + req.par2;
            when others => 
                res <= (others => '0');
        end case;
    end process;
      
end Behavioral;