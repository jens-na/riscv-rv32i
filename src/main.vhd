library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity main is
  Port (
    m_clk: in std_logic;
    m_pc_reset : in std_logic;
    m_bram_reset : in std_logic;
    m_register_reset : in std_logic
  );
end main;

architecture Structural of main is
    
    signal s_pc_value_out : cpu_word;
    signal s_pc_value_out_next : cpu_word;
    signal s_pc_set : std_logic;
    signal s_pc_set_value : cpu_word;
    component pc port(
        clk : in std_logic;
        set : in std_logic;
        set_value : in cpu_word;
        reset : in std_logic;
        value_out: out cpu_word;
        value_out_next : out cpu_word
    );
    end component;
     
    signal s_decode_rs1 : reg_idx;
    signal s_decode_rs2 : reg_idx;
    signal s_decode_rd : reg_idx;
    signal s_decode_alu_out : alu_op;
    signal s_decode_en_imm : std_logic_vector(0 downto 0);
    signal s_decode_imm : cpu_word;
    signal s_decode_width_ram : std_logic_vector(2 downto 0);
    signal s_decode_en_write_ram : boolean;
    signal s_decode_en_read_ram : boolean;
    signal s_decode_ctrl_register : std_logic_vector(1 downto 0);
    signal s_decode_en_write_reg : boolean;
    signal s_decode_add_offset : cpu_word;

    component decode port(
        clk : in std_logic;
        instr : in cpu_word;
        rs1 : out reg_idx;
        rs2 : out reg_idx;
        rd : out reg_idx;
        alu_out : out alu_op;
        zero_flag : in boolean;
        en_imm : out std_logic_vector(0 downto 0);
        imm : out cpu_word;
        width_ram : out std_logic_vector(2 downto 0);
        en_write_ram : out boolean;
        en_read_ram : out boolean;
        en_write_reg : out boolean;
        ctrl_register : out std_logic_vector(1 downto 0);
        add_offset : out cpu_word;
        pc_set : out std_logic
    );
    end component;
    
    signal s_bram_data_out : cpu_word;
    signal s_bram_addr : cpu_word;
    signal s_bram_instr_out : cpu_word;
    component block_ram port(
        clk : in std_logic;
        reset : in std_logic;
        data_in : in cpu_word;
        addr : in cpu_word;
        pc_in : in cpu_word;
        en_write : in boolean;
        en_read : in boolean;
        width : in std_logic_vector(2 downto 0);
        instr_out : out cpu_word;
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
        en_write : in boolean;
        data_out1 : out cpu_word;
        data_out2 : out cpu_word
    );
    end component;
    
    signal s_alu_result : cpu_word;
    signal s_alu_zero_flag : boolean;
    component alu port (
        data_in1 : in cpu_word;
        data_in2 : in cpu_word;
        op_in : in alu_op;
        result : out cpu_word;
        zero_flag : out boolean
    );
    end component;

    signal s_mux_register_result : cpu_word;
    signal s_mux_alu_result : cpu_word;
    component mux
        generic (N : natural);
        port(
        selector : in std_logic_vector((ceillog2(N)-1) downto 0);
        x : in cpu_word_arr;
        y : out cpu_word
        );
    end component;
    
begin
    c_mux_register : mux
        generic map(N => 4)
        port map(
        selector => s_decode_ctrl_register,
        x(0) =>  s_alu_result,
        x(1) =>  s_bram_data_out,
        x(2) =>  s_pc_value_out_next,
        y => s_mux_register_result
        );

    c_mux_alu : mux
        generic map(N => 2)
        port map(
        selector => s_decode_en_imm,
        x(0) =>  s_register_data_out2,
        x(1) => s_decode_imm,
        y => s_mux_alu_result
        );

    c_pc : pc port map(
        clk => m_clk,
        set => s_pc_set,
        set_value => s_pc_set_value,
        reset => m_pc_reset,
        value_out => s_pc_value_out,
        value_out_next => s_pc_value_out_next
    );
    
    
    c_decode : decode port map(
        clk => m_clk,
        instr => s_bram_instr_out,
        rs1 => s_decode_rs1,
        rs2 => s_decode_rs2,
        rd => s_decode_rd,
        alu_out => s_decode_alu_out,
        zero_flag => s_alu_zero_flag,
        en_imm => s_decode_en_imm,
        imm => s_decode_imm,
        width_ram => s_decode_width_ram,
        en_write_ram => s_decode_en_write_ram,
        en_read_ram => s_decode_en_read_ram,
        ctrl_register => s_decode_ctrl_register,
        en_write_reg => s_decode_en_write_reg,
        pc_set => s_pc_set,
        add_offset => s_pc_set_value 
    );
    
    c_bram : block_ram port map(
        clk => m_clk,
        reset => m_bram_reset,
        data_in => s_register_data_out2,
        addr => s_alu_result,
        pc_in => s_pc_value_out,
        en_write => s_decode_en_write_ram,
        en_read => s_decode_en_read_ram,
        data_out => s_bram_data_out,
        width => s_decode_width_ram,
        instr_out => s_bram_instr_out
    );
    
    c_registerfile : registerfile port map(
        clk => m_clk,
        reset => m_register_reset,
        rs1 => s_decode_rs1,
        rs2 => s_decode_rs2,
        rd => s_decode_rd,
        data_in => s_mux_register_result,
        data_out1 => s_register_data_out1,
        data_out2 => s_register_data_out2,
        en_write => s_decode_en_write_reg
    );
    
    c_alu : alu port map(
        data_in1 => s_register_data_out1,
        data_in2 => s_mux_alu_result,
        op_in => s_decode_alu_out,
        result => s_alu_result,
        zero_flag => s_alu_zero_flag
    );
    
    
        
end Structural;
