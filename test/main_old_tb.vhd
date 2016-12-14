library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity main_old_tb is
--  Port ( );
end main_old_tb;

architecture Behavioral of main_old_tb is

	constant clk_period : time := 10 ns;
	constant N : integer := 32;

    -- general stuff
    signal clk, reset : std_logic;
    
    -- pc
    signal s_pc_out : cpu_word; -- nach Fetch
    signal s_set : std_logic;
    signal s_reset : std_logic;
    signal s_set_value : cpu_word;
    
    -- fetch    
    signal s_fetch_out : cpu_word;
    signal s_fetch_write_out : boolean;
    signal s_fetch_enable_out : boolean;
    
    -- decode
    signal s_rs1 : reg_idx;
    signal s_rs2 : reg_idx;
    signal s_rd : reg_idx;
    signal s_alu_out : alu_op;
    signal s_en_imm : std_logic_vector(3 downto 0);
    signal s_imm : cpu_word;
    
    
    -- block ram
    signal s_ram_data_in : cpu_word;
    signal s_ram_en_write : std_logic;
    signal s_ram_enable : std_logic;
    signal s_ram_data_out : cpu_word;
    
    -- mux zwischen register, decode und alu
    signal s_decode_register_alu_mux_selector : std_logic_vector(3 downto 0);
    signal s_decode_register_alu_mux_x : cpu_word_1x16;
    signal s_decode_register_alu_mux_out : cpu_word;
    
    -- registerfile
    signal s_reg_data_in : cpu_word;
    signal s_reg_data_out2 : cpu_word;
    
    -- alu
    signal s_zero_flag : boolean;
begin
    UUT : entity main_old.main port map(
        clk => clk, 
        reset => reset, 
        pp_s_pc_out => s_pc_out,
        pp_s_set => s_set,
        pp_s_reset => s_reset,
        pp_s_set_value => s_set_value,
        
        pp_s_fetch_out => s_fetch_out,
        pp_s_fetch_write_out => s_fetch_write_out,
        pp_s_fetch_enable_out => s_fetch_enable_out,
        
        pp_s_rs1 => s_rs1,
        pp_s_rs2 => s_rs2,
        pp_s_rd => s_rd,
        pp_s_alu_out => s_alu_out,
        pp_s_en_imm => s_en_imm,
        pp_s_imm => s_imm,
        
        pp_s_ram_data_in => s_ram_data_in,
        pp_s_ram_en_write => s_ram_en_write,
        pp_s_ram_enable => s_ram_enable,
        pp_s_ram_data_out => s_ram_data_out,
        
        pp_s_decode_register_alu_mux_selector => s_decode_register_alu_mux_selector,
        pp_s_decode_register_alu_mux_x => s_decode_register_alu_mux_x,
        pp_s_decode_register_alu_mux_out => s_decode_register_alu_mux_out,
        
        pp_s_reg_data_in => s_reg_data_in,
        pp_s_reg_data_out2 => s_reg_data_out2,

        pp_s_zero_flag => s_zero_flag
        );

	process
	begin
		clk <= '1';
		wait for clk_period / 2;

		clk <= '0';
		wait for clk_period / 2;
	end process;
	
	process
	begin
	
	s_reset <= '1';
    wait until falling_edge(clk);
    s_reset <= '0';
	wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
    wait until falling_edge(clk);
	
	end process;

end Behavioral;
