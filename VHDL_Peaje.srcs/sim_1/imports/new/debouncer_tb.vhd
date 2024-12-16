library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Debouncer is
end tb_Debouncer;

architecture tb of tb_Debouncer is

    component Debouncer
        Port (
            reloj        : in  STD_LOGIC;                     -- Señal de reloj
            reinicio     : in  STD_LOGIC;                     -- Señal de reinicio
            moneda       : in  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Vector moneda de 2 a 0
            tipo_entrada : in  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Vector tipo de 2 a 0
            salida       : out STD_LOGIC_VECTOR(2 DOWNTO 0)   -- Salida estabilizada
        );
    end component;

    -- Señales internas
    signal reloj        : STD_LOGIC := '0';
    signal reinicio     : STD_LOGIC;
    signal moneda       : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal tipo_entrada : STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal salida       : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -- Constante para el periodo de reloj
    constant TbPeriod : time := 10 ns;
    signal SimEnded : STD_LOGIC := '0';

begin

    -- Instanciación del DUT (Device Under Test)
    UUT : Debouncer
    port map (
        reloj        => reloj,
        reinicio     => reinicio,
        moneda       => moneda,
        tipo_entrada => tipo_entrada,
        salida       => salida
    );

    -- Generador de reloj
    clk_gen : process
    begin
        while SimEnded /= '1' loop
            reloj <= '0';
            wait for TbPeriod / 2;
            reloj <= '1';
            wait for TbPeriod / 2;
        end loop;
        wait;
    end process clk_gen;

    -- Proceso de estímulos
    stimuli : process
    begin
        -- Inicialización de las señales
        reinicio <= '1';
        moneda <= (others => '0');
        tipo_entrada <= (others => '0');
        wait for 20 ns;

        -- Desactivar reset
        reinicio <= '0';
        wait for 20 ns;

        -- Simulación de entradas
        moneda <= "001";
        wait for 50 ns;
        moneda <= "010";
        wait for 50 ns;
        moneda <= "011";
        wait for 50 ns;
        moneda <= "100";
        wait for 50 ns;
        moneda <= "111";
        wait for 50 ns;

        tipo_entrada <= "010";
        wait for 100 ns;

        -- Probar con nueva secuencia de datos
        moneda <= "101";
        wait for 200 ns;
        tipo_entrada <= "111";
        wait for 200 ns;

        -- Finalización de la simulación
        SimEnded <= '1';
        wait;
    end process stimuli;

end tb;

-- Configuración de simulación (opcional)
configuration cfg_tb_Debouncer of tb_Debouncer is
    for tb
    end for;
end cfg_tb_Debouncer;