library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity SYNCH_TB is 
end;

architecture bench of SYNCH_TB is 

component SYNCH
    Generic(
    N_COINS : POSITIVE;
    N_TYPE: POSITIVE
    );
    port(
    CLK : in std_logic;              --Reloj
           ASYNC_SENSOR: in std_logic;            --Entrada presencia vehiculo
           ASYNC_COINS : in std_logic_vector (N_COINS - 1 downto 0);  --Entradas de monedas
           ASYNC_TYPE : in std_logic_vector (N_TYPE - 1 downto 0);      --Entradas de tipo de vehiculo
           SYNC_OUT_SENSOR : out std_logic;    --Salida sincronizada sensor
           SYNC_OUT_TYPE : out std_logic_vector(N_TYPE - 1 downto 0);   --Salida sincronizada tipo
           SYNC_OUT_COINS : out std_logic_vector (N_COINS - 1 downto 0)   --Salida sincronizada monedas
           );
      end component;
      
      --Declaracion de constantes
      constant N_COINS : POSITIVE := 3;
      constant N_TYPE : POSITIVE := 3;
      constant clock_period: time := 10ns;
      
--Declaracion de señales
      signal clk: std_logic;
      signal ASYNC_SENSORi: std_logic;          
      signal ASYNC_COINSi : std_logic_vector (N_COINS - 1 downto 0); 
      signal ASYNC_TYPEi : std_logic_vector (N_TYPE - 1 downto 0);     
      signal SYNC_OUT_SENSORi : std_logic;    
      signal SYNC_OUT_TYPEi : std_logic_vector(N_TYPE - 1 downto 0); 
      signal SYNC_OUT_COINSi : std_logic_vector (N_COINS - 1 downto 0);
      
 begin 
 
 uut: SYNCH generic map ( 
        N_TYPe => N_TYPE,
        N_COINs => N_COINS )
       port map (
        CLK                 => CLK,
        ASYNC_COINS => ASYNC_COINSi,
        ASYNC_SENSOR => ASYNC_SENSORi,
        ASYNC_TYPE => ASYNC_TYPEi,
        SYNC_OUT_COINS => SYNC_OUT_COINSi,
        SYNC_OUT_SENSOR => SYNC_OUT_SENSORi,
        SYNC_OUT_TYPE => SYNC_OUT_TYPEi);
   
CLK_T: process 
    begin 
    clk <='0';
    wait for 0.5*clock_period;
    
    clk <= '1';
    wait for 0.5*clock_period;
end proces;

prueba: process
    begin
    --Establecemos todos los valores a cero
    ASYNC_COINS <= "100";    --Moneda de 50 centimos 
    AA
    
    --Cambiamos los valores para observar un cambio y si lo realiza correctamente
 end;       