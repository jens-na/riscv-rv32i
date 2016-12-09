library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

use work.utils.all;
use work.opcodes.all;

entity main is
  Port (
    clk: in std_logic;
    reset: in std_logic
  );
end main;

architecture Structural of main is
    -- PC component
    signal s_pc_out : cpu_word := (others => '0'); -- nach Fetch
    signal s_set : std_logic := '0';
    signal s_reset : std_logic := '0';
    signal s_set_value : cpu_word := (others => '0');
    component c_pc 
        port (
            c_clk : in std_logic;
            c_set : in std_logic;
            c_set_value : in cpu_word;
            c_reset : in std_logic;
            c_value_out: out cpu_word
        );
    end component;
    
    -- Fetch component
    
    -- Decode component
    signal s_rs1 : reg_idx;
    signal s_rs2 : reg_idx;
    signal s_rd : reg_idx;
    signal s_alu_out : alu_op;
    signal s_en_imm : std_logic;
    signal s_imm : cpu_word;
    component c_decode
        port (
            c_clk : in std_logic;
            c_instr : in cpu_word;
            c_rs1 : out reg_idx;
            c_rs2 : out reg_idx;
            c_rd : out reg_idx;
            c_alu_out : out alu_op;
            c_en_imm : out std_logic;
            c_imm : out cpu_word
        );
    end component;
    
    signal s_ram_addr : cpu_word := (others => '0');
    signal s_fetch_write : boolean := false;
    signal s_fetch_enable : boolean := false;
    component c_fetch
        port (
            addr_in : in cpu_word;
            ram_addr : out cpu_word;
            ram_write : out boolean;
            ram_enable : out boolean
        );
    end component;
    
    signal s_ram_data_in : cpu_word := (others => '0');
    signal s_ram_en_write : std_logic := '0';
    signal s_ram_enable : std_logic := '0';
    signal s_ram_data_out : cpu_word := (others => '0');
    
    component c_block_ram 
        port (
            c_clk : in std_logic;
            c_reset : in std_logic;
            c_data_in : in cpu_word;
            c_addr : in cpu_word;
            c_en_write : in std_logic;
            c_enable : in std_logic;
            c_data_out : out cpu_word
            );
    end component;   
    
begin
    pc : c_pc port map(
        c_clk => clk,
        c_set => s_set,
        c_set_value => s_set_value,
        c_reset => s_reset,
        c_value_out => s_pc_out
    );
    
    --decode : c_decode port map(
    --    c_clk => clk,
    --    c_instr => s_fetch_out,
    --    c_rs1 => s_rs1,
    --    c_rs2 => s_rs2,
    --    c_rd => s_rd,
    --    c_alu_out => s_alu_out,
    --    c_en_imm => s_en_imm,
    --    c_imm => s_imm
    --);
    
end Structural;