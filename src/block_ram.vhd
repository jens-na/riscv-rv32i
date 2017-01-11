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
    port ( clk : in std_logic;
           reset : in std_logic;
           data_in : in cpu_word;
           addr : in cpu_word;
           en_write : in boolean;
           data_out : out cpu_word
           );
       end block_ram;

architecture Behavioral of block_ram is
	type memory_t is array ((ram_size) - 1 downto 0) of std_logic_vector (address_bits - 1 downto 0);
	signal memory : memory_t := ( 
       -- 0 => "00000000001000001000000110110011", -- Register/Register test
       0 => "00000000011100001000000110010011", -- Register/Immediate test
       
       others => (others => '0')
    );
begin

	-- read
	process (clk)
	begin
		if rising_edge(clk) then
			
			if reset = '1' then
				-- clear data_out on reset
				data_out <= (others => '0');
			end if;
				
			if en_write = true then
				-- If en_write pass through data_in
				memory(to_integer(unsigned(addr))) <= data_in;
		    end if;
				
			-- read mem
			data_out <= memory(to_integer(unsigned(addr)));
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