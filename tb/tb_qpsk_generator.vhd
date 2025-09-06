----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2023 03:28:28 PM
-- Design Name: 
-- Module Name: tb_qpsk_generator - Behavioral
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

entity tb_qpsk_generator is
--  Port ( );
end tb_qpsk_generator;

architecture Behavioral of tb_qpsk_generator is

component qpsk_generator is
  Port (    clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            I : out std_logic_vector(7 downto 0);
            Q : out std_logic_vector(7 downto 0)
  );
end component;


            signal clk : std_logic;
            signal reset : std_logic;
            signal enable : std_logic;
            signal I : std_logic_vector(7 downto 0);
            signal Q : std_logic_vector(7 downto 0);
            
begin

-- generar rellotge : freqüència de rellotge de 100 MHz (període 10 ns)
clock_process: process
begin
    clk <= '1';
    wait for 5 ns;
    clk <= '0';
    wait for 5 ns;
end process;

-- genera un reset al principi durant un període de rellotge
reset_process: process
begin
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait;
end process;

-- genera un senyal enable a 500 kHz amb una durada d'un període de rellotge, per generar els símbols I/Q a aquesta freqüència
enable_process: process
begin
    enable <= '0';
    wait for 1990 ns;
    enable <= '1';
    wait for 10 ns;
end process;

 -- completar el test-bench
qpsk_generator_INST: qpsk_generator
  Port map(    clk => clk,
            reset => reset,
            enable => enable,
            I => I,
            Q => Q
  );

end Behavioral;