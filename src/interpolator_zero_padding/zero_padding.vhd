----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2023 11:19:54 AM
-- Design Name: 
-- Module Name: zero_padding - Behavioral
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

---- Uncomment the following library declaration if using
---- arithmetic functions with Signed or Unsigned values
----use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx leaf cells in this code.
----library UNISIM;
----use UNISIM.VComponents.all;

entity zero_padding is
	Port(
		I : in std_logic_vector(7 downto 0);
        	Q : in std_logic_vector(7 downto 0);
        	Insert_Zeros : in std_logic;
        	I_UPS : out std_logic_vector(7 downto 0);
        	Q_UPS : out std_logic_vector(7 downto 0)
	);
end zero_padding;

architecture Behavioral of zero_padding is

begin
	process(Insert_Zeros)
    	begin
        	if Insert_Zeros = '1' then
                I_UPS <= (others => '0');
                Q_UPS <= (others => '0');
        	else
                I_UPS <= I;
                Q_UPS <= Q;
        	end if;
    	end process;
    
end Behavioral;
