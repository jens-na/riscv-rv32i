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

    -- sll t2,t0,2
    68 => x"93",
    69 => x"93",
    70 => x"22",
    71 => x"00",

    -- srl t0,t2,4
    72 => x"93",
    73 => x"d2",
    74 => x"43",
    75 => x"00",

    -- addi t0,t0,-30
    76 => x"13",
    77 => x"83",
    78 => x"22",
    79 => x"fe",

    -- srl t0,t2,t1
    80 => x"b3",
    81 => x"d2",
    82 => x"63",
    83 => x"00",
    
    -- sll t0,t2,t1
    84 => x"b3",
    85 => x"92",
    86 => x"63",
    87 => x"00",
    
    -- sb t2,508(zero)
    88 => x"23",
    89 => x"0e",
    90 => x"70",
    91 => x"1e",
    
    -- sh t0,508(zero)
    92 => x"23",
    93 => x"1e",
    94 => x"50",
    95 => x"1e",
    
    -- sw t0,508(zero)
    96 => x"23",
    97 => x"2f",
    98 => x"50",
    99 => x"1e",

    -- slt t0,t1,t2
    100 => x"b3",
    101 => x"22",
    102 => x"73",
    103 => x"00",

    -- slt t0,t2,t1
    104 => x"b3",
    105 => x"a2",
    106 => x"63",
    107 => x"00",

    -- snez t1,t2 (sltu t1, x0, t2)
    108 => x"33",
    109 => x"33",
    110 => x"70",
    111 => x"00",

    -- snez t1,t0 (sltu t1, x0, t0)
    112 => x"33",
    113 => x"33",
    114 => x"50",
    115 => x"00",
    
    -- slti t0,t2,550
    116 => x"93",
    117 => x"a2",
    118 => x"63",
    119 => x"22",

    -- sltiu t1,t2,550
    120 => x"13",
    121 => x"b3",
    122 => x"63",
    123 => x"22",

    -- addi t0, x0, 0xfffffffe
    124 => x"93",
    125 => x"02",
    126 => x"e0",
    127 => x"ff",

    -- sra t0,t0,t1
    128 => x"b3",
    129 => x"d2",
    130 => x"62",
    131 => x"40",

    -- addi t0, x0, 0xfffffffe
    132 => x"93",
    133 => x"02",
    134 => x"e0",
    135 => x"ff",

    -- srai t0,t0,0x1
    136 => x"93",
    137 => x"d2",
    138 => x"12",
    139 => x"40",
    
    -- jal, x0,0x0
    -- 12 lowest bits: 0000 0110 1111
    140 => x"6f",
    141 => x"00",
    142 => x"00",
    143 => x"00",

    -- jal, ra, 0x12c (300)
    -- 0001 0010 1100 0000 0000 0000 1110 1111
    144 => x"ef",
    145 => x"00",
    146 => x"c0",
    147 => x"12",

    -- jalr x0,x1,0
    -- jumps back to address that is held in x1(ra)
    448 => x"67",
    449 => x"80",
    450 => x"00",
    451 => x"00",

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
