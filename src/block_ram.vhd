----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/07/2016 02:49:09 PM
-- Design Name: 
-- Module Name: block_ram - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.utils.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
        en_write : in boolean;
        width : in std_logic_vector(2 downto 0);
        data_out : out cpu_word
    );
    end block_ram;

architecture Behavioral of block_ram is
	type memory_t is array ((ram_size) - 1 downto 0) of std_logic_vector (7 downto 0);
	signal memory : memory_t := ( 
       0 => "00000000001000001000000110110011",
       others => (others => '0')
    );
begin

	process (clk)
	begin
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
                        memory(to_integer(unsigned(addr + 1))) <= data_in(15 downto 8);

                    -- store word
                    when "010" =>
                        memory(to_integer(unsigned(addr))) <= data_in(7 downto 0);
                        memory(to_integer(unsigned(addr + 1))) <= data_in(15 downto 8);
                        memory(to_integer(unsigned(addr + 2))) <= data_in(23 downto 16);
                        memory(to_integer(unsigned(addr + 3))) <= data_in(31 downto 24);

                    -- do nothing
                    when others =>
                        null;

                end case;
		    end if;

            -- read mem
            case width is

                -- load sign extended byte
                when "000" =>
                    data_out <= SXT(memory(to_integer(unsigned(addr))), 32);

                -- load sign extended halfword
                when "001" =>
                    data_out(7 downto 0) <= memory(to_integer(unsigned(addr)));
                    data_out(31 downto 8) <= SXT(memory(to_integer(unsigned(addr + 1))), 24);

                -- load word
                when "010" =>
                    data_out(7 downto 0) <= memory(to_integer(unsigned(addr)));
                    data_out(15 downto 8) <= memory(to_integer(unsigned(addr + 1)));
                    data_out(23 downto 16) <= memory(to_integer(unsigned(addr + 2)));
                    data_out(31 downto 24) <= memory(to_integer(unsigned(addr + 3)));


                -- load zero extended byte
                when "100" =>
                    data_out <= EXT(memory(to_integer(unsigned(addr))), 32);

                -- load zero extended halfword
                when "101" =>
                    data_out(7 downto 0) <= memory(to_integer(unsigned(addr)));
                    data_out(31 downto 8) <= EXT(memory(to_integer(unsigned(addr + 1))), 24);

                when other =>
                    null;

            end case;
				


			-- read mem
		end if;
	end process;

--	-- Write process
--	process (clk)
--	begin
--		if rising_edge(clk) then
--			if reset = '1' then
--				-- Clear Memory on Reset
--				for i in memory'Range loop
--					Memory(i) <= (others => '0');
--				end loop;
--			elsif enable = '1' then
--				if en_write = '1' then
--					-- Store DataIn to Current Memory Address
--					memory(to_integer(unsigned(addr))) <= data_in;
--				end if;
--			end if;
--		end if;
--	end process;

end Behavioral;
