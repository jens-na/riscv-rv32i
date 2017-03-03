library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils.all;
use work.opcodes.all;

entity block_ram is
	generic (
		ram_size : integer := RAM_SZ;
		address_bits : integer := cpu_word_length
	);
    port ( 
        clk : in std_logic;
        data_in : in cpu_word;
        addr : in std_logic_vector((ceillog2(RAM_SZ)-1) downto 0);
        pc_in : in cpu_word;
        en_write : in boolean;
        instr_out : out cpu_word;
        data_out : out cpu_word
    );
    end block_ram;

architecture Behavioral of block_ram is
	type memory_t is array ((ram_size) - 1 downto 0) of std_logic_vector (31 downto 0);
	signal memory : memory_t := ( 

    -- lb t0,500(zero)
    0 => x"1f400283",

    -- lb t0,501(zero)
    1 => x"1f500283",

    -- lh t1,500(zero)
    2 => x"1f401303",

    -- lh t1,502(zero)
    3 => x"1f601303",

    -- lw t2,500(zero)
    4 => x"1f402383",

    -- lbu t0,504(zero)
    5 => x"1f804283",

    -- lhu t1,506(zero)
    6 => x"1fa05303",

    -- add t2,t0,t1
    7 => x"006283b3",
--    28 => x"b3",
--    29 => x"83",
--    30 => x"62",
--    31 => x"00",
--
    -- sub t2,t0,t1
    8 => x"406283b3",
--    32 => x"b3",
--    33 => x"83",
--    34 => x"62",
--    35 => x"40",
--
    -- xor t2,t0,t1
    9 => x"0062c3b3",
--    36 => x"b3",
--    37 => x"c3",
--    38 => x"62",
--    39 => x"00",
--
    -- or t2,t0,t1
    10 => x"0062e3b2",
--    40 => x"b3",
--    41 => x"e3",
--    42 => x"62",
--    43 => x"00",
--
    -- and t2,t0,t1
    11 => x"0062f3b3",
--    44 => x"b3",
--    45 => x"f3",
--    46 => x"62",
--    47 => x"00",
--
    -- addi t2,t0,1834
    12 => x"72a28393",
--    48 => x"93",
--    49 => x"83",
--    50 => x"a2",
--    51 => x"72",
--
    -- addi t2,t0,-1
    13 => x"fff28393",
--    52 => x"93",
--    53 => x"83",
--    54 => x"f2",
--    55 => x"ff",
--
    -- xori t2,t0,73
    14 => x"0492c393",
--    56 => x"93",
--    57 => x"c3",
--    58 => x"92",
--    59 => x"04",
--
    -- ori t2,t0,73
    15 => x"0492e393",
--    60 => x"93",
--    61 => x"e3",
--    62 => x"92",
--    63 => x"04",
--
    -- and t2,t0,73
    16 => x"0492f393",
--    64 => x"93",
--    65 => x"f3",
--    66 => x"92",
--    67 => x"04",
--
    -- sll t2,t0,2
    17 => x"00229393",
--    68 => x"93",
--    69 => x"93",
--    70 => x"22",
--    71 => x"00",
--
    -- srl t0,t2,4
    18 => x"0043d293",
--    72 => x"93",
--    73 => x"d2",
--    74 => x"43",
--    75 => x"00",
--
    -- addi t0,t0,-30
    19 => x"fe228313",
--    76 => x"13",
--    77 => x"83",
--    78 => x"22",
--    79 => x"fe",
--
    -- srl t0,t2,t1
    20 => x"0063d2b3",
--    80 => x"b3",
--    81 => x"d2",
--    82 => x"63",
--    83 => x"00",
    
    -- sll t0,t2,t1
    21 => x"006392b3",
--    84 => x"b3",
--    85 => x"92",
--    86 => x"63",
--    87 => x"00",
--    
    -- sb t2,508(zero)
    22 => x"1e700e23",
--    88 => x"23",
--    89 => x"0e",
--    90 => x"70",
--    91 => x"1e",
--    
    -- sh t0,508(zero)
    23 => x"1e501e23",
--    92 => x"23",
--    93 => x"1e",
--    94 => x"50",
--    95 => x"1e",
--    
    -- sw t0,508(zero)
    24 => x"1e502f23",
--    96 => x"23",
--    97 => x"2f",
--    98 => x"50",
--    99 => x"1e",
--
--    -- slt t0,t1,t2
--    100 => x"b3",
--    101 => x"22",
--    102 => x"73",
--    103 => x"00",
--
--    -- slt t0,t2,t1
--    104 => x"b3",
--    105 => x"a2",
--    106 => x"63",
--    107 => x"00",
--
--    -- snez t1,t2 (sltu t1, x0, t2)
--    108 => x"33",
--    109 => x"33",
--    110 => x"70",
--    111 => x"00",
--
--    -- snez t1,t0 (sltu t1, x0, t0)
--    112 => x"33",
--    113 => x"33",
--    114 => x"50",
--    115 => x"00",
--    
--    -- slti t0,t2,550
--    116 => x"93",
--    117 => x"a2",
--    118 => x"63",
--    119 => x"22",
--
--    -- sltiu t1,t2,550
--    120 => x"13",
--    121 => x"b3",
--    122 => x"63",
--    123 => x"22",
--
--    -- addi t0, x0, 0xfffffffe
--    124 => x"93",
--    125 => x"02",
--    126 => x"e0",
--    127 => x"ff",
--
--    -- sra t0,t0,t1
--    128 => x"b3",
--    129 => x"d2",
--    130 => x"62",
--    131 => x"40",
--
--    -- addi t0, x0, 0xfffffffe
--    132 => x"93",
--    133 => x"02",
--    134 => x"e0",
--    135 => x"ff",
--
--    -- srai t0,t0,0x1
--    136 => x"93",
--    137 => x"d2",
--    138 => x"12",
--    139 => x"40",
--    
--    -- jal, x0,0x0
--    -- 12 lowest bits: 0000 0110 1111
--    140 => x"6f",
--    141 => x"00",
--    142 => x"00",
--    143 => x"00",
--
--    -- jal, ra, 0x12c (300)
--    -- 0001 0010 1100 0000 0000 0000 1110 1111
--    144 => x"ef",
--    145 => x"00",
--    146 => x"c0",
--    147 => x"12",
--
--    -- addi t0, x0, 0x1
--    148 => x"93",
--    149 => x"02",
--    150 => x"10",
--    151 => x"00",
--
--    -- beq t0, t1, 296
--    -- 0001 0010 0110 0010 1000 0010 0110 0011
--    152 => x"63",
--    153 => x"82",
--    154 => x"62",
--    155 => x"12",
--
--    -- bne t0, t2, 288
--    156 => x"63",
--    157 => x"90",
--    158 => x"72",
--    159 => x"12",
--    
--    -- blt t1,t2, 284
--    160 => x"63",
--    161 => x"4e",
--    162 => x"73",
--    163 => x"10",
--
--    -- bge t2,t1, 280
--    164 => x"63",
--    165 => x"dc",
--    166 => x"63",
--    167 => x"10",
--
--    -- bltu t1,t2, 276
--    168 => x"63",
--    169 => x"6a",
--    170 => x"73",
--    171 => x"10",
--
--    --bgeu t2,t1, 272
--    172 => x"63",
--    173 => x"f8",
--    174 => x"63",
--    175 => x"10",
--
--    -- lui s0,0xacc21
--    176 => x"37",
--    177 => x"14",
--    178 => x"c2",
--    179 => x"ac",
--    
--    -- auipc, s0,0x200
--    180 => x"17",
--    181 => x"04",
--    182 => x"20",
--    183 => x"00",
--
--    -- auipc, s0,0x200
--    184 => x"17",
--    185 => x"04",
--    186 => x"00",
--    187 => x"f0",
--
    -- addi, a0, x0, 0x2
    47 => x"00200513",
--    188 => x"13",
--    189 => x"05",
--    190 => x"20",
--    191 => x"00",
--
--    -- jalr x0,x1,0
--    -- jumps back to address that is held in x1(ra)
--    448 => x"67",
--    449 => x"80",
--    450 => x"00",
--    451 => x"00",
--
    -- load/store-area
    125 => x"82070785",
    126 => x"87130f81",


       others => (others => '0')
    );
begin

	process (clk, addr)
	begin

		if rising_edge(clk) then
			
			if en_write = true then

                memory(to_integer(unsigned(addr))) <= data_in;

		    end if; --en_write
        end if; -- rising_edge

    end process;


    -- read mem asynchronus
    data_out <= memory(to_integer(unsigned(addr)));


    -- read instr asynchronus
    instr_out <= memory(to_integer(unsigned(pc_in)));

end Behavioral;
