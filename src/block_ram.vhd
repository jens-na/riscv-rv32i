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

        -- sub t2,t0,t1
        8 => x"406283b3",

        -- xor t2,t0,t1
        9 => x"0062c3b3",

        -- or t2,t0,t1
        10 => x"0062e3b3",

        -- and t2,t0,t1
        11 => x"0062f3b3",

        -- addi t2,t0,1834
        12 => x"72a28393",

        -- addi t2,t0,-1
        13 => x"fff28393",

        -- xori t2,t0,73
        14 => x"0492c393",

        -- ori t2,t0,73
        15 => x"0492e393",

        -- and t2,t0,73
        16 => x"0492f393",

        -- sll t2,t0,2
        17 => x"00229393",

        -- srl t0,t2,4
        18 => x"0043d293",

        -- addi t0,t0,-30
        19 => x"fe228313",

        -- srl t0,t2,t1
        20 => x"0063d2b3",
        
        -- sll t0,t2,t1
        21 => x"006392b3",

        -- sb t2,508(zero)
        22 => x"1e700e23",

        -- sh t0,508(zero)
        23 => x"1e501e23",

        -- sw t0,508(zero)
        24 => x"1e502f23",

        -- slt t0,t1,t2
        25 => x"007322b3",

        -- slt t0,t2,t1
        26 => x"0063a2b3",

        -- snez t1,t2 (sltu t1, x0, t2)
        27 => x"00703333",

        -- snez t1,t0 (sltu t1, x0, t0)
        28 => x"00503333",

        -- slti t0,t2,550
        29 => x"2263a293",

        -- sltiu t1,t2,550
        30 => x"2263b313",

        -- addi t0, x0, 0xfffffffe
        31 => x"ffe00293",

        -- sra t0,t0,t1
        32 => x"4062d2b3",

        -- addi t0, x0, 0xfffffffe
        33 => x"ffe00293",

        -- srai t0,t0,0x1
        34 => x"4012d293",
        
        -- jal, x0,0x0
        35 => x"0040006f",

        -- jal, ra, 0x12c (300)
        -- 0001 0010 1100 0000 0000 0000 1110 1111
        36 => x"12c000ef",

        -- addi t0, x0, 0x1
        37 => x"00100293",

        -- beq t0, t1, 296
        -- 0001 0010 0110 0010 1000 0010 0110 0011
        38 => x"12628263",

        -- bne t0, t2, 288
        39 => x"12729063",
        
        -- blt t1,t2, 284
        40 => x"10734e63",

        -- bge t2,t1, 280
        41 => x"1063dc63",

        -- bltu t1,t2, 276
        42 => x"10736a63",

        --bgeu t2,t1, 272
        43 => x"1063f863",

        -- lui s0,0xacc21
        44 => x"a2c21437",
        
        -- auipc, s0,0x200
        45 => x"00200417",

        -- auipc, s0,0x200
        46 => x"f0000417",

        -- addi, a0, x0, 0x2
        47 => x"00200513",

        -- li t0, -1
        48 => x"fff00293",

        -- sb t0, 508(zero)
        49 => x"1e500e23",

        -- sb t0; 509(zero)
        50 => x"1e500ea3",

        -- sb t0, 510(zero)
        51 => x"1e500f23",

        --sb t0, 511(zero)
        52 => x"1e500fa3",

        -- sh t0, 512(zero)
        53 => x"20501023",

        -- sh t0, 513(zero)
        54 => x"205010a3",

        -- sh t0, 514(zero)
        55 => x"20501123",

        -- sh t0, 515(zero)
        56 => x"205011a3",

        -- sw t0, 516(zero)
        57 => x"20502223",

        -- sw t0, 517(zero)
        58 => x"205022a3",

        -- sw t0, 518(zero)
        59 => x"20502323",

        -- sw t0, 519(zero)
        60 => x"205023a3",

        --lb s0, 504(zero)
        61 => x"1f800403",

        --lb s0, 505(zero)
        62 => x"1f900403",

        --lb s0, 506(zero)
        63 => x"1fa00403",

        --lb s0, 507(zero)
        64 => x"1fb00403",

        -- lbu s0, 504(zero)
        65 => x"1f804403",

        -- lbu s0, 505(zero)
        66 => x"1f904403",

        -- lbu s0, 506(zero)
        67 => x"1fa04403",

        -- lbu s0, 507(zero)
        68 => x"1fb04403",

        -- lh s0, 504(zero)
        69 => x"1f801403",

        -- lh s0, 505(zero)
        70 => x"1f901403",

        -- lh s0, 506(zero)
        71 => x"1fa01403",

        -- lh s0, 507(zero)
        72 => x"1fb01403",

        -- lhu s0, 504(zero)
        73 => x"1f805403",

        -- lhu s0, 505(zero)
        74 => x"1f905403",

        -- lhu s0, 506(zero)
        75 => x"1fa05403",

        -- lhu s0, 507(zero)
        76 => x"1fb05403",

        -- lw s0, 504(zero)
        77 => x"1f802403",

        -- lw s0, 505(zero)
        78 => x"1f902403",

        -- lw s0, 506(zero)
        79 => x"1fa02403",

        -- lw s0, 507(zero)
        80 => x"1fb02403",

        -- sb t0, 508(zero)
        81 => x"1e700e23",

        -- sb t0; 509(zero)
        82 => x"1e700ea3",

        -- lw a0, 508(zero)
        83 => x"1fc02503",



        -- jalr x0,x1,0
        -- jumps back to address that is held in x1(ra)
        111 => x"00008067",

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
