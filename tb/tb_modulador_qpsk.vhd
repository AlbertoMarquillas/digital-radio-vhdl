----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2023 05:47:18 PM
-- Design Name: 
-- Module Name: tb_modulador_qpsk - Behavioral
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
use IEEE.STD_LOGIC_TEXTIO.ALL; 
use STD.TEXTIO.ALL; 
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_modulador_qpsk is
--  Port ( );
end tb_modulador_qpsk;

architecture Behavioral of tb_modulador_qpsk is

component modulador_qpsk 
  Port ( clk : in std_logic;
         reset : in std_logic;
         Data2ant : out std_logic_vector(15 downto 0)          
  );
end component;

signal clk : std_logic;
signal reset : std_logic;
signal Data2ant : std_logic_vector(15 downto 0);

begin


modulador_qpsk_inst : modulador_qpsk 
  Port map( clk => clk,
         reset => reset,
         Data2ant => Data2ant
  );


-- generar rellotge de 100 MHz (d'acord amb l'enunciat de la pràctica)
process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;

-- generar reset durant un període de rellotge
process
begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait; 
end process;

write_file: process (clk) is 
    -- afegir el nom del directori on es volem el fitxer
    file my_output : TEXT open WRITE_MODE is "file_Data2ant.txt"; 
     variable my_output_line : LINE; 
    begin 
        if clk = '1' then 
            write(my_output_line, to_integer(signed(Data2ant))); 
            writeline(my_output, my_output_line); 
        end if; 
    end process;



end Behavioral;
