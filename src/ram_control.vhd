library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.utils.all;
use work.opcodes.all;

entity ram_control is
    Port ( 
        clk : in std_logic;
        width : in std_logic_vector(2 downto 0);
        addr_in : in cpu_word;
        en_write : in boolean; 
        data_in_reg : in cpu_word;
        data_in_ram : in cpu_word;
        en_write_out : out boolean;
        data_out_reg : out cpu_word;
        data_out_ram : out cpu_word;
        addr_out : out std_logic_vector((ceillog2(RAM_SZ)-1) downto 0)
    );
end ram_control;

architecture Behavioral of ram_control is

signal byte_idx : std_logic_vector(1 downto 0);
signal enable: std_logic := '1';
signal enable_next: std_logic;

begin

    -- prevent access to memory out of bound
    addr_out <= std_logic_vector(to_unsigned(to_integer(unsigned(addr_in)) / 4, addr_out'length))
                when ((to_integer(unsigned(addr_in))) < RAM_SZ * 4) 
                        and ((to_integer(unsigned(addr_in))) >= 0 ) 
                else
                    (others => '0');

    byte_idx <= addr_in(1 downto 0);

    --write control process
    process(en_write, enable)
    begin
        
        --if rising_edge(clk) then
            if en_write = true and enable = '1' then
                en_write_out <= true;
            else
                en_write_out <= false;
            end if;
        --end if;
    end process;

	process(clk)
	begin
        if (rising_edge(clk)) then
            enable <= enable_next;
        end if;
	end process;

    enable_next <= not enable;

    -- write process
    process(data_in_reg, data_in_ram, width, byte_idx)
    begin
            -- standard assignment
            data_out_ram <= data_in_ram;

            case width is

                -- store byte
                when "000" =>

                    case byte_idx is
                        
                        when "00" =>

                            data_out_ram(7 downto 0) <= data_in_reg(7 downto 0);
                            data_out_ram(31 downto 8) <= data_in_ram(31 downto 8);

                        when "01" =>

                            data_out_ram(7 downto 0) <= data_in_ram(7 downto 0);
                            data_out_ram(15 downto 8) <= data_in_reg(7 downto 0);
                            data_out_ram(31 downto 16) <= data_in_ram(31 downto 16);

                        when "10" =>

                            data_out_ram(15 downto 0) <= data_in_ram(15 downto 0);
                            data_out_ram(23 downto 16) <= data_in_reg(7 downto 0);
                            data_out_ram(31 downto 24) <= data_in_ram(31 downto 24);

                        when "11" =>

                            data_out_ram(23 downto 0) <= data_in_ram(23 downto 0);
                            data_out_ram(31 downto 24) <= data_in_reg(7 downto 0);

                        when others =>
                            data_out_ram <= (others => '0');

                    end case;

                -- store halfword
                when "001" =>

                    case byte_idx is

                        when "00" =>

                            data_out_ram(15 downto 0) <= data_in_reg(15 downto 0);
                            data_out_ram(31 downto 16) <= data_in_ram(31 downto 16);

                        when "10" =>

                            data_out_ram(15 downto 0) <= data_in_ram(15 downto 0);
                            data_out_ram(31 downto 16) <= data_in_reg(15 downto 0);

                        when others =>
                            null;

                    end case;

                -- store word
                when "010" =>
                    
                    case byte_idx is

                        when "00" =>

                            data_out_ram <= data_in_reg;

                        when others =>
                            null;

                    end case;

                when others =>
                    null;

            end case;

    end process;

    -- read process
    process(width, data_in_ram, byte_idx)
    begin

            case width is

                -- load sign extended byte
                when "000" =>

                    case byte_idx is

                        when "00" =>

                            data_out_reg <= cpu_word(resize(signed(data_in_ram(7 downto 0)), 32));

                        when "01" =>

                            data_out_reg <= cpu_word(resize(signed(data_in_ram(15 downto 8)), 32));

                        when "10" =>

                            data_out_reg <= cpu_word(resize(signed(data_in_ram(23 downto 16)), 32));

                        when "11" =>

                            data_out_reg <= cpu_word(resize(signed(data_in_ram(31 downto 24)), 32));

                        when others =>

                            data_out_reg <= (others => '0');

                    end case;

                -- load sign extended halfword
                when "001" =>

                    case byte_idx is

                        when "00" =>

                            data_out_reg <= cpu_word(resize(signed(data_in_ram(15 downto 0)), 32));

                        when "10" =>

                            data_out_reg <= cpu_word(resize(signed(data_in_ram(31 downto 16)), 32));

                        when others =>

                            data_out_reg <= (others => '0');

                    end case;

                -- load word
                when "010" =>

                    case byte_idx is

                        when "00" =>

                            data_out_reg <= data_in_ram;

                        when others =>

                            data_out_reg <= (others => '0');

                    end case;

                -- load zero extended byte
                when "100" =>

                    case byte_idx is

                        when "00" =>

                            data_out_reg(7 downto 0) <= data_in_ram(7 downto 0);
                            data_out_reg(31 downto 8) <= (others => '0');

                        when "01" =>

                            data_out_reg(7 downto 0) <= data_in_ram(15 downto 8);
                            data_out_reg(31 downto 8) <= (others => '0');

                        when "10" =>

                            data_out_reg(7 downto 0) <= data_in_ram(23 downto 16);
                            data_out_reg(31 downto 8) <= (others => '0');

                        when "11" =>

                            data_out_reg(7 downto 0) <= data_in_ram(31 downto 24);
                            data_out_reg(31 downto 8) <= (others => '0');

                        when others =>

                            data_out_reg <= (others => '0');

                    end case;

                -- load zero extended halfword
                when "101" =>

                    case byte_idx is 

                        when "00" =>

                            data_out_reg(15 downto 0) <= data_in_ram(15 downto 0);
                            data_out_reg(31 downto 16) <= (others => '0');

                        when "10" =>

                            data_out_reg(15 downto 0) <= data_in_ram(31 downto 16);
                            data_out_reg(31 downto 16) <= (others => '0');

                        when others =>

                            data_out_reg <= (others => '0');

                    end case;

                when others =>

                    data_out_reg <= (others => '0');

            end case;

    end process;

end Behavioral;
