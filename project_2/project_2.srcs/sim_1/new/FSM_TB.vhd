----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2024 12:33:27
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

library ieee;
use ieee.std_logic_1164.all;

entity tb_FSM is
end tb_FSM;

architecture tb of tb_FSM is

    component FSM
        port (CLK              : in std_logic;
              DETECTOR         : in std_logic;
              PAGO_OK          : in std_logic;
              TIPO_VEHICULO    : in std_logic_vector (3 - 1 downto 0);
              SIGNAL_CHANGE    : in std_logic_vector (10 - 1 downto 0);
              BARRERA_UP       : in std_logic;
              BARRERA_DOWN     : in std_logic;
              RESET            : in std_logic;
              ERROR            : out std_logic;
              BARRERA_UP_LED   : out std_logic;
              BARRERA_DOWN_LED : out std_logic;
              ESTADO_ACTUAL    : out std_logic_vector (3 downto 0);
              LED              : out std_logic_vector (7 -1 downto 0));
    end component;

    signal CLK              : std_logic;
    signal DETECTOR         : std_logic;
    signal PAGO_OK          : std_logic;
    signal TIPO_VEHICULO    : std_logic_vector (3 - 1 downto 0);
    signal SIGNAL_CHANGE    : std_logic_vector (10 - 1 downto 0);
    signal BARRERA_UP       : std_logic;
    signal BARRERA_DOWN     : std_logic;
    signal RESET            : std_logic;
    signal ERROR            : std_logic;
    signal BARRERA_UP_LED   : std_logic;
    signal BARRERA_DOWN_LED : std_logic;
    signal ESTADO_ACTUAL    : std_logic_vector (3 downto 0);
    signal LED              : std_logic_vector (7 -1 downto 0);

    constant TbPeriod : time := 10 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : FSM
    port map (CLK              => CLK,
              DETECTOR         => DETECTOR,
              PAGO_OK          => PAGO_OK,
              TIPO_VEHICULO    => TIPO_VEHICULO,
              SIGNAL_CHANGE    => SIGNAL_CHANGE,
              BARRERA_UP       => BARRERA_UP,
              BARRERA_DOWN     => BARRERA_DOWN,
              RESET            => RESET,
              ERROR            => ERROR,
              BARRERA_UP_LED   => BARRERA_UP_LED,
              BARRERA_DOWN_LED => BARRERA_DOWN_LED,
              ESTADO_ACTUAL    => ESTADO_ACTUAL,
              LED              => LED
              );

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        DETECTOR <= '0';
        PAGO_OK <= '0';
        TIPO_VEHICULO <= (others => '0');
        SIGNAL_CHANGE <= (others => '0');
        BARRERA_UP <= '0';
        BARRERA_DOWN <= '0';

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal
        RESET <= '1';
        wait for 10 ns;
        RESET <= '0';
        wait for 10 ns;

        -- EDIT Add stimuli here
        wait for  TbPeriod;
        -- Paso 1: DETECTOR = '1' (vehículo detectado) --> Transición a S1
        DETECTOR <= '1';
        wait for 10 ns;

        -- Paso 2: TIPO_VEHICULO = "001" (tipo coche) --> Transición a S2
        TIPO_VEHICULO <= "001";
        wait for 10 ns;

        -- Paso 3: Pago correcto --> Transición a S3
        PAGO_OK <= '1';
        wait for 10 ns;
        PAGO_OK <= '0';
        SIGNAL_CHANGE <= "0000000000";
        wait for 10 ns;

        -- Paso 4: BARRERA_UP = '1' --> Transición a S4
        BARRERA_UP <= '1';
        wait for 10 ns;

        -- Paso 5: BARRERA_DOWN = '1' --> Transición a S5
        BARRERA_DOWN <= '1';
        wait for 10 ns;

        -- Paso 6: DETECTOR = '0' (vehículo sale) --> Transición a S0
        DETECTOR <= '0';
        wait for 10 ns;
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_FSM of tb_FSM is
    for tb
    end for;
end cfg_tb_FSM;