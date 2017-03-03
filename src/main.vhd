library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity main is
  Port (
    m_clk: in std_logic;
    m_pc_reset : in std_logic;
    --m_bram_reset : in std_logic;
    m_register_reset : in std_logic;
    m_status_flag : out status_led_output
  );
end main;

architecture Structural of main is
    
    signal s_ram_control_en_write_out : boolean;
    signal s_ram_control_data_out_reg : cpu_word;
    signal s_ram_control_data_out_ram : cpu_word;
    signal s_ram_control_addr_out : std_logic_vector((ceillog2(RAM_SZ)-1) downto 0);
    component ram_control port(
        clk : in std_logic;
        width : in std_logic_vector(2 downto 0);
        addr_in : in cpu_word;
        en_write : in boolean; 
        data_in_reg : in cpu_word;
        data_in_ram : in cpu_word;
        en_write_out : out boolean;
        data_out_reg : out cpu_word;
        data_out_ram : out cpu_word;
        addr_out : out std_logic_vector((ceillog2(RAM_SZ)-1) downto 0)
    );
    end component;

    signal s_pc_value_out : cpu_word;
    signal s_pc_value_out_next : cpu_word;
    signal s_pc_set : std_logic_vector(1 downto 0);
    signal s_pc_set_value : cpu_word;
    component pc port(
        clk : in std_logic;
        set : in std_logic_vector(1 downto 0);
        set_value : in cpu_word;
        set_jalr : in cpu_word;
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
    signal s_decode_ctrl_register : std_logic_vector(1 downto 0);
    signal s_decode_en_write_reg : boolean;
    signal s_decode_add_offset : cpu_word;

    component decode port(
        --clk : in std_logic;
        instr : in cpu_word;
        cur_pc : in cpu_word;
        rs1 : out reg_idx;
        rs2 : out reg_idx;
        rd : out reg_idx;
        alu_out : out alu_op;
        zero_flag : in boolean;
        en_imm : out std_logic_vector(0 downto 0);
        imm : out cpu_word;
        width_ram : out std_logic_vector(2 downto 0);
        en_write_ram : out boolean;
        ctrl_register : out std_logic_vector(1 downto 0);
        en_write_reg : out boolean;
        add_offset : out cpu_word;
        pc_set : out std_logic_vector(1 downto 0)
    );
    end component;
    
    signal s_bram_data_out : cpu_word;
    signal s_bram_instr_out : cpu_word;
    component block_ram port(
        clk : in std_logic;
        --reset : in std_logic;
        data_in : in cpu_word;
        addr : in std_logic_vector((ceillog2(RAM_SZ)-1) downto 0);
        pc_in : in cpu_word;
        en_write : in boolean;
        instr_out : out cpu_word;
        data_out : out cpu_word
    );
    end component;
    
    signal s_register_data_out1 : cpu_word;
    signal s_register_data_out2 : cpu_word;
    signal s_register_status : status_led_output;
    component registerfile port(
        clk : in std_logic;
        reset : in std_logic;
        rs1 : in reg_idx;
        rs2 : in reg_idx;
        rd : in reg_idx;
        data_in : in cpu_word;
        en_write : in boolean;
        data_out1 : out cpu_word;
        data_out2 : out cpu_word;
        status : out status_led_output
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
        x(1) =>  s_ram_control_data_out_reg,
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

    c_ram_control : ram_control port map(
        clk => m_clk,
        width => s_decode_width_ram,
        addr_in => s_alu_result,
        en_write => s_decode_en_write_ram,
        data_in_reg => s_register_data_out2,
        data_in_ram => s_bram_data_out,
        en_write_out => s_ram_control_en_write_out, 
        data_out_reg => s_ram_control_data_out_reg,
        data_out_ram => s_ram_control_data_out_ram,
        addr_out => s_ram_control_addr_out
    );

    c_pc : pc port map(
        clk => m_clk,
        set => s_pc_set,
        set_value => s_pc_set_value,
        set_jalr => s_alu_result,
        reset => m_pc_reset,
        value_out => s_pc_value_out,
        value_out_next => s_pc_value_out_next
    );
    
    
    c_decode : decode port map(
        --clk => m_clk,
        instr => s_bram_instr_out,
        cur_pc => s_pc_value_out_next,
        rs1 => s_decode_rs1,
        rs2 => s_decode_rs2,
        rd => s_decode_rd,
        alu_out => s_decode_alu_out,
        zero_flag => s_alu_zero_flag,
        en_imm => s_decode_en_imm,
        imm => s_decode_imm,
        width_ram => s_decode_width_ram,
        ctrl_register => s_decode_ctrl_register,
        en_write_ram => s_decode_en_write_ram,
        en_write_reg => s_decode_en_write_reg,
        pc_set => s_pc_set,
        add_offset => s_pc_set_value 
    );
    
    c_bram : block_ram port map(
        clk => m_clk,
        data_in => s_ram_control_data_out_ram,
        addr => s_ram_control_addr_out,
        pc_in => s_pc_value_out,
        en_write => s_ram_control_en_write_out,
        data_out => s_bram_data_out,
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
        en_write => s_decode_en_write_reg,
        status => s_register_status
    );
    
    c_alu : alu port map(
        data_in1 => s_register_data_out1,
        data_in2 => s_mux_alu_result,
        op_in => s_decode_alu_out,
        result => s_alu_result,
        zero_flag => s_alu_zero_flag
    );       
    
    m_status_flag <= s_register_status;
    
end Structural;
