library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COUNTER is
    Generic(
        N_MONEDAS: POSITIVE :=3;
        N_VEHICULOS: POSITIVE :=3;
        SIZE_CUENTA: POSITIVE :=10      
    );
    Port(
        CLK: in std_logic;
        CE: in std_logic;
        RESET: in std_logic;
        MONEDAS: in std_logic_vector(N_MONEDAS - 1 downto 0);
        TIPO_VEHICULO: in std_logic_vector(N_VEHICULOS - 1 downto 0);
        ERROR: out std_logic;
        PAGO_OK: out std_logic;
        CUENTA: out std_logic_vector(SIZE_CUENTA - 1 downto 0);
        CHANGE: out std_logic_vector(SIZE_CUENTA - 1 downto 0)
    );
end COUNTER;

architecture Behavioral of COUNTER is

    -- Constantes para definir tarifas (en céntimos)
    constant TARIFA_MOTO : integer := 100; -- 1 euro
    constant TARIFA_COCHE : integer := 150; -- 1.5 euros
    constant TARIFA_CAMION : integer := 200; -- 2 euros

    -- Señales internas
    signal saldo_actual : integer := 0;
    signal tarifa : integer := 0;
    signal pago_completo : std_logic := '0';
    signal error_moneda : std_logic := '0';
    signal cuenta_registro : std_logic_vector(SIZE_CUENTA - 1 downto 0) := (others => '0');
    signal cambio : integer := 0;

begin
    --variable saldo_actual : integer := 0;

    -- Proceso principal para controlar el contador
    process(CLK, RESET)
    begin
        if RESET = '1' then
            saldo_actual <= 0;
            tarifa <= 1;
            pago_completo <= '0';
            error_moneda <= '0';
            cuenta_registro <= (others => '0');
            cambio <= 0;
        elsif rising_edge(CLK) then
            --if CE = '1' then
                pago_completo <= '0';
                --cuenta_registro <= (others => '0');
                -- Configuración de la tarifa según el tipo de vehículo
                if TIPO_VEHICULO = "001" then -- Moto
                    tarifa <= TARIFA_MOTO;
                elsif TIPO_VEHICULO = "010" then -- Coche
                    tarifa <= TARIFA_COCHE;
                elsif TIPO_VEHICULO = "011" then -- Camión
                    tarifa <= TARIFA_CAMION;
                else
                    tarifa <= 0; -- Tipo no válido
                end if;

                -- Verificar y agregar moneda al saldo
                case MONEDAS is
                     when "001" => -- Moneda de 50 céntimos
                        if saldo_actual < tarifa then
                            saldo_actual <= saldo_actual + 50;
                        end if;
                     when "010" => -- Moneda de 1 euro
                        if saldo_actual < tarifa then
                            saldo_actual <= saldo_actual + 100;
                        end if;
                     when "011" => -- Moneda de 2 euros
                         if saldo_actual < tarifa then
                            saldo_actual <= saldo_actual + 200;
                         end if;
                    when others => -- Moneda no válida
                        error_moneda <= '1';
                end case;

            -- Verificar si se alcanza la tarifa
            if saldo_actual >= tarifa then
                pago_completo <= '1';
                cambio <= saldo_actual - tarifa; -- Calcular el cambio
                saldo_actual <= 0; -- Reiniciar saldo después del pago
            else
                pago_completo <= '0';
                cambio <= 0;
            end if;


                -- Actualizar registro de cuenta para salida
                cuenta_registro <= std_logic_vector(to_unsigned(saldo_actual, SIZE_CUENTA));
            end if;
        --end if;
    end process;

    -- Asignación de salidas
    CUENTA <= cuenta_registro;
    ERROR <= error_moneda;
    PAGO_OK <= pago_completo;
    CHANGE <= std_logic_vector(to_unsigned(cambio, SIZE_CUENTA));
    
end Behavioral;