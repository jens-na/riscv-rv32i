library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use work.utils.all;
use work.opcodes.all;

entity decode is
  Port (
    clk : in std_logic;
    instr : in cpu_word;
    rs1 : out reg_idx;
    rs2 : out reg_idx;
    rd : out reg_idx;
    alu_out : out alu_op;
    en_imm : out std_logic;
    imm : out cpu_word
  );
end decode;

architecture Behavioral of decode is

signal opc : opcode;
signal funct3 : std_logic_vector(2 downto 0);
signal funct7 : std_logic_vector(6 downto 0);
signal funct10 : std_logic_vector (9 downto 0);
signal rs1_next, rs2_next, rd_next : reg_idx;
signal alu_out_next : alu_op;
signal en_imm_next : std_logic;
signal imm_next : cpu_word;

begin
	process(clk)
	begin
		if (rising_edge(clk)) then 
			rs1 <= rs1_next;
			rs2 <= rs2_next;
			rd <= rd_next;
			alu_out <= alu_out_next;
			en_imm <= en_imm_next;
			imm <= imm_next;
		end if;
	end process;

	-- next state logic

	rs1_next <= instr(19 downto 15);
	rs2_next <= instr(24 downto 20);
	rd_next <= instr(11 downto 7);
	opc <= instr(6 downto 0); 
	funct3 <= instr(14 downto 12);
	funct7 <= instr(31 downto 25);

	process(instr)
	begin
		case opc is
			-------------------------------------------
			when I_TYPE_AL =>

				en_imm_next <= '1';

				-- alu_out
				case instr(14 downto 12) is
					when "000" =>
						alu_out_next <= ALU_ADD;
					when "010" =>  
						alu_out_next <= ALU_SLT;
					when "011" => 
						alu_out_next <= ALU_SLTU;
					when "100" => 
						alu_out_next <= ALU_XOR;
					when "110" => 
						alu_out_next <= ALU_OR;
					when "111" => 
						alu_out_next <= ALU_AND;
					when "001" => 
						alu_out_next <= ALU_SLL;
					when others => 
						case instr(31 downto 25) is
							when "0000000" =>
								alu_out_next <= ALU_SRL;
							when others =>
								alu_out_next <= ALU_SRA;
						end case;
				end case;

				-- imm
				case funct3 is
					when "001" | "101" =>
						imm_next(31 downto 5) <= (others => '0');
						imm_next(4 downto 0) <= instr(24 downto 20);
					when others =>
						imm_next(31 downto 12) <= (others => '0');
						imm_next(11 downto 0) <= instr(31 downto 20);
				end case;


			when R_TYPE =>

				en_imm_next <= '0';

				-- alu_out
				case instr(14 downto 12) is
					when "000" =>
						case instr(31 downto 25) is
							when (others => '0') =>
								alu_out_next <= ALU_ADD;
							when others =>
								alu_out_next <= ALU_SUB;
						end case;
					when "001" =>
						alu_out_next <= ALU_SLL;
					when "010" =>
						alu_out_next <= ALU_SLT;
					when "011" =>
						alu_out_next <= ALU_SLTU;
					when "100" =>
						alu_out_next <= ALU_XOR;
					when "101" =>
						case instr(31 downto 25) is
							when (others => '0') =>
								alu_out_next <= ALU_SRL;
							when others =>
								alu_out_next <= ALU_SRA;
						end case;
					when "110" =>
						alu_out_next <= ALU_OR;
					when others =>
						alu_out_next <= ALU_AND;
				end case;
				
			when others =>
				en_imm_next <= '0';
				imm_next <= (others => '0');
		end case;
	end process;



end Behavioral;
