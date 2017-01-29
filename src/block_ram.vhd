library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils.all;

entity block_ram is
	generic (
		ram_size : integer := 1024;
		address_bits : integer := cpu_word_length
	);
    port ( 
        clk : in std_logic;
        reset : in std_logic;
        data_in : in cpu_word;
        addr : in cpu_word;
        pc_in : in cpu_word;
        en_write : in boolean;
        width : in std_logic_vector(2 downto 0);
        instr_out : out cpu_word;
        data_out : out cpu_word
    );
    end block_ram;

architecture Behavioral of block_ram is
	type memory_t is array ((ram_size) - 1 downto 0) of std_logic_vector (7 downto 0);

    -- addi instruction addi x1,x2,12
    signal instr_addi_1 : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(16#00c10093#,32));
    

	signal memory : memory_t := ( 
-- helper for building instructions
--00000000 00110000 00101110 00100011

        -- LW rs1=0 rd=1 imm=20
       --0 => "10000011",
       --1 => "00100000",
       --2 => "01000000",
       --3 => "00000001",
       -- end LW

        -- LW rs1=0 rd=2 imm=24
       --4 => "00000011",
       --5 => "00100001",
       --6 => "10000000",
       --7 => "00000001",
       -- end LW


        --ADD rs1=1 rs2=2 rd=3
       --8 => "10110011",
       --9 => "10000001",
       --10 => "00100000",
       --11 => "00000000",
       -- end ADD

       -- SW rs1=0 rs2=3 imm=28
       --12 => "00100011",
       --13 => "00101110",
       --14 => "00110000",
       --15 => "00000000",
       --end SW

       -- word loaded by first instr
       --20 => "00000011",
       --21 => "00000000",
       --22 => "00000000",
       --23 => "00000000",
       -- word loaded by 2nd instr
       --24 => "00000101",
       --25 => "00000000",
       --26 => "00000000",
       --27 => "00000000",
       -- word stored by 3rd instr => don't use 
       --28 => "00000000",
       --29 => "00000000",
       --30 => "00000000",
       --31 => "00000000",

       -- beq coompare rs1=1 and rs2=2 offset=?
       -- offset = 0000000000000000000011000000000 = 1536
       0 => "01100011",
       1 => "10000100",
       2 => "00100000",
       3 => "10000000",

       --0 => instr_addi_1(31 downto 24),
       --1 => instr_addi_1(23 downto 16),
       --2 => instr_addi_1(15 downto 8),
       --3 => instr_addi_1(7 downto 0),


       others => (others => '0')
    );
begin

	process (clk, pc_in)
	begin

        instr_out(7 downto 0) <= memory(to_integer(unsigned(pc_in)));
        instr_out(15 downto 8) <= memory(to_integer(unsigned(pc_in) + 1));
        instr_out(23 downto 16) <= memory(to_integer(unsigned(pc_in) + 2));
        instr_out(31 downto 24) <= memory(to_integer(unsigned(pc_in) + 3));

		if rising_edge(clk) then
			
			if reset = '1' then
				-- clear data_out on reset
				data_out <= (others => '0');
			end if;

			if en_write = true then

                case width is
                    -- store byte
                    when "000" =>
                        memory(to_integer(unsigned(addr))) <= data_in(7 downto 0);

                    -- store halfword
                    when "001" =>
                        memory(to_integer(unsigned(addr))) <= data_in(7 downto 0);
                        memory(to_integer(unsigned(addr) + 1)) <= data_in(15 downto 8);

                    -- store word
                    when "010" =>
                        memory(to_integer(unsigned(addr))) <= data_in(7 downto 0);
                        memory(to_integer(unsigned(addr) + 1)) <= data_in(15 downto 8);
                        memory(to_integer(unsigned(addr) + 2)) <= data_in(23 downto 16);
                        memory(to_integer(unsigned(addr) + 3)) <= data_in(31 downto 24);

                    -- do nothing
                    when others =>
                        null;

                end case;
		    end if; --en_write
        end if; -- rising_edge

        if en_write = false then

            -- read mem asynchronus
            case width is

                -- load sign extended byte
                when "000" =>
                    data_out <= 
                    cpu_word(resize(signed(memory(to_integer(unsigned(addr)))), data_out'length));

                -- load sign extended halfword
                when "001" =>
                    data_out(7 downto 0) <= memory(to_integer(unsigned(addr)));
                    data_out(31 downto 8) <= 
                    std_logic_vector(resize(signed(memory(to_integer(unsigned(addr) + 1))), 24));

                -- load word
                when "010" =>
                    data_out(7 downto 0) <= memory(to_integer(unsigned(addr)));
                    data_out(15 downto 8) <= memory(to_integer(unsigned(addr) + 1));
                    data_out(23 downto 16) <= memory(to_integer(unsigned(addr) + 2));
                    data_out(31 downto 24) <= memory(to_integer(unsigned(addr) + 3));


                -- load zero extended byte
                when "100" =>
                    data_out <= 
                    cpu_word(resize(unsigned(memory(to_integer(unsigned(addr)))), data_out'length));

                -- load zero extended halfword
                when "101" =>
                    data_out(7 downto 0) <= memory(to_integer(unsigned(addr)));
                    data_out(31 downto 8) <= 
                    std_logic_vector(resize(unsigned(memory(to_integer(unsigned(addr) + 1))), 24));

                when others =>
                    null;

            end case;
        end if;	-- en_write


	end process;

end Behavioral;
