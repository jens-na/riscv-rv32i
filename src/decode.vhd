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
    en_imm : out std_logic_vector(0 downto 0);
    imm : out cpu_word;
  	en_write_ram : out boolean;
  	en_read_ram : out boolean;
	width_ram : out std_logic_vector(2 downto 0);
    add_pc_offset : out cpu_word;
    en_pc_set : out std_logic
    en_write_reg : out boolean;
    ctrl_register : out std_logic_vector(1 downto 0)
  );
end decode;

architecture Behavioral of decode is

--ctr_register
constant ALU : std_logic_vector(1 downto 0) := "00";
constant BRAM : std_logic_vector(1 downto 0) := "01";
constant PC : std_logic_vector(1 downto 0) := "10";

--en_imm
constant REG : std_logic_vector(0 downto 0) := "0";
constant IMMED : std_logic_vector(0 downto 0) := "1";

-- mux bram
constant ALU_BRAM : std_logic_vector(0 downto 0) := "0";
constant PC_BRAM : std_logic_vector(0 downto 0) := "1";

signal opc : opcode;
signal funct3 : std_logic_vector(2 downto 0);
signal funct7 : std_logic_vector(6 downto 0);
signal funct10 : std_logic_vector (9 downto 0);

begin

    -- same for every instruction
	rs2 <= instr(24 downto 20);
	rd <= instr(11 downto 7);
    width_ram <= instr(14 downto 12);

    -- for use in the process
	opc <= instr(6 downto 0); 
	funct3 <= instr(14 downto 12);
	funct7 <= instr(31 downto 25);

	process(instr, funct3, funct7, opc)
	begin
		case opc is
			-------------------------------------------
			when I_TYPE_AL =>

                rs1 <= instr(19 downto 15);
				en_imm <= IMMED;
                en_write_ram <= false;
                en_read_ram <= false;
                ctrl_register <= ALU;
                en_write_reg <= true;

				-- alu_out
				case funct3 is
					when "000" =>
						alu_out <= ALU_ADD;
					when "010" =>  
						alu_out <= ALU_SLT;
					when "011" => 
						alu_out <= ALU_SLTU;
					when "100" => 
						alu_out <= ALU_XOR;
					when "110" => 
						alu_out <= ALU_OR;
					when "111" => 
						alu_out <= ALU_AND;
					when "001" => 
						alu_out <= ALU_SLL;
					when others => 
						case funct7 is
							when "0000000" =>
								alu_out <= ALU_SRL;
							when others =>
								alu_out <= ALU_SRA;
						end case;
				end case;

				-- imm
				case funct3 is
					when "001" | "101" =>
						imm(31 downto 5) <= (others => '0');
						imm(4 downto 0) <= instr(24 downto 20);
					when others =>
						imm(31 downto 12) <= (others => '0');
						imm(11 downto 0) <= instr(31 downto 20);
				end case;


			when R_TYPE =>

                rs1 <= instr(19 downto 15);
				en_imm <= REG;
                en_write_ram <= false;
                en_read_ram <= false;
                ctrl_register <= ALU;
                en_write_reg <= true;

				-- alu_out
				case funct3 is
					when "000" =>
						case funct7 is
							when "0000000" =>
								alu_out <= ALU_ADD;
							when others =>
								alu_out <= ALU_SUB;
						end case;
					when "001" =>
						alu_out <= ALU_SLL;
					when "010" =>
						alu_out <= ALU_SLT;
					when "011" =>
						alu_out <= ALU_SLTU;
					when "100" =>
						alu_out <= ALU_XOR;
					when "101" =>
						case funct7 is
							when "0000000" =>
								alu_out <= ALU_SRL;
							when others =>
								alu_out <= ALU_SRA;
						end case;
					when "110" =>
						alu_out <= ALU_OR;
					when others =>
						alu_out <= ALU_AND;
				end case;


			when I_TYPE_LOAD =>

                rs1 <= instr(19 downto 15);
				alu_out <= ALU_ADD;
				en_imm <= IMMED;
				imm(31 downto 12) <= (others => '0');
				imm(11 downto 0) <= instr(31 downto 20);
				en_write_ram <= false;
                en_read_ram <= true;
                ctrl_register <= BRAM;
                en_write_reg <= true;
				
		    when UJ_TYPE =>
		         ctrl_register <= PC;
		         en_pc_set <= '1'; --TBD: sonst auf 0!
		         
		         add_pc_offset(31 downto 20) <= (others => instr(31));
		         add_pc_offset(19 downto 12) <= instr(19 downto 12);
		         add_pc_offset(11) <= instr(20);
		         add_pc_offset(10 downto 5) <= instr(30 downto 25);
                 add_pc_offset(4 downto 1) <= instr(24 downto 21);
                 add_pc_offset(0) <= '0';
                 		   
            when S_TYPE =>

                rs1 <= instr(19 downto 15);
                alu_out <= ALU_ADD;
                en_imm <= IMMED;
				imm(31 downto 12) <= (others => '0');
                imm(11 downto 5) <= instr(31 downto 25);
                imm(4 downto 0) <= instr(11 downto 7);
                en_write_ram <= true;
                en_read_ram <= false;
                en_write_reg <= false;

            when U_TYPE_LUI =>

                rs1 <= (others => '0');
                alu_out <= ALU_ADD;
                en_imm <= IMMED;
				imm(31 downto 12) <= instr(31 downto 12);
                imm(11 downto 0) <= (others => '0');
                en_write_ram <= false;
                en_read_ram <= false;
                en_write_reg <= true;
                ctrl_register <= ALU;

			when others =>
				en_imm <= REG;
				imm <= (others => '0');

		end case;
	end process;



end Behavioral;
