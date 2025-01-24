library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity FSM is
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
        CAMBIO_LED: out STD_LOGIC ;
        TIPO_VEHICULO: in STD_LOGIC_VECTOR (N_VEHICULOS - 1 downto 0);
        CHANGE: in std_logic_vector(SIZE_CUENTA - 1 downto 0);
        LED_ESTADO : out STD_LOGIC_VECTOR(N_ESTADOS -1 downto 0)
    );
end FSM;

architecture Behavioral of FSM is

type STATES is (S0,S1,S2,S3,S4);
signal CURRENT_STATE: STATES := S0;
signal NEXT_STATE: STATES;
signal enable : integer := 0; -- Sirve para saber en que estado me encuentro
begin 

---------------------------------------------REGISTRO DE ESTADOS-----------------------------------   
process(RESET,CLK)
    begin
            if RESET = '0' then
                CURRENT_STATE <= S0;
            elsif rising_edge(clk) then
                CURRENT_STATE <= NEXT_STATE;
                case CURRENT_STATE is
                    when S0 => enable <= 0;
                    when S1 => enable <= 1;
                    when S2 => enable <= 2;
                    when S3 => enable <= 3;
                    when S4 => enable <= 4;
                end case;
            end if;
    end process;
    
-----------------------------------------------CAMBIOS DE ESTADO---------------------------------
    nextstate: process(CLK,CURRENT_STATE) 
    begin
    NEXT_STATE <= CURRENT_STATE;        
        case CURRENT_STATE is 
            when S0 =>
                if DETECTOR = '1' then              --Hay un vehiculo
                    NEXT_STATE <= S1;
                end if;                
            when S1 =>
                if TIPO_VEHICULO /="000" then       --Se ha seleccionado un tipo de vehiculo
                    NEXT_STATE <= S2;
                end if;                
            when S2 =>
                if PAGO_OK = '1' then               --Se ha realizado el pago correctamente
                    NEXT_STATE <= S3;
                end if;
     
            when S3 =>
                
                if DETECTOR_OUT='1' then                    --Detecta que la barrera esta arriba
                    NEXT_STATE <= S4;
                end if;
           
            when s4 => 
                if DETECTOR_SALIDA='1' then          --Vehiculo se ha marchado
                    NEXT_STATE <= s0;
                end if;        
        end case;
end process;

-----------------------------------------------SALIDAS DE ESTADO---------------------------------    
    out_control: process(CURRENT_STATE)
    begin
        LED_ESTADO <= (others => '0');
        case CURRENT_STATE is 
            when S0 =>
                CAMBIO_LED <= '0';
                BARRERA_UP_LED <= '0';
          		BARRERA_DOWN_LED <= '0';
          		LED_ESTADO(0) <= '1'; -- Enciende LED0
                
            when S1 =>
                BARRERA_UP_LED <= '0';
          		BARRERA_DOWN_LED <= '0';
                LED_ESTADO(1) <= '1'; -- Enciende LED1
            when S2 =>
            if CHANGE /= "0000000000" then
                    CAMBIO_LED <= '1';
            end if;
                BARRERA_UP_LED <= '0';
          		BARRERA_DOWN_LED <= '0';
                LED_ESTADO(2) <= '1'; -- Enciende LED2
            when S3 =>
            
                BARRERA_UP_LED <= '1';
          		BARRERA_DOWN_LED <= '0';
                LED_ESTADO(3) <= '1'; -- Enciende LED3
         
          when S4 =>
                BARRERA_UP_LED <= '0';
          		BARRERA_DOWN_LED <= '1';
                LED_ESTADO(4) <= '1'; -- Enciende LED4
                CAMBIO_LED <= '0';
            
        end case;
    end process;

end Behavioral;