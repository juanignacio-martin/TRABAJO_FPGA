
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSM_TB is
    -- No ports para el testbench
end FSM_TB;

architecture BEHAVIORAL of FSM_TB is

    -- Declaración del componente FSM
    component FSM is
        Generic(
            N_MONEDAS: POSITIVE;
            N_VEHICULOS: POSITIVE; 
            N_ESTADOS: POSITIVE;
            DISPLAYS: POSITIVE;
            SEGMENTOS: POSITIVE;
            SIZE_CUENTA: POSITIVE        
        );
        Port( 
            CLK : in STD_LOGIC;
            RESET : in STD_LOGIC;
            DETECTOR : in STD_LOGIC;
            DETECTOR_OUT: in STD_LOGIC;
            DETECTOR_SALIDA: in STD_LOGIC;
            PAGO_OK : in STD_LOGIC;
            BARRERA_UP_LED : out STD_LOGIC;
            BARRERA_DOWN_LED : out STD_LOGIC;
            CAMBIO_LED: out STD_LOGIC;
            TIPO_VEHICULO: in STD_LOGIC_VECTOR (N_VEHICULOS - 1 downto 0);
            CHANGE: in std_logic_vector(SIZE_CUENTA - 1 downto 0);
            LED_ESTADO : out STD_LOGIC_VECTOR(N_ESTADOS - 1 downto 0)
        );
    end component;

    -- Parámetros genéricos
    constant N_MONEDAS: POSITIVE := 3;
    constant N_VEHICULOS: POSITIVE := 3;
    constant N_ESTADOS: POSITIVE := 5;
    constant DISPLAYS: POSITIVE := 4;
    constant SEGMENTOS: POSITIVE := 7;
    constant SIZE_CUENTA: POSITIVE := 10;

    -- Señales internas para conectar al DUT
    signal CLK : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal DETECTOR : STD_LOGIC := '0';
    signal DETECTOR_OUT : STD_LOGIC := '0';
    signal DETECTOR_SALIDA : STD_LOGIC := '0';
    signal PAGO_OK : STD_LOGIC := '0';
    signal BARRERA_UP_LED : STD_LOGIC;
    signal BARRERA_DOWN_LED : STD_LOGIC;
    signal CAMBIO_LED : STD_LOGIC;
    signal TIPO_VEHICULO : STD_LOGIC_VECTOR(N_VEHICULOS - 1 downto 0) := (others => '0');
    signal CHANGE : STD_LOGIC_VECTOR(SIZE_CUENTA - 1 downto 0) := (others => '0');
    signal LED_ESTADO : STD_LOGIC_VECTOR(N_ESTADOS - 1 downto 0);

    -- Constante para el periodo del reloj
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia del DUT
    DUT: FSM
        generic map(
            N_MONEDAS => N_MONEDAS,
            N_VEHICULOS => N_VEHICULOS,
            N_ESTADOS => N_ESTADOS,
            DISPLAYS => DISPLAYS,
            SEGMENTOS => SEGMENTOS,
            SIZE_CUENTA => SIZE_CUENTA
        )
        port map(
            CLK => CLK,
            RESET => RESET,
            DETECTOR => DETECTOR,
            DETECTOR_OUT => DETECTOR_OUT,
            DETECTOR_SALIDA => DETECTOR_SALIDA,
            PAGO_OK => PAGO_OK,
            BARRERA_UP_LED => BARRERA_UP_LED,
            BARRERA_DOWN_LED => BARRERA_DOWN_LED,
            CAMBIO_LED => CAMBIO_LED,
            TIPO_VEHICULO => TIPO_VEHICULO,
            CHANGE => CHANGE,
            LED_ESTADO => LED_ESTADO
        );

    -- Generación del reloj
    clk_process: process
    begin
       CLK <= '0';
  wait for 0.5 * clk_period;

  CLK <= '1';
  wait for 0.5 * clk_period; 
    end process;

    -- Estímulos de entrada
    stimulus_process: process
    begin
        -- Inicialización
        RESET <= '0';
        DETECTOR <= '0';
        DETECTOR_OUT <= '0';
        DETECTOR_SALIDA <= '0';
        PAGO_OK <= '0';
        TIPO_VEHICULO <= (others => '0');
        CHANGE <= (others => '0');
        wait for 2 * CLK_PERIOD;

        -- Liberar RESET
        RESET <= '1';
        wait for 2 * CLK_PERIOD;

        -- S0 -> S1: Vehículo detectado
        DETECTOR <= '1';
        wait for 2 * CLK_PERIOD;

        -- S1 -> S2: Seleccionar tipo de vehículo
        TIPO_VEHICULO <= "001"; -- Ejemplo: Tipo 1
        wait for 2 * CLK_PERIOD;

        -- S2 -> S3: Pago realizado
        PAGO_OK <= '1';
        CHANGE <= "0000001010"; -- Cambio generado (ejemplo: 10)
        wait for 2 * CLK_PERIOD;
        
        -- S3 -> S4: Vehículo sale de la barrera
        DETECTOR_OUT <= '1';
        wait for 2 * CLK_PERIOD;

        -- S4 -> S0: Vehículo ha salido completamente
        DETECTOR_SALIDA <= '1';
        wait for 2 * CLK_PERIOD;

        -- Finalización
        assert false report "Simulación finalizada con éxito" severity failure;
    end process;
end behavioral;
