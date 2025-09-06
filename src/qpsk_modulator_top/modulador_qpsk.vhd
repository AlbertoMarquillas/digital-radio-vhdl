----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/08/2023 11:19:09 AM
-- Design Name: 
-- Module Name: modulador_qpsk - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity modulador_qpsk is
  Port ( clk : in std_logic;
         reset : in std_logic;
         Data2ant : out std_logic_vector(15 downto 0)             
  );
end modulador_qpsk;

architecture Behavioral of modulador_qpsk is

component qpsk_generator 
  Port (    clk : in std_logic;
            reset : in std_logic;
            enable : in std_logic;
            I : out std_logic_vector(7 downto 0);
            Q : out std_logic_vector(7 downto 0)
  );
end component;

component zero_padding 
  Port ( 
    -- senyal d'entrada de fase
    I : in std_logic_vector(7 downto 0);
    -- senyal d'entrada de quadratura
    Q : in std_logic_vector(7 downto 0);
    -- senyal de sel.lecció entre els senyals d'entrada i zeros
    Insert_Zeros : in std_logic;
    -- senyal de sortida de fase
    I_UPS : out std_logic_vector(7 downto 0);
    -- senyal de sortida de quadratura
    Q_UPS : out std_logic_vector(7 downto 0)
  );
end component;

component lpf 
    port (
        clk : in std_logic;
        -- filtratge del senyal de fase
        I_UPS : in std_logic_vector(7 downto 0);
        I_FILT : out std_logic_vector(23 downto 0);
        -- filtratge del senyal de quadratura
        Q_UPS : in std_logic_vector(7 downto 0);
        Q_FILT : out std_logic_vector(23 downto 0)       
    );
end component;

component nco_wrapper
  port (
    Dout_cos : out STD_LOGIC_VECTOR ( 15 downto 0 );
    Dout_sin : out STD_LOGIC_VECTOR ( 15 downto 0 );
    aclk : in STD_LOGIC
  );
end component;

-- senyal per generar un pols a 500 kHz
signal enable : std_logic;

-- senyal per interpolar
signal Insert_Zeros : std_logic;

-- senyals per connectar el generador qpsk amb el zero padding
signal I : std_logic_vector(7 downto 0); 
signal Q : std_logic_vector(7 downto 0); 

-- senyals per connectar el zero padding amb el LPF
signal I_UPS : std_logic_vector(7 downto 0);
signal Q_UPS : std_logic_vector(7 downto 0);

-- senyals per multiplicar la sortida del LPF amb la sortida del NCO
signal I_FILT : std_logic_vector(23 downto 0); 
signal Q_FILT : std_logic_vector(23 downto 0); 
signal Dout_cos : STD_LOGIC_VECTOR ( 15 downto 0 );
signal Dout_sin : STD_LOGIC_VECTOR ( 15 downto 0 );
-- resultat de la multiplicació de la sortida del LPF amb la sortida del NCO
signal Data2ant_RE : signed(39 downto 0);
signal Data2ant_IM : signed(39 downto 0);
signal Data2ant_tmp : std_logic_vector(39 downto 0);

    
begin

-- generar un pols a 500 kHz (per generar símbols QPSK a 500k simbols/s).
process(clk)
variable counter : integer := 1;
begin
    if rising_edge(clk) then
        if reset = '1' then
            counter := 1;
            enable <= '0';
        else
            if counter < 200 then
                counter := counter + 1;
                enable <= '0';
            else
                counter := 1;
                enable <= '1';
            end if;
        end if;
    end if;
end process;

-- generar senyal per interpolar
Insert_Zeros <= not enable;
    
-- instanciar el qpsk 
qpsk_generator_inst : qpsk_generator 
  Port map( clk => clk,
            reset => reset,
            enable => enable,
            I => I, --DATA_BB_RE,
            Q => Q --DATA_BB_IM
  );

-- instanciar el zero padding 
zero_padding_inst : zero_padding 
  Port map( 
    -- senyal d'entrada de fase
    I => I,
    -- senyal d'entrada de quadratura
    Q => I,
    -- senyal de sel.lecció entre els senyals d'entrada i zeros
    Insert_Zeros => Insert_Zeros,
    -- senyal de sortida de fase
    I_UPS => I_UPS,
    -- senyal de sortida de quadratura
    Q_UPS => Q_UPS
  );

lpf_inst: lpf 
    port map(
        clk => clk,
        -- filtratge del senyal de fase
        I_UPS  => I_UPS,
        I_FILT  => I_FILT,
        -- filtratge del senyal de quadratura
        Q_UPS  => Q_UPS,
        Q_FILT  => Q_FILT    
    );
    
      


nco_wrapper_inst: nco_wrapper
  port map(
    Dout_cos => Dout_cos,
    Dout_sin => Dout_sin,
    aclk => clk
  );

-- multiplicar la sortida del LPF per la sortida del NCO
Data2ant_RE <= resize(signed(Dout_cos)*signed(I_FILT), Data2ant_RE'length);
Data2ant_IM <= resize(signed(Dout_sin)*signed(Q_FILT), Data2ant_IM'length);

Data2ant_tmp <= std_logic_vector(resize(Data2ant_RE + Data2ant_IM,Data2ant_tmp'length));

-- generar senyal de sortida Data2ant de 16 bits a partir de Data2ant_tmp. Sel.leccionar els bits adients per evitar overflow (saturació)
Data2ant <= Data2ant_tmp(39 downto 24);
    
end Behavioral;
