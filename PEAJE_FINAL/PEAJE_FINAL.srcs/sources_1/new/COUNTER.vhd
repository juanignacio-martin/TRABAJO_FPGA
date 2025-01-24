library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COUNTER is
    Generic(
        N_MONEDAS: POSITIVE:=3;           
        N_VEHICULOS: POSITIVE:= 3;
        SIZE_CUENTA: POSITIVE
        
    );
    Port(
        CLK: in std_logic;
        RESET: in std_logic;
        MONEDAS: in std_logic_vector(N_MONEDAS - 1 downto 0);
        TIPO_VEHICULO: in std_logic_vector(N_VEHICULOS - 1 downto 0);
        PAGO_OK: out std_logic;
        SALDO: out integer;
        CHANGE: out std_logic_vector(SIZE_CUENTA - 1 downto 0)
    );
end COUNTER;

architecture Behavioral of COUNTER is
    -- Constantes para definir tarifas (en céntimos)
    constant TARIFA_COCHE : integer := 100; -- 1 euro
    constant TARIFA_JEEP : integer := 150; -- 1.5 euros
    constant TARIFA_BUS : integer := 200; -- 2 euros

    -- Señales internas
    signal saldo_actual : integer := 0;
    signal tarifa : integer := 0;
    signal pago_completo : std_logic := '0';
    signal cambio : integer := 0;
    signal MONEDAS_ANTERIOR : std_logic_vector(N_MONEDAS - 1 downto 0) := (others => '0');

begin

    -- Proceso principal para controlar el contador
    process(CLK, RESET)
    begin
        if RESET = '0' then
            saldo_actual <= 0;
            tarifa <= 0;
            pago_completo <= '0';
            cambio <= 0;
            MONEDAS_ANTERIOR <= (others => '0');
        elsif rising_edge(CLK) then
            -- Actualización del saldo según las monedas (Detecta flanco de subida en MONEDAS)
            if MONEDAS /= MONEDAS_ANTERIOR then
                -- Si hay cambio en la señal de MONEDAS
                if MONEDAS = "001" then         -- Más 50 céntimos
                    saldo_actual <= saldo_actual + 50;
                elsif MONEDAS = "010" then      -- Más 1 euro
                    saldo_actual <= saldo_actual + 100;
                elsif MONEDAS = "100" then      -- Más 2 euros
                    saldo_actual <= saldo_actual + 200;
                end if;
            end if;

            -- Actualizar MONEDAS_ANTERIOR para la siguiente comparación
            MONEDAS_ANTERIOR <= MONEDAS;

            -- Determinación de la tarifa según el tipo de vehículo
            if TIPO_VEHICULO = "001" then -- Coche
                tarifa <= TARIFA_COCHE;
            elsif TIPO_VEHICULO = "010" then -- Jeep
                tarifa <= TARIFA_JEEP;
            elsif TIPO_VEHICULO = "100" then -- Bus
                tarifa <= TARIFA_BUS;
            else 
                tarifa <=0;
            end if;

            -- Verificación de pago
            if tarifa > 0 and saldo_actual >= tarifa then
                pago_completo <= '1';
                cambio <= saldo_actual - tarifa;
                saldo_actual <= 0; -- Reiniciar saldo tras el pago
            else
                pago_completo <= '0';
                cambio <= 0;
            end if;
        end if;
    end process;

    -- Asignación de salidas
    PAGO_OK <= pago_completo;
    CHANGE <= std_logic_vector(to_unsigned(cambio, SIZE_CUENTA));
    SALDO <= saldo_actual;
    

end Behavioral;

