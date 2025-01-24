library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_TOP is
end TB_TOP;

architecture Behavioral of TB_TOP is

    -- Constantes genéricas para el diseño
    constant N_MONEDAS : positive := 3;
    constant N_VEHICULOS : positive := 3;
    constant N_ESTADOS : positive := 5;
    constant SIZE_CUENTA : positive := 10;
    constant DISPLAYS : positive := 8;
    constant SEGMENTOS : positive := 8;

    -- Señales para las entradas y salidas de la entidad TOP
    signal CLK : std_logic := '0';
    signal RESET : std_logic := '0';
    signal DETECTOR : std_logic := '0';
    signal DETECTOR_OUT : std_logic := '0';
    signal DETECTOR_SALIDA : std_logic := '0';
    signal MONEDAS : std_logic_vector(N_MONEDAS - 1 downto 0) := (others => '0');
    signal TIPO_VEHICULO : std_logic_vector(N_VEHICULOS - 1 downto 0) := (others => '0');

    signal BARRERA_UP_LED : std_logic;
    signal BARRERA_DOWN_LED : std_logic;
    signal CAMBIO_LED : std_logic;
    signal DISPLAYS_ON : std_logic_vector(DISPLAYS - 1 downto 0);
    signal SEGMENTOS_ON : std_logic_vector(SEGMENTOS - 1 downto 0);
    signal LED_ESTADO : std_logic_vector(N_ESTADOS - 1 downto 0);

    -- Período del reloj
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia de la entidad TOP
    UUT: entity work.TOP
        generic map (
            N_MONEDAS => N_MONEDAS,
            N_VEHICULOS => N_VEHICULOS,
            N_ESTADOS => N_ESTADOS,
            SIZE_CUENTA => SIZE_CUENTA,
            DISPLAYS => DISPLAYS,
            SEGMENTOS => SEGMENTOS
        )
        port map (
            CLK => CLK,
            RESET => RESET,
            DETECTOR => DETECTOR,
            DETECTOR_OUT => DETECTOR_OUT,
            DETECTOR_SALIDA => DETECTOR_SALIDA,
            MONEDAS => MONEDAS,
            TIPO_VEHICULO => TIPO_VEHICULO,
            BARRERA_UP_LED => BARRERA_UP_LED,
            BARRERA_DOWN_LED => BARRERA_DOWN_LED,
            CAMBIO_LED => CAMBIO_LED,
            DISPLAYS_ON => DISPLAYS_ON,
            SEGMENTOS_ON => SEGMENTOS_ON,
            LED_ESTADO => LED_ESTADO
        );

    -- Generación del reloj
    process
    begin
        CLK <= '0';
  wait for 0.5 * clk_period;

  CLK <= '1';
  wait for 0.5 * clk_period; 
    end process;

    -- Estímulos de prueba
    process
    begin
        -- Reset del sistema
        RESET <= '0';
        wait for 20 ns;
        RESET <= '1';

        -- Simulación de detección de vehículo
        DETECTOR <= '1';  -- Vehículo detectado
        wait for 30 ns;
        TIPO_VEHICULO <= "001";  -- Tipo 1 de vehículo
        wait for 30 ns;
        --DETECTOR <= '0';

        -- Inserción de monedas
        MONEDAS <= "001";  -- Moneda 1 ingresada
        wait for 20 ns;
        MONEDAS <= "010";  -- Moneda 2 ingresada
        wait for 20 ns;

        
        

      

        -- Finalización de la simulación
        wait for 100 ns;
        wait;
    end process;

end Behavioral;
