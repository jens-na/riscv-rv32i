library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity main is
  Port ( 
    m_clk: in std_logic;
    m_set : in std_logic;
    m_set_value : in cpu_word;
    m_reset : in std_logic;
    m_ram_addr : out cpu_word;
    m_ram_write : out boolean;
    m_ram_enable : out boolean
  );
end main;

architecture Structural of main is
    
    -- component alu port (
    --    clk : in std_logic;
    --    data_in1 : in cpu_word;
    --    data_in2 : in cpu_word;
    --    op_in : in alu_op;
    --    result : out cpu_word;
    --    zero_flag : out boolean
    --);
    --end component;
    
    signal s_pc_value_out : cpu_word;
    
    component pc port(
        clk : in std_logic;
        set : in std_logic;
        set_value : in cpu_word;
        reset : in std_logic;
        value_out: out cpu_word
     );
     end component;
     
     component fetch port(
         addr_in : in cpu_word;
         ram_addr : out cpu_word;
         ram_write : out boolean;
         ram_enable : out boolean
     );
     end component;
    
    
begin

    c_pc : pc port map(
        clk => m_clk,
        set => m_set,
        set_value => m_set_value,
        reset => m_reset,
        value_out => s_pc_value_out
    );
    
    c_fetch : fetch port map(
        addr_in => s_pc_value_out,
        ram_addr => m_ram_addr,
        ram_write => m_ram_write,
        ram_enable => m_ram_enable
    );
        
end Structural;