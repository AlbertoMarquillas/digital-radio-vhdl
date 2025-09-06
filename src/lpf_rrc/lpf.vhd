
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_textio.all;
use std.textio.all;

entity lpf is
    port (
        clk : in std_logic;
        -- filtratge del senyal de fase
        I_UPS : in std_logic_vector(7 downto 0);
        I_FILT : out std_logic_vector(23 downto 0);
        -- filtratge del senyal de quadratura
        Q_UPS : in std_logic_vector(7 downto 0);
        Q_FILT : out std_logic_vector(23 downto 0)       
    );
end entity lpf;

architecture Behavioral of lpf is

    constant NUM_COEF : integer := 2001; -- numero de coeficients del low pass filter

    type reg_type is array (0 to NUM_COEF - 1) of std_logic_vector(7 downto 0);
    -- shift register del filtre de la part real
    signal shift_reg_RE : reg_type := (others => (others => '0')); 
    -- shift register del filtre de la part imaginaria
    signal shift_reg_IM : reg_type := (others => (others => '0')); 
        
    type rom_type is array(0 to NUM_COEF - 1) of std_logic_vector(15 downto 0);
    constant FILENAME : string := "../../../../RaisedCosine.txt";
    
    impure function init_mem(mif_file_name : in string) return rom_type is
        file mif_file : text open read_mode is mif_file_name;
        variable mif_line : line;
        variable temp_bv : std_logic_vector(15 downto 0);
        variable temp_mem : rom_type := (others => (others => '0'));
        variable line_out : line;
        begin
        for i in rom_type'range loop
            readline(mif_file, mif_line);
            hread(mif_line, temp_bv);
            temp_mem(i):= temp_bv;
        end loop;
        return temp_mem;
    end function;
    
    signal rom_array : rom_type := init_mem(FILENAME);
            
begin


    -- proc�s que filtra el senyal de fase
    process (clk)
    variable coef_value : signed(15 downto 0);
    variable reg_value : signed(7 downto 0);
    variable result : std_logic_vector(23 downto 0); --era 23
    variable result_tmp : signed(23 downto 0); --era 23

    begin
        if rising_edge(clk) then
            result_tmp := (others => '0');
            for i in (NUM_COEF - 1) downto 1 loop
                -- acumular coeficient(i)*mostra(i)
                coef_value := signed(rom_array(i));
                reg_value := signed(shift_reg_RE(i));
                result_tmp := result_tmp + resize(coef_value*reg_value,result_tmp'length);
                -- desplaçar registre                
                shift_reg_RE(i) <= shift_reg_RE(i-1);
            end loop;
            
            -- acumular coeficient(0)*mostra(0)
            coef_value := signed(rom_array(0));
            reg_value := signed(shift_reg_RE(0));
            result_tmp := result_tmp + resize(coef_value*reg_value,result_tmp'length); 
            -- convertim el resultat a std_logic_vector       
            result := std_logic_vector(result_tmp);    
            I_FILT <= result;
            -- assignar 1a posició del registre
            shift_reg_RE(0) <= I_UPS;   
        end if;
    end process;
    
    -- procés que filtra el senyal de quadratura
    process (clk)
    variable coef_value : signed(15 downto 0);
    variable reg_value : signed(7 downto 0);
    variable result : std_logic_vector(23 downto 0); --era 23
    variable result_tmp : signed(23 downto 0); --era 23

    begin
        if rising_edge(clk) then
            result_tmp := (others => '0');
            for i in (NUM_COEF - 1) downto 1 loop
                -- acumular coeficient(i)*mostra(i)
                coef_value := signed(rom_array(i));
                reg_value := signed(shift_reg_RE(i));
                result_tmp := result_tmp + resize(coef_value*reg_value,result_tmp'length);
                -- desplaçar registre                
                shift_reg_IM(i) <= shift_reg_IM(i-1);
            end loop;
            
            -- acumular coeficient(0)*mostra(0)
            coef_value := signed(rom_array(0));
            reg_value := signed(shift_reg_IM(0));
            result_tmp := result_tmp + resize(coef_value*reg_value,result_tmp'length); 
            -- convertim el resultat a std_logic_vector       
            result := std_logic_vector(result_tmp);    
            Q_FILT <= result;
            -- assignar 1a posició del registre
            shift_reg_IM(0) <= I_UPS;   
        end if;
    end process;
    
end architecture Behavioral; 