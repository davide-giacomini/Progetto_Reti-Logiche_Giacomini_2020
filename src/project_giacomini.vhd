----------------------------------------------------------------------------------
-- Student: Davide Giacomini
-- 
-- Create Date: 25.04.2020 20:27:32
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: Progetto di reti logiche

----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity project_reti_logiche is
    Port ( i_clk : in STD_LOGIC;
           i_start : in STD_LOGIC;
           i_rst : in STD_LOGIC;
           i_data : in STD_LOGIC_VECTOR(7 downto 0);
           o_address : out STD_LOGIC_VECTOR(15 downto 0);
           o_done : out STD_LOGIC;
           o_en : out STD_LOGIC;
           o_we : out STD_LOGIC;
           o_data : out STD_LOGIC_VECTOR(7 downto 0));
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

    type state_type is (START,
                        READ_ADDR_TO_ANALYZE,
                        ASK_READ_ADDR_WZ,
                        COMPUTE, 
                        WRITE, 
                        DONE, 
                        WAIT_DONE,
                        WAIT_END,
                        WAIT_READ_ADDR_TO_ANALYZE,
                        WAIT_COMPUTE
                        );
    
    signal next_state: state_type;
    signal address_to_analyze: STD_LOGIC_VECTOR(7 downto 0);
    signal address_converted: STD_LOGIC_VECTOR(7 downto 0);
    signal count_WZ : integer;
    
begin
    process (i_clk, i_rst)
        variable num_WZ : STD_LOGIC_VECTOR(2 downto 0);         -- number working-zone from zero to seven
    begin
        if (i_rst = '1') then
            next_state <= START;
            count_WZ <= 0;
            o_done <= '0';
            o_en <= '0';
            o_we <= '0';
            o_address <= (others => '0');
            o_data <= (others => '0');
            address_to_analyze <= (others => '0');
            address_converted <= (others => '0');
        elsif (rising_edge(i_clk)) then
            case next_state is
                when START =>
                    if (i_start = '1') then
                        next_state <= WAIT_READ_ADDR_TO_ANALYZE;                                 -- the next state will be that
                        o_en <= '1';                                                            -- enable reading from memory
                        o_address <= (3 => '1', others => '0');                                 -- ask to read from address 8
                    else
                        next_state <= START;                                                 -- remain in the start state
                    end if;
                when WAIT_READ_ADDR_TO_ANALYZE =>
                    next_state <= READ_ADDR_TO_ANALYZE;
                when READ_ADDR_TO_ANALYZE =>
                  -- i_data is the address in the eitgth's position of the memory (the address to analyze)
                    o_en <= '1';
                    address_to_analyze <= i_data;                                               -- save the address to analyze from the memory
                    next_state <= ASK_READ_ADDR_WZ;                                              -- the next state will read the address of the working zone
                when ASK_READ_ADDR_WZ => 
                  -- the count_WZ counts how many working-zone address has already been analyzed.
                  -- It is also the position in the memory where the next working-zone address is stored.
                    if (count_WZ < 8) then
                        next_state <= WAIT_COMPUTE;                                               -- the next state will save the address of this WZ
                        o_en <= '1';                                                            -- enable reading from memory
                        o_address <= std_logic_vector(to_unsigned(count_WZ, 16));               -- ask to read the address of the current working-zone
                    else
                        next_state <= WRITE;
                    end if;
                when WAIT_COMPUTE =>
                    next_state <= COMPUTE;
                when COMPUTE =>
                  -- i_data is the working-zone address
                    if (address_to_analyze < i_data) then
                        count_WZ <= count_WZ + 1;
                        address_converted <= address_to_analyze;
                        next_state <= ASK_READ_ADDR_WZ;
                    else
                        case (to_integer(unsigned(address_to_analyze)) - to_integer(unsigned(i_data))) is
                            when 0 =>
                                num_WZ := STD_LOGIC_VECTOR(to_unsigned(count_WZ, 3));
                                address_converted(7) <= '1';
                                address_converted(3 downto 0) <= "0001";
                                address_converted(6 downto 4) <= STD_LOGIC_VECTOR(to_unsigned(count_WZ, 3));
                                next_state <= WRITE;
                            when 1 =>
                                num_WZ := STD_LOGIC_VECTOR(to_unsigned(count_WZ, 3));
                                address_converted(7) <= '1';
                                address_converted(3 downto 0) <= "0010";
                                address_converted(6 downto 4) <= num_WZ;
                                next_state <= WRITE;
                            when 2 =>
                                num_WZ := STD_LOGIC_VECTOR(to_unsigned(count_WZ, 3));
                                address_converted(7) <= '1';
                                address_converted(3 downto 0) <= "0100";
                                address_converted(6 downto 4) <= num_WZ;
                                next_state <= WRITE;
                            when 3 =>
                                num_WZ := STD_LOGIC_VECTOR(to_unsigned(count_WZ, 3));
                                address_converted(7) <= '1';
                                address_converted(3 downto 0) <= "1000";
                                address_converted(6 downto 4) <= num_WZ;
                                next_state <= WRITE;
                            when others =>
                                count_WZ <= count_WZ + 1;
                                address_converted <= address_to_analyze;
                                next_state <= ASK_READ_ADDR_WZ;
                        end case;
                    end if;
                when WRITE =>
                    o_address <= (0 => '1', 3 => '1', others => '0');
                    o_en <= '1';
                    o_we <= '1';
                    o_data <= address_converted;
                    next_state <= WAIT_DONE;
                when WAIT_DONE =>
                    o_en <= '1';
                    o_we <= '1';
                    next_state <= DONE;
                when DONE =>
                    o_done <= '1';
                    o_en <= '0';
                    o_we <= '0';
                    next_state <= WAIT_END;
                when others =>  -- it's as to say WAIT_END
                    if (i_start = '1') then
                        next_state <= WAIT_END;
                    else
                        next_state <= START;
                        count_WZ <= 0;
                        o_done <= '0';
                        o_address <= (others => '0');
                        o_en <= '0';
                        o_data <= (others => '0');
                        address_to_analyze <= (others => '0');
                        address_converted <= (others => '0');
                    end if;
            end case;
        end if;
    end process;
end Behavioral;
