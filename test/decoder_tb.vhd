----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.12.2016 16:27:47
-- Design Name: 
-- Module Name: decoder_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity decoder_tb is
--  Port ( );
end decoder_tb;

architecture Behavioral of decoder_tb is

	constant clk_period : time := 10 ns;
	signal clk, en_imm : std_logic;
	signal instr, imm : cpu_word;
	signal rs1, rs2, rd : reg_idx;
	signal alu_out : alu_op;

begin
	UUT : entity work.decode port map (clk => clk, en_imm => en_imm, instr => instr,
										imm => imm, rs1 => rs1, rs2 => rs2, rd => rd,
										alu_out => alu_out);

	process
	begin
		wait for 1 ns;
		clk <= '1';
		wait for clk_period / 2;

		clk <= '0';
		wait for clk_period / 2;
	end process;

	process
	begin

		-- ADDI
		instr <= (others => '0');
		instr(22 downto 20) <= "111"; -- immediate == 7
		instr(19 downto 15) <= "00001"; -- rs1 == 1
		instr(11 downto 7) <= "00011"; -- rd == 3
		instr(6 downto 0) <= I_TYPE_AL;

		wait until falling_edge(clk);
		
		-- SLTI
		instr <= (others => '0');
		instr(14 downto 12) <= "010"; -- funct3 SLTI
		instr(22 downto 20) <= "110"; -- immediate == 6
		instr(19 downto 15) <= "00010"; -- rs1 == 2
		instr(11 downto 7) <= "00111"; -- rd == 7
		instr(6 downto 0) <= I_TYPE_AL;
		

		wait until falling_edge(clk);

	end process;
end Behavioral;
