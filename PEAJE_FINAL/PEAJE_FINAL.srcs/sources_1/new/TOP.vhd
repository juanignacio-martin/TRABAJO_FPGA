library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    Generic(
        N_MONEDAS: POSITIVE := 3;           --Hay 3 tipos de monedas 
        N_VEHICULOS: POSITIVE := 3;         --Hay 3 tipos de vehiculo
        N_ESTADOS: POSITIVE := 5;           --Numero de estados de la FSM
        SIZE_CUENTA: POSITIVE := 10;        
        DISPLAYS: POSITIVE := 8;        --Hay 8 displays en la placa
        SEGMENTOS: POSITIVE :=8         --Cada display tien 7 segmentos y el punto
       
    );
    
    Port(
        CLK : in STD_LOGIC;         --Reloj
        RESET : in STD_LOGIC;       --Reset
        DETECTOR : in STD_LOGIC;        --Detecta que llega un vehiculo
        DETECTOR_OUT: in STD_LOGIC;     
        DETECTOR_SALIDA:in STD_LOGIC;--cuando vale 0 vuelve al inicio
        MONEDAS : in STD_LOGIC_VECTOR (N_MONEDAS - 1 downto 0);     --Entrada para las monedas
        TIPO_VEHICULO : in STD_LOGIC_VECTOR (N_VEHICULOS - 1 downto 0); --Entrada de vehiculos
        
        BARRERA_UP_LED : out STD_LOGIC;             --LED que muestra barrera levantada
        BARRERA_DOWN_LED : out STD_LOGIC;           --LED que muestra barrera bajada
        CAMBIO_LED: out STD_LOGIC;
        DISPLAYS_ON : out std_logic_vector(DISPLAYS - 1 downto 0);
        SEGMENTOS_ON : out std_logic_vector(SEGMENTOS - 1 downto 0);
        LED_ESTADO: out STD_LOGIC_VECTOR (N_ESTADOS-1 downto 0)     --LEDS que representan estado de FSM
     );
     
end TOP;

architecture Behavioral of TOP is
 
 
 -------------------------------------SINCRONIZADOR-----------------------------------------------
component syn is
  generic (
    N_MONEDAS: POSITIVE;
    N_VEHICULOS: POSITIVE
  );
  port (
    clk   : in  std_logic;  
    async_coins_in : in std_logic_vector(N_MONEDAS - 1 downto 0);
    sync_coins_out : out std_logic_vector(N_MONEDAS - 1 downto 0);
    async_tipo_in : in std_logic_vector(N_VEHICULOS - 1 downto 0);
    sync_tipo_out : out std_logic_vector(N_VEHICULOS - 1 downto 0)
  );
end component;
signal monedasSync: std_logic_vector (N_MONEDAS - 1 downto 0);  --Signal de salida de monedas del sincronizador 
signal tipoSync: std_logic_vector (N_VEHICULOS - 1 downto 0);  --Signal de salida de tipo vehiculos del sincronizador 


-------------------------------------------EDGE-------------------------------------------------
component edge is
  generic(
    N_MONEDAS: POSITIVE;
    N_VEHICULOS: POSITIVE
  );
  port (
    clk   : in  std_logic;  
    sync_coins_in : in std_logic_vector(N_MONEDAS - 1 downto 0);
    edge_coins : out std_logic_vector(N_MONEDAS - 1 downto 0);
    sync_tipo_in : in std_logic_vector(N_VEHICULOS - 1 downto 0);
    edge_tipo : out std_logic_vector(N_VEHICULOS - 1 downto 0)
  );
end component;
signal monedasEdge: std_logic_vector (N_MONEDAS - 1 downto 0);  --Signal de salida de monedas del edge
signal tipoEdge: std_logic_vector (N_VEHICULOS - 1 downto 0);  --Signal de salida de tipo vehiculos del edge

------------------------------------------FSM----------------------------------------------------
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

--------------------------------------CONTADOR MONEDAS----------------------------------------

component COUNTER is
    Generic(
        N_MONEDAS: POSITIVE;
        N_VEHICULOS: POSITIVE;
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
end component;
signal paid : STD_LOGIC;  
signal cambio: std_logic_vector(SIZE_CUENTA - 1 downto 0);  
signal dinero_total: integer;
 
 ---------------------------------------CONTROL DISPLAYS------------------------------------------
 component DIGITAL is
    Generic(
        N_MONEDAS: POSITIVE;
        N_VEHICULOS: POSITIVE;
        DISPLAYS: POSITIVE;
        SEGMENTOS: POSITIVE 
        );
    Port(
       CLK      : in std_logic;
       TIPO_VEHICULO    : in std_logic_vector (N_VEHICULOS - 1 downto 0);
       DINERO   : in integer;
       DISPLAYS_ON : out std_logic_vector(DISPLAYS - 1 downto 0);
       SEGMENTOS_ON : out std_logic_vector(SEGMENTOS - 1 downto 0)
    );
  end component;
     
    
begin

---------------------------------INSTANCIANDO TODOS LOS COMPONENTES------------------------- 
 Inst_sync : syn
        generic map (
        N_MONEDAS => N_MONEDAS,
        N_VEHICULOS => N_VEHICULOS
        )
        port map(
            clk => CLK,
            async_coins_in => MONEDAS,
            sync_coins_out =>  monedasSync,
            async_tipo_in => TIPO_VEHICULO,
            sync_tipo_out => tipoSync
    );
 
Inst_edge : edge
        generic map (
        N_MONEDAS => N_MONEDAS,
        N_VEHICULOS => N_VEHICULOS
        )
        port map(
            clk => CLK,
            sync_coins_in => monedasSync,
            edge_coins => monedasEdge ,
            sync_tipo_in => tipoSync,
            edge_tipo => tipoEdge
    );
Inst_Dig: DIGITAL
generic map(
        N_MONEDAS => N_MONEDAS,
        N_VEHICULOS => N_VEHICULOS,
        DISPLAYS => DISPLAYS,
        SEGMENTOS => SEGMENTOS
        )
        port map(
        CLK =>CLK,
        TIPO_VEHICULO =>tipoSync,
        DINERO => dinero_total,
        DISPLAYS_ON => DISPLAYS_ON,
        SEGMENTOS_ON =>SEGMENTOS_ON 
        );
 
Inst_Cont: COUNTER
    generic map(
        N_MONEDAS => N_MONEDAS,
        N_VEHICULOS => N_VEHICULOS,
        SIZE_CUENTA => SIZE_CUENTA
    )
    port map(
        CLK => CLK,
        RESET => RESET,
        MONEDAS => monedasEdge,                  -- Entradas desde el edge detector para monedas
        TIPO_VEHICULO => tipoSync,               -- Entradas desde el edge detector para tipo de vehículo
        PAGO_OK => paid,                      -- Salida: indica si el pago es correcto
        SALDO => dinero_total,
        CHANGE => cambio                         -- Salida: cambio devuelto (ya está conectado en TOP)
    );


 
Inst_FSM: FSM
generic map(
        N_MONEDAS => N_MONEDAS,
        N_VEHICULOS => N_VEHICULOS,
        N_ESTADOS =>N_ESTADOS,
        DISPLAYS => DISPLAYS,
        SEGMENTOS => SEGMENTOS,
        SIZE_CUENTA => SIZE_CUENTA      
    )
    port map( 
        CLK => CLK,
        RESET => RESET,
        DETECTOR => DETECTOR,
        DETECTOR_OUT =>DETECTOR_OUT,
        DETECTOR_SALIDA =>DETECTOR_SALIDA,
        PAGO_OK => paid,
        BARRERA_UP_LED => BARRERA_UP_LED,
        BARRERA_DOWN_LED => BARRERA_DOWN_LED,
        CAMBIO_LED => CAMBIO_LED,
        TIPO_VEHICULO => tipoEdge,
        CHANGE => cambio,
        LED_ESTADO =>LED_ESTADO
    );
end Behavioral;





