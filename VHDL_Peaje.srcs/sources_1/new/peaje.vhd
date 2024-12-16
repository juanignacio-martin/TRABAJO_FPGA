----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2024 16:45:42
-- Design Name: 
-- Module Name: PEAJE_PARKING - Behavioral
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

entity PEAJE_PARKING is
    Generic(
        N_MONEDAS: POSITIVE := 3;
        N_VEHICULOS: POSITIVE := 3;
        N_ESTADOS: POSITIVE := 7;
        --N_SEGMENTOS: POSITIVE := 7;
        --N_DISPLAYS: POSITIVE := 9; -- 8 Y EL PUNTO DECIMAL
        SIZE_CUENTA: POSITIVE := 10
        --SIZE_CODE: POSITIVE := 5; -- INCLUYE NUMEROS 0-9 Y ALGUNAS LETRAS   
        --PRESCALER_DIV: POSITIVE := 18   
    );
    
    Port(
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        PAGAR : in STD_LOGIC;
        DETECTOR : in STD_LOGIC;
        MONEDAS : in STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0);
        TIPO_VEHICULO : in STD_LOGIC_VECTOR (N_VEHICULOS - 1 downto 0);
        ERROR : out STD_LOGIC;
        BARRERA_UP_LED : out STD_LOGIC;
        BARRERA_DOWN_LED : out STD_LOGIC;
        ESTADOS: out STD_LOGIC_VECTOR (N_ESTADOS - 1 downto 0)
        --SEGMENTOS: out STD_LOGIC_VECTOR(N_SEGMENTOS - 1 downto 0);
        --DIGCTRL: out STD_LOGIC_VECTOR(N_DISPLAYS - 1 downto 0)
     );
     
end PEAJE_PARKING;

architecture Estructural of PEAJE_PARKING is

component COUNTER is
    Generic(
        N_MONEDAS: POSITIVE;
        N_VEHICULOS: POSITIVE;
        SIZE_CUENTA: POSITIVE      
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
end component;


component FSM is
    Generic(
        N_VEHICULOS: POSITIVE;
        N_ESTADOS: POSITIVE;
        SIZE_CUENTA: POSITIVE
        --N_DISPLAYS: POSITIVE;
        --SIZE_CODE: POSITIVE           
    );
    Port( 
        CLK : in STD_LOGIC;
        DETECTOR : in STD_LOGIC;
        --PAGAR : in STD_LOGIC;
        PAGO_OK : in STD_LOGIC;
        TIPO_VEHICULO: in STD_LOGIC_VECTOR (N_VEHICULOS - 1 downto 0);
        --ERROR_COUNTER : in STD_LOGIC;
        SIGNAL_CHANGE : in STD_LOGIC_VECTOR (SIZE_CUENTA - 1 downto 0);
        BARRERA_UP : in STD_LOGIC;
		BARRERA_DOWN : in STD_LOGIC;
        --CONTROL_IN : in STD_LOGIC_VECTOR (N_DISPLAYS * N_ESTADOS - 1 downto 0);
        --CODE_IN:in STD_LOGIC_VECTOR (SIZE_CODE * N_ESTADOS - 1 downto 0);
        RESET : in STD_LOGIC;
        ERROR : out STD_LOGIC;
        --REFRESCO_OUT : out STD_LOGIC;
        BARRERA_UP_LED : out STD_LOGIC;
        BARRERA_DOWN_LED : out STD_LOGIC;
        --ESTADOS_OUT : out STD_LOGIC_VECTOR(N_ESTADOS - 1 downto 0);
        --CONTROL_OUT : out STD_LOGIC_VECTOR (N_DISPLAYS - 1 downto 0);
        --CODE_OUT: out STD_LOGIC_VECTOR (SIZE_CODE - 1 downto 0)
        ESTADO_ACTUAL : out STD_LOGIC_VECTOR(3 downto 0)
    );
end component;

signal AUX1: std_logic_vector (SIZE_CUENTA - 1 downto 0); --Conecta CAMBIO de FSM con el COUNTER
signal AUX2: std_logic_vector (N_MONEDAS - 1 downto 0); --Conecta MONEDAS[] de EDGE_DET con el COUNTER
signal AUX3: std_logic; --Conecta PAGO_OK del COUNTER con la FSM
signal AUX4: std_logic; --Conec0ta ERROR del COUNTER con la FSM
signal AUX5: std_logic; --Conecta PAGAR del SYNC con el COUNTER y la FSM
signal AUX6: std_logic_vector (N_VEHICULOS - 1 downto 0); --Conecta TIPO_TEFRSCO del SYNC con el COUNTER
signal AUX7: std_logic_vector (SIZE_CUENTA - 1 downto 0); --Conecta CUENTA del counter con CUENTA del DISPLAY_CONTROL
signal AUX12: std_logic_vector (N_VEHICULOS - 1 downto 0); --Conecta REFRESCO_ACTUAL del counter con DISPLAY_CTRL Y LA FSM

signal AUX100: std_logic;
signal AUX101: std_logic;

begin

    CTR: COUNTER 
GENERIC MAP(
    N_MONEDAS => N_MONEDAS,
    SIZE_CUENTA => SIZE_CUENTA,
    N_VEHICULOS => N_VEHICULOS
    )
PORT MAP(
    CLK => CLK,
    CE => AUX5,
    RESET => RESET,
    TIPO_VEHICULO => AUX6,
    MONEDAS => AUX2,
    PAGO_OK => AUX3,
    --PRECIOS => AUX10,
    ERROR => AUX4,
    CUENTA => AUX7,
    CHANGE => AUX1
    );

    MAQ_ESTADOS: FSM
GENERIC MAP(
    N_VEHICULOS => N_VEHICULOS,
    N_ESTADOS => N_ESTADOS,
    SIZE_CUENTA => SIZE_CUENTA
    --N_DISPLAYS => N_DISPLAYS,
    --SIZE_CODE => SIZE_CODE
    )
PORT MAP(
    CLK => CLK,
    DETECTOR => DETECTOR,
    --PAGAR => AUX5, 
    PAGO_OK => AUX3,
    TIPO_VEHICULO => AUX12,
    SIGNAL_CHANGE => AUX1,
    BARRERA_UP => AUX100,
    BARRERA_DOWN => AUX101,
    --ERROR_COUNTER => AUX4,
    --CODE_IN => AUX8,
    --CONTROL_IN => AUX9,
    RESET => RESET,
    ERROR => ERROR,
    BARRERA_UP_LED => BARRERA_UP_LED,
    BARRERA_DOWN_LED => BARRERA_DOWN_LED
    --ESTADOS_OUT => ESTADOS,
    --CONTROL_OUT => DIGCTRL,
    --CODE_OUT => AUX11
);
   
end Estructural;
