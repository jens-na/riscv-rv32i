library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity main is
  Port (
    m_clk: in std_logic;
    m_pc_reset : in std_logic;
    m_bram_reset : in std_logic;
    m_register_reset : in std_logic;
    m_bram_data_in : in cpu_word
  );
end main;

architecture Structural of main is
    
    signal s_pc_value_out : cpu_word;
    signal s_pc_set : std_logic;
    signal s_pc_set_value : cpu_word;
    component pc port(
        clk : in std_logic;
        set : in std_logic;
        set_value : in cpu_word;
        reset : in std_logic;
        value_out: out cpu_word
    );
    end component;
     
    signal s_fetch_ram_addr : cpu_word;
    signal s_fetch_ram_write : boolean;
    --signal s_fetch_ram_enable : boolean;
    component fetch port(
        addr_in : in cpu_word;
        ram_addr : out cpu_word;
        ram_write : out boolean;
        ram_enable : out boolean
    );
    end component;
     
     
    signal s_decode_rs1 : reg_idx;
    signal s_decode_rs2 : reg_idx;
    signal s_decode_rd : reg_idx;
    signal s_decode_alu_out : alu_op;
    signal s_decode_en_imm : std_logic;
    signal s_decode_imm : cpu_word;
    component decode port(
        clk : in std_logic;
        instr : in cpu_word;
        rs1 : out reg_idx;
        rs2 : out reg_idx;
        rd : out reg_idx;
        alu_out : out alu_op;
        en_imm : out std_logic;
        imm : out cpu_word
    );
    end component;
    
    signal s_bram_data_out : cpu_word;
    signal s_bram_addr : cpu_word;
    component block_ram port(
        clk : in std_logic;
        reset : in std_logic;
        data_in : in cpu_word;
        addr : in cpu_word;
        en_write : in boolean;
        --enable : in boolean;
        data_out : out cpu_word
    );
    end component;
    
    signal s_register_data_out1 : cpu_word;
    signal s_register_data_out2 : cpu_word;
    component registerfile port(
        clk : in std_logic;
        reset : in std_logic;
        rs1 : in reg_idx;
        rs2 : in reg_idx;
        rd : in reg_idx;
        data_in : in cpu_word;
        data_out1 : out cpu_word;
        data_out2 : out cpu_word
    );
    end component;
    
    signal s_alu_result : cpu_word;
    signal s_alu_zero_flag : boolean;
    component alu port (
        clk : in std_logic;
        data_in1 : in cpu_word;
        data_in2 : in cpu_word;
        op_in : in alu_op;
        result : out cpu_word;
        zero_flag : out boolean
    );
    end component;
    
begin

    c_pc : pc port map(
        clk => m_clk,
        set => s_pc_set,
        set_value => s_pc_set_value,
        reset => m_pc_reset,
        value_out => s_pc_value_out
    );
    
    c_fetch : fetch port map(
        addr_in => s_pc_value_out,
        ram_addr => s_fetch_ram_addr,
        ram_write => s_fetch_ram_write
        --ram_enable => s_fetch_ram_enable
    );
    
    c_decode : decode port map(
        clk => m_clk,
        instr => s_bram_data_out,
        rs1 => s_decode_rs1,
        rs2 => s_decode_rs2,
        rd => s_decode_rd,
        alu_out => s_decode_alu_out,
        en_imm => s_decode_en_imm,
        imm => s_decode_imm
    );
    
    c_bram : block_ram port map(
        clk => m_clk,
        reset => m_bram_reset,
        data_in => m_bram_data_in,
        addr => s_fetch_ram_addr,
        --enable => s_fetch_ram_enable,
        en_write => s_fetch_ram_write,
        data_out => s_bram_data_out
    );
    
    c_registerfile : registerfile port map(
        clk => m_clk,
        reset => m_register_reset,
        rs1 => s_decode_rs1,
        rs2 => s_decode_rs2,
        rd => s_decode_rd,
        data_in => s_alu_result,
        data_out1 => s_register_data_out1,
        data_out2 => s_register_data_out2
    );
    
    c_alu : alu port map(
        clk => m_clk,
        data_in1 => s_register_data_out1,
        data_in2 => s_register_data_out2,
        op_in => s_decode_alu_out,
        result => s_alu_result,
        zero_flag => s_alu_zero_flag
    );
    
    
        
end Structural;