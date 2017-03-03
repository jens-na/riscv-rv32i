library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use std.textio.all;

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
    impure function InitRamFromFile (RamFileName : in string) return memory_t is
        FILE RamFile : text is in RamFileName;
        variable RamFileLine : line;
        variable tempIn : bit_vector(31 downto 0);
        variable RAM : memory_t;
    begin
        for I in 0 to (ram_size-1) loop
            readline (RamFile, RamFileLine);
            read (RamFileLine, tempIn);
            RAM(i) := to_stdlogicvector(tempIn);
        end loop;
        return RAM;
    end function;
	
    signal memory : memory_t := InitRamFromFile("/tmp/binary.bin");
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
