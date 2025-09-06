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

entity tb_nco is
--  Port ( );
end tb_nco;

architecture Behavioral of tb_nco is

component nco_wrapper is
    Port ( 
        Dout_cos : out STD_LOGIC_VECTOR ( 15 downto 0 );
        Dout_sin : out STD_LOGIC_VECTOR ( 15 downto 0 );
        aclk : in STD_LOGIC
        );
end component;

signal Dout_cos : STD_LOGIC_VECTOR (15 downto 0);
signal Dout_sin : STD_LOGIC_VECTOR (15 downto 0);
signal clk : STD_LOGIC;

begin

nco_inst : nco_wrapper

port map (Dout_cos => Dout_cos, Dout_sin => Dout_sin, aclk => clk);

-- generar rellotge : freqüència de rellotge de 100 MHz (període 10 ns)
time_process: process
begin
    clk <= '0';
    wait for 5 ns;
    clk <= '1';
    wait for 5 ns;
end process;

 
write_file: process (clk) is 
    -- fitxer de sortida
    file my_output : TEXT open WRITE_MODE is "file_NCO.txt"; 
     variable my_output_line : LINE; 
    begin 
        if clk = '1' then 
            write(my_output_line, to_integer(signed(Dout_sin))); 
            writeline(my_output, my_output_line); 
        end if; 
    end process;
    
    

end Behavioral;