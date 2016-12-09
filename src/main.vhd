library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

use work.utils.all;
use work.opcodes.all;

entity main is
  Port (
    clk: in std_logic;
    reset: in std_logic;
    pp_s_pc_out : out cpu_word;
    pp_s_set : out std_logic;
    pp_s_reset : out std_logic;
    pp_s_set_value : out cpu_word;
    pp_s_fetch_out : out cpu_word;
    pp_s_fetch_write_out : out boolean;
    pp_s_fetch_enable_out : out boolean;
    pp_s_rs1 : out reg_idx;
    pp_s_rs2 : out reg_idx;
    pp_s_rd : out reg_idx;
    pp_s_alu_out : out alu_op;
    pp_s_en_imm : out std_logic_vector(3 downto 0);
    pp_s_imm : out cpu_word;
    pp_s_ram_data_in : out cpu_word;
    pp_s_ram_en_write : out std_logic;
    pp_s_ram_enable : out std_logic;
    pp_s_ram_data_out : out cpu_word;
    pp_s_decode_register_alu_mux_selector : out std_logic_vector(3 downto 0);
    pp_s_decode_register_alu_mux_x : out cpu_word_1x16;
    pp_s_decode_register_alu_mux_out : out cpu_word;
    pp_s_reg_data_in : out cpu_word;
    pp_s_reg_data_out2 : out cpu_word;
    pp_s_zero_flag : out boolean
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
    signal s_fetch_out : cpu_word := (others => '0');
    signal s_fetch_write_out : boolean := false;
    signal s_fetch_enable_out : boolean := false;
    component c_fetch
        port (
            c_addr_in : in cpu_word;
            c_ram_addr : out cpu_word;
            c_ram_write : out boolean;
            c_ram_enable : out boolean
        );
    end component;
    
    -- Decode component
    signal s_rs1 : reg_idx;
    signal s_rs2 : reg_idx;
    signal s_rd : reg_idx;
    signal s_alu_out : alu_op;
    signal s_en_imm : std_logic_vector(3 downto 0);
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
    
    signal s_decode_register_alu_mux_selector : std_logic_vector(3 downto 0);
    signal s_decode_register_alu_mux_x : cpu_word_1x16;
    signal s_decode_register_alu_mux_out : cpu_word;
    component c_mux16
        port (
            c_selector : std_logic_vector(3 downto 0);
            c_x : cpu_word_1x16;
            c_y : cpu_word
        );
    end component;
    
    signal s_reg_data_in : cpu_word;
    signal s_reg_data_out2 : cpu_word;
    component c_registerfile
        port (
            c_clk : std_logic;
            c_reset : std_logic;
            c_rs1 : reg_idx;
            c_rs2 : reg_idx;
            c_rd : reg_idx;
            c_data_in : cpu_word;
            c_data_out1 : cpu_word;
            c_data_out2 : cpu_word
        );
    end component;
    
    signal s_zero_flag : boolean;
    component c_alu
        port (
            c_clk : std_logic;
            c_data_in1 : cpu_word;
            c_data_in2 : cpu_word;
            c_op_in : alu_op;
            c_result : cpu_word;
            c_zero_flag : boolean
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
    
    fetch : c_fetch port map(
        c_addr_in => s_pc_out,
        c_ram_addr => s_fetch_out,
        c_ram_write => s_fetch_write_out,
        c_ram_enable => s_fetch_enable_out
    );
    
    block_ram : c_block_ram port map(
        c_clk => clk,
        c_reset => reset,
        c_data_in => s_ram_data_in,
        c_addr => s_fetch_out,
        c_en_write => s_ram_en_write,
        c_enable => s_ram_enable,
        c_data_out => s_ram_data_out
    );
    
    
    decode : c_decode port map(
        c_clk => clk,
        c_instr => s_ram_data_out,
        c_rs1 => s_rs1,
        c_rs2 => s_rs2,
        c_rd => s_rd,
        c_alu_out => s_alu_out,
        c_en_imm => s_en_imm(0),
        c_imm => s_decode_register_alu_mux_x(0)
    );
    
    registerfile : c_registerfile port map (
        c_clk => clk,
        c_reset => reset,
        c_rs1 => s_rs1,
        c_rs2 => s_rs2,
        c_rd => s_rd,
        c_data_in => s_reg_data_in,
        c_data_out1 => s_decode_register_alu_mux_x(1),
        c_data_out2 => s_reg_data_out2
    );
    
    alu : c_alu port map (
        c_clk => clk,
        c_data_in1 => s_decode_register_alu_mux_out,
        c_data_in2 => s_reg_data_out2,
        c_op_in => s_alu_out,
        c_result => s_reg_data_in,
        c_zero_flag => s_zero_flag
    );
    
    -- Register -> | MUX | -> ALU
    -- Decode   -> |     |
    decode_register_alu_mux : c_mux16 port map(
        c_selector => s_en_imm,
        c_x =>  s_decode_register_alu_mux_x,
        c_y => s_decode_register_alu_mux_out
    );
    
    pp_s_pc_out <= s_pc_out;
    pp_s_set <= s_set;
    pp_s_reset <= s_reset;
    pp_s_set_value  <= s_set_value;
    
    pp_s_fetch_out  <= s_fetch_out;
    pp_s_fetch_write_out <= s_fetch_write_out;
    pp_s_fetch_enable_out <= s_fetch_enable_out;
    
    pp_s_rs1 <= s_rs1;
    pp_s_rs2 <= s_rs2;
    pp_s_rd <= s_rd;
    pp_s_alu_out <= s_alu_out;
    pp_s_en_imm <= s_en_imm;
    pp_s_imm <= s_imm;
    
    pp_s_ram_data_in <= s_ram_data_in;
    pp_s_ram_en_write <= s_ram_en_write;
    pp_s_ram_enable <= s_ram_enable;
    pp_s_ram_data_out <= s_ram_data_out;
    
    pp_s_decode_register_alu_mux_selector <= s_decode_register_alu_mux_selector;
    pp_s_decode_register_alu_mux_x <= s_decode_register_alu_mux_x;
    pp_s_decode_register_alu_mux_out <= s_decode_register_alu_mux_out;
    
    pp_s_reg_data_in <= s_reg_data_in;
    pp_s_reg_data_out2 <= s_reg_data_out2;
    
    pp_s_zero_flag <= s_zero_flag;
end Structural;