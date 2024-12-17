----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2024 12:18:24
-- Design Name: 
-- Module Name: FSM_TB - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity tb_FSM is
end tb_FSM;

architecture tb of tb_FSM is
    -- Componente de la FSM
    component FSM
        Generic(
            N_VEHICULOS : POSITIVE := 3;
            N_ESTADOS   : POSITIVE := 7;
            N_DISPLAYS  : POSITIVE := 8;
            SIZE_CODE   : POSITIVE := 9
        );
        Port (
            CLK              : in STD_LOGIC;
            DETECTOR         : in STD_LOGIC;
            PAGO_OK          : in STD_LOGIC;
            TIPO_VEHICULO    : in STD_LOGIC_VECTOR (N_VEHICULOS - 1 downto 0);
            SIGNAL_CHANGE    : in STD_LOGIC;
            BARRERA_UP       : in STD_LOGIC;
            BARRERA_DOWN     : in STD_LOGIC;
            RESET            : in STD_LOGIC;
            ERROR            : out STD_LOGIC;
            BARRERA_UP_LED   : out STD_LOGIC;
            BARRERA_DOWN_LED : out STD_LOGIC;
            ESTADO_ACTUAL    : out STD_LOGIC_VECTOR(3 downto 0);
            LED   : out STD_LOGIC_VECTOR(6 downto 0)
            
        );
    end component;

    -- Señales internas
    signal CLK              : STD_LOGIC := '0';
    signal RESET            : STD_LOGIC;
    signal DETECTOR         : STD_LOGIC;
    signal PAGO_OK          : STD_LOGIC;
    signal TIPO_VEHICULO    : STD_LOGIC_VECTOR (2 downto 0);
    signal SIGNAL_CHANGE    : STD_LOGIC;
    signal BARRERA_UP       : STD_LOGIC;
    signal BARRERA_DOWN     : STD_LOGIC;
    signal ERROR            : STD_LOGIC;
    signal BARRERA_UP_LED   : STD_LOGIC;
    signal BARRERA_DOWN_LED : STD_LOGIC;
    signal ESTADO_ACTUAL    : STD_LOGIC_VECTOR (3 downto 0);
    signal LED   : STD_LOGIC_VECTOR(6 downto 0);

    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instancia del DUT (FSM)
    uut: FSM
        generic map (
            N_VEHICULOS => 3,
            N_ESTADOS   => 7,
            N_DISPLAYS  => 8,
            SIZE_CODE   => 9
        )
        port map (
            CLK              => CLK,
            RESET            => RESET,
            DETECTOR         => DETECTOR,
            PAGO_OK          => PAGO_OK,
            TIPO_VEHICULO    => TIPO_VEHICULO,
            SIGNAL_CHANGE    => SIGNAL_CHANGE,
            BARRERA_UP       => BARRERA_UP,
            BARRERA_DOWN     => BARRERA_DOWN,
            ERROR            => ERROR,
            BARRERA_UP_LED   => BARRERA_UP_LED,
            BARRERA_DOWN_LED => BARRERA_DOWN_LED,
            ESTADO_ACTUAL    => ESTADO_ACTUAL,
            LED => LED
        );

    -- Generación del reloj
    process
    begin
        while true loop
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Estímulos de prueba
    process
    begin
        -- Inicialización de señales
        RESET <= '0';
        DETECTOR <= '0';
        PAGO_OK <= '0';
        TIPO_VEHICULO <= "000";
        SIGNAL_CHANGE <= '0';
        BARRERA_UP <= '0';
        BARRERA_DOWN <= '0';
        wait for 20 ns;

        -- Salir del reset
        RESET <= '1';
        wait for 20 ns;

        -- Paso 1: DETECTOR = '1' (vehículo detectado) --> Transición a S1
        DETECTOR <= '1';
        wait for 20 ns;

        -- Paso 2: TIPO_VEHICULO = "001" (tipo coche) --> Transición a S2
        TIPO_VEHICULO <= "001";
        wait for 20 ns;

        -- Paso 3: Pago correcto --> Transición a S3
        PAGO_OK <= '1';
        wait for 10 ns;
        PAGO_OK <= '0';
        SIGNAL_CHANGE <= '0';
        wait for 20 ns;

        -- Paso 4: BARRERA_UP = '1' --> Transición a S4
        BARRERA_UP <= '1';
        wait for 20 ns;

        -- Paso 5: BARRERA_DOWN = '1' --> Transición a S5
        BARRERA_DOWN <= '1';
        wait for 20 ns;

        -- Paso 6: DETECTOR = '0' (vehículo sale) --> Transición a S0
        DETECTOR <= '0';
        wait for 20 ns;

        -- Fin de la simulación
        report "Simulation completed successfully!";
        wait;
    end process;

end tb;

