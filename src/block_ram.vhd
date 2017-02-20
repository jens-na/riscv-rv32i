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
        en_read : in boolean;
        width : in std_logic_vector(2 downto 0);
        instr_out : out cpu_word;
        data_out : out cpu_word
    );
    end block_ram;

architecture Behavioral of block_ram is
	type memory_t is array ((ram_size) - 1 downto 0) of std_logic_vector (7 downto 0);
	signal memory : memory_t := ( 

    -- lb t0,500(zero)
    0 => x"83",
    1 => x"02",
    2 => x"40",
    3 => x"1f",

    -- lb t0,501(zero)
    4 => x"83",
    5 => x"02",
    6 => x"50",
    7 => x"1f",

    -- lh t1,500(zero)
    8 => x"03",
    9 => x"13",
    10 => x"40",
    11 => x"1f",

    -- lh t1,502(zero)
    12 => x"03",
    13 => x"13",
    14 => x"60",
    15 => x"1f",

    -- lw t2,500(zero)
    16 => x"83",
    17 => x"23",
    18 => x"40",
    19 => x"1f",

    -- lbu t0,504(zero)
    20 => x"83",
    21 => x"42",
    22 => x"80",
    23 => x"1f",

    -- lhu t1,506(zero)
    24 => x"03",
    25 => x"53",
    26 => x"a0",
    27 => x"1f",

    -- add t2,t0,t1
    28 => x"b3",
    29 => x"83",
    30 => x"62",
    31 => x"00",

    -- sub t2,t0,t1
    32 => x"b3",
    33 => x"83",
    34 => x"62",
    35 => x"40",

    -- xor t2,t0,t1
    36 => x"b3",
    37 => x"c3",
    38 => x"62",
    39 => x"00",

    -- or t2,t0,t1
    40 => x"b3",
    41 => x"e3",
    42 => x"62",
    43 => x"00",

    -- and t2,t0,t1
    44 => x"b3",
    45 => x"f3",
    46 => x"62",
    47 => x"00",

    -- addi t2,t0,1834
    48 => x"93",
    49 => x"83",
    50 => x"a2",
    51 => x"72",

    -- addi t2,t0,-1
    52 => x"93",
    53 => x"83",
    54 => x"f2",
    55 => x"ff",

    -- xori t2,t0,73
    56 => x"93",
    57 => x"c3",
    58 => x"92",
    59 => x"04",

    -- ori t2,t0,73
    60 => x"93",
    61 => x"e3",
    62 => x"92",
    63 => x"04",

    -- and t2,t0,73
    64 => x"93",
    65 => x"f3",
    66 => x"92",
    67 => x"04",


    -- load/store-area
    500 => x"85",
    501 => x"07",
    502 => x"07",
    503 => x"82",

    504 => x"81",
    505 => x"0f",
    506 => x"13",
    507 => x"87",

        -- LW rs1=0 rd=2 imm=24
--       4 => "00000011",
--       5 => "00100001",
--       6 => "10000000",
--       7 => "00000001",
--     -- end LW
--
--
--      --ADD rs1=1 rs2=2 rd=3
--       8 => "10110011",
--       9 => "10000001",
--       10 => "00100000",
--       11 => "00000000",
--     -- end ADD
--
--     -- SW rs1=0 rs2=3 imm=28
--       12 => "00100011",
--       13 => "00101110",
--       14 => "00110000",
--       15 => "00000000",
--     --end SW
--
--     -- lui rd=4 imm=0x00025000
--       16 => x"37",
--       17 => x"52",
--       18 => x"02",
--       19 => x"00",
       --end lui

       -- word loaded by first instr
--       20 => "00000011",
--       21 => "00000000",
--       22 => "00000000",
--       23 => "00000000",
--       -- word loaded by 2nd instr
--       24 => "00000101",
--       25 => "00000000",
--       26 => "00000000",
--       27 => "00000000",
--       -- word stored by 4th instr => don't use 
--       28 => "00000000",
--       29 => "00000000",
--       30 => "00000000",
--       31 => "00000000",
        
    


       others => (others => '0')
    );
begin

	process (clk, pc_in)
	begin

        instr_out(7 downto 0) <= memory(to_integer(unsigned(pc_in)));
        instr_out(15 downto 8) <= memory(to_integer(unsigned(pc_in) + 1));
        instr_out(23 downto 16) <= memory(to_integer(unsigned(pc_in) + 2));
        instr_out(31 downto 24) <= memory(to_integer(unsigned(pc_in) + 3));

        -- standard assignment
        data_out <= (others => '0');

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

        if en_read = true then

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
        end if;	-- en_read


	end process;

end Behavioral;
