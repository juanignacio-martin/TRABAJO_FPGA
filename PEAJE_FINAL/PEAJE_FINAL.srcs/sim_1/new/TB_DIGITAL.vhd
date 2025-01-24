library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DIGITAL_TB is
end DIGITAL_TB;

architecture behavioral of DIGITAL_TB is
    -- Declarar las señales para conectar al DUT (Device Under Test)
    signal CLK          : std_logic := '0';
    signal TIPO_VEHICULO: std_logic_vector(2 downto 0) := "000";
    signal DINERO       : integer := 0;
    signal DISPLAYS_ON  : std_logic_vector(7 downto 0):= (others => '0');
    signal SEGMENTOS_ON : std_logic_vector(7 downto 0):= (others => '0');

    -- Parámetros genéricos
    constant N_MONEDAS : positive := 3;
    constant N_VEHICULO : positive := 3;
    constant DISPLAYS : positive := 8;
    constant SEGMENTOS : positive := 8;

    -- Constantes para la simulación
    constant CLK_PERIOD : time := 10 ns; -- Periodo del reloj principal
begin
    -- Instancia del DUT
    DUT: entity work.DIGITAL
        generic map(
            N_MONEDAS => N_MONEDAS,
            N_VEHICULO => N_VEHICULO,
            DISPLAYS   => DISPLAYS,
            SEGMENTOS  => SEGMENTOS
        )
        port map(
            CLK          => CLK,
            TIPO_VEHICULO => TIPO_VEHICULO,
            DINERO       => DINERO,
            DISPLAYS_ON  => DISPLAYS_ON,
            SEGMENTOS_ON => SEGMENTOS_ON
        );

    -- Generador de reloj principal
    CLK_PROCESS: process
    begin
        CLK <= '0';
  wait for 0.5 * clk_period;

  CLK <= '1';
  wait for 0.5 * clk_period; 
    end process;

    -- Estímulos
    STIMULUS_PROCESS: process
    begin
        -- Caso 1: Vehículo tipo "CAR" (001), DINERO = 150
        TIPO_VEHICULO <= "001";
        DINERO <= 150;
        wait for 1 ms; -- Esperar suficiente tiempo para ver cambios en la simulación

        -- Caso 2: Vehículo tipo "JEEP" (010), DINERO = 350
        TIPO_VEHICULO <= "010";
        DINERO <= 350;
        wait for 1 ms;

        -- Caso 3: Vehículo tipo "BUS" (100), DINERO = 500
        TIPO_VEHICULO <= "100";
        DINERO <= 500;
        wait for 1 ms;

        -- Caso 4: Vehículo tipo no definido (111), DINERO = 0
        TIPO_VEHICULO <= "111";
        DINERO <= 0;
        wait for 1 ms;

        -- Finalizar simulación
        wait;
    end process;
end behavioral;
