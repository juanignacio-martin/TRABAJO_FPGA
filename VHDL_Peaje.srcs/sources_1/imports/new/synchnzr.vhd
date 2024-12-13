----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.11.2024 15:34:16
-- Design Name: 
-- Module Name: SYNCHRNZR - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SYNCH is
    Generic(
        N_COIN: POSITIVE;
        N_TIPE: POSITIVE
     );

    Port( 
           CLK : in std_logic;              --Reloj
           ASYNC_SENSOR: in std_logic;            --Entrada presencia vehiculo
           ASYNC_COINS : in std_logic_vector (N_COIN - 1 downto 0);  --Entradas de monedas
           ASYNC_TIPE : in std_logic_vector (N_TIPE - 1 downto 0);      --Entradas de tipo de vehiculo
           SYNC_OUT_SENSOR : out std_logic;    --Salida sincronizada sensor
           SYNC_OUT_TIPE : out std_logic_vector(N_TIPE - 1 downto 0);   --Salida sincronizada tipo
           SYNC_OUT_COINS : out std_logic_vector (N_COIN - 1 downto 0)   --Salida sincronizada monedas
           );
end SYNCH;

architecture BEHAVIORAL of SYNCH is
--Si usas dos registros sincronizadores, el primer registro puede capturar el cambio, pero si el valor está metaestable, el segundo registro tendrá una oportunidad para capturar el valor correctamente, evitando errores.
 signal sreg1_coins : std_logic_vector(N_COIN - 1 downto 0);
 signal sreg1_tipe : std_logic_vector(N_COIN - 1 downto 0);
 signal sreg1_sensor : std_logic;
 signal sreg2_coins : std_logic_vector(N_COIN - 1 downto 0);
 signal sreg2_tipe : std_logic_vector(N_TIPE - 1 downto 0);
 signal sreg2_sensor : std_logic;

begin

--Entrada se asigna a señal 
 reg1: process (CLK)
 begin
    if rising_edge(CLK) then
        sreg1_sensor <= ASYNC_SENSOR;
        sreg1_coins <= ASYNC_COINS;
        sreg1_tipe <= ASYNC_TIPE;
    end if;
 end process;
 
 --Señal se asigna a una segunda señal para evitar la metaestabilidad
 reg2: process
  begin
    if rising_edge(CLK) then
        sreg2_sensor <= sreg1_sensor;
        sreg2_coins <= sreg1_coins;
        sreg2_tipe <= sreg1_tipe;
    end if;
 end process;
 
--Asignacion señal sincronizada con salida
SYNC_OUT_SENSOR <= sreg2_sensor;
SYNC_OUT_COINS <= sreg2_coins;
SYNC_OUT_TIPE <= sreg2_tipe;

end BEHAVIORAL;


