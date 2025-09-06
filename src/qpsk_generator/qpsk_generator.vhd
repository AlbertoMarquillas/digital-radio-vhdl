----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2023 11:19:36 AM
-- Design Name: 
-- Module Name: qpsk_generator - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity qpsk_generator is
  Port (    clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            I : out std_logic_vector(7 downto 0);
            Q : out std_logic_vector(7 downto 0)
  );
end qpsk_generator;

architecture Behavioral of qpsk_generator is

    constant LFSR_REG_LENGTH : integer := 11;
    
    -- bit pseudoaleatori generat pel registre de fase
    signal random_bit0 : std_logic;
    -- bit pseudoaleatori generat pel registre de quadratura
    signal random_bit1 : std_logic;
    
    --...

begin

    -- LFSR que genera el bit 0 (senyal random_bit0) 
	-- modificar aquest procés per tal que implementi exactament el LFSR de la figura 5 de l'enunciat de la pràctica
    process(clk)
        -- inicialitzem el LSFR del senyal de fase per generar bits pseudoaleatoris
        variable rand_temp : std_logic_vector(LFSR_REG_LENGTH -1 downto 0) :=(0 => '1', others => '0');
        variable temp : std_logic := '0';
    begin
        if rising_edge(clk) then
            if reset = '1' then
                random_bit0 <= '0';
                rand_temp :=(0 => '1', others => '0');
                temp := '0';
            elsif enable = '1' then 
                temp := rand_temp(0) xor rand_temp(2);
                rand_temp(LFSR_REG_LENGTH -2 downto 0) := rand_temp(LFSR_REG_LENGTH -1 downto 1);
                rand_temp(LFSR_REG_LENGTH -1) := temp;
                random_bit0 <= rand_temp(0);
            end if;
        end if;
    end process;
    
    -- generar els símbols moduladors (I) i quadratura (Q)
    -- segons els valors dels bits pseuedoaleatoris random_bit0 i random_bit1 (veure la taula 1 de l'enunciat de la próctica)
    -- exemples de fer-ho: 
    --              - un process(clk) i una  instrucció "case"
    --              - instrucció "width", o "when"
    -- 
    
    -- LFSR que genera el bit 1 (senyal random_bit1) 
	process(clk)
        -- inicialitzem el LSFR del senyal de fase per generar bits pseudoaleatoris
        variable rand_temp : std_logic_vector(LFSR_REG_LENGTH -1 downto 0) :=(4 => '1', others => '0');
        variable temp : std_logic := '0';
    begin
        if rising_edge(clk) then
            if reset = '1' then
                random_bit1 <= '0';
                rand_temp :=(4 => '1', others => '0');
                temp := '0';
            elsif enable = '1' then 
                temp := rand_temp(0) xor rand_temp(2);
                rand_temp(LFSR_REG_LENGTH -2 downto 0) := rand_temp(LFSR_REG_LENGTH -1 downto 1);
                rand_temp(LFSR_REG_LENGTH -1) := temp;
                random_bit1 <= rand_temp(0);
            end if;
        end if;
    end process;
    
    -- generar I segun random_bit0 y random_bit1
    process(clk)
        variable bit_pair : std_logic_vector(1 downto 0);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                I <= (others => '0');
            elsif enable = '1' then 
                bit_pair := random_bit1 & random_bit0;
                case bit_pair is
                    when "00" =>
                        I <= "01111111";
                    when "01" =>
                        I <= "00000000";
                    when "10" =>
                        I <= "10000001";
                    when others =>
                        I <= "00000000";
                end case;
            end if;
        end if;
    end process;
    
    -- generar Q segun random_bit0 y random_bit1
    process(clk)
        variable bit_pair : std_logic_vector(1 downto 0);
    begin
        if rising_edge(clk) then
            if reset = '1' then
                Q <= (others => '0');
            elsif enable = '1' then 
                bit_pair := random_bit1 & random_bit0;
                case bit_pair is
                    when "00" =>
                        Q <= "00000000";
                    when "01" =>
                        Q <= "01111111";
                    when "10" =>
                        Q <= "00000000";
                    when others =>
                        Q <= "10000001";
                end case;
            end if;
        end if;
    end process;

end Behavioral;