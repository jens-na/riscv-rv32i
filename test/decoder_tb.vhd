library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

use work.utils.all;
use work.opcodes.all;

entity decode_tb is
--  Port ( );
end decode_tb;

architecture Behavioral of decode_tb is

	constant clk_period : time := 10 ns;
	signal clk, en_imm : std_logic;
	signal instr, imm : cpu_word;
	signal rs1, rs2, rd : reg_idx;
	signal alu_out : alu_op;
    signal en_write_ram, mem_instr : boolean;
    signal width_ram : std_logic_vector(2 downto 0);

begin
	UUT : entity work.decode port map (clk => clk, en_imm => en_imm, instr => instr,
										imm => imm, rs1 => rs1, rs2 => rs2, rd => rd,
										alu_out => alu_out, en_write_ram => en_write_ram,
                                        width_ram => width_ram, mem_instr => mem_instr);

	process
	begin
		wait for 10 ns;
		clk <= '1';
		wait for clk_period / 2;

		clk <= '0';
		wait for clk_period / 2;
	end process;

	process
	begin

		-- ADDI
		instr <= (others => '0');
		instr(31 downto 20) <= std_logic_vector(to_unsigned(0, 12)); --immediate
		instr(19 downto 15) <= std_logic_vector(to_unsigned(1, 5)); -- rs1
		instr(11 downto 7) <= std_logic_vector(to_unsigned(2,5)); -- rd 
		instr(6 downto 0) <= I_TYPE_AL;

		wait until falling_edge(clk);

		-- SLTI
		instr <= (others => '0');
		instr(14 downto 12) <= "010"; -- funct3 SLTI
		instr(31 downto 20) <= std_logic_vector(to_unsigned(1,12)); --immediate
		instr(19 downto 15) <= std_logic_vector(to_unsigned(2,5)); --rs1
		instr(11 downto 7) <= std_logic_vector(to_unsigned(3,5)); --rd
		instr(6 downto 0) <= I_TYPE_AL;

		wait until falling_edge(clk);



		
	end process;
end Behavioral;
