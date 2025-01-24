library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DIGITAL is
    Generic(
        N_MONEDAS : POSITIVE;
        N_VEHICULOS : POSITIVE;
        DISPLAYS: POSITIVE;
        SEGMENTOS: POSITIVE
    );
    port(
       CLK      : in std_logic;
       TIPO_VEHICULO    : in std_logic_vector (N_VEHICULOS - 1 downto 0);
       DINERO   : in integer;
       DISPLAYS_ON : out std_logic_vector(DISPLAYS - 1 downto 0);
       SEGMENTOS_ON : out std_logic_vector(SEGMENTOS - 1 downto 0)
    );
end DIGITAL;

architecture dataflow of DIGITAL is
    signal reloj_auxiliar : std_logic := '0';


    type seg_array is array(0 to 21) of std_logic_vector(SEGMENTOS - 1 downto 0);
    constant SEGMENT_TABLE : seg_array := (
        "10000001", -- 0
        "01001111", -- 1
        "00010010", -- 2
        "00000110", -- 3
        "01001100", -- 4
        "10100100", -- 5
        "00100000", -- 6
        "00001111", -- 7
        "00000000", -- 8
        "00000100", -- 9
        "00000001", -- 0 con punto decimal    10
        "00100100", -- 5  con punto decimal    11
        "10001000", --A                 12
        "10110001", --C         13
        "10001000", --R         14
        "10000000", --B         15
        "11000001", --U         16
        "10100100", -- S        17
        "11000111", -- J        18
        "10110000", -- E        19
        "10011000", -- P        20
        "11111111"  --Nada      21
    );

begin
-- Generador de reloj auxiliar
process(CLK)
    subtype ciclos is integer range 0 to 10**8;
    variable contaje : ciclos;
begin
    if rising_edge(CLK) then
        contaje := contaje + 1;
        if contaje = 10**5 - 1 then
            contaje := 0;
            reloj_auxiliar <= not reloj_auxiliar;
        end if;
    end if;
end process;

process(reloj_auxiliar) -- DETERMINAMOS QUE DISPLAY QUEREMOS ENCENDER EN CADA MOMENTO
        variable display : integer := 0;
        variable letra1,letra2,letra3,letra4,euros, cent_1, cent_2 : std_logic_vector(SEGMENTOS - 1 downto 0);
begin
    if rising_edge(reloj_auxiliar) then
        case to_integer(unsigned(TIPO_VEHICULO)) is
               when 1 =>
               letra1 := SEGMENT_TABLE(13);
               letra2:= SEGMENT_TABLE(12);
               letra3:= SEGMENT_TABLE(14);
               letra4:= SEGMENT_TABLE(21);
               when 2 =>
               letra1 := SEGMENT_TABLE(18);
               letra2:= SEGMENT_TABLE(19);
               letra3:= SEGMENT_TABLE(19);
               letra4:= SEGMENT_TABLE(20);
               when 4 =>
               letra1 := SEGMENT_TABLE(15);
               letra2:= SEGMENT_TABLE(16);
               letra3:= SEGMENT_TABLE(17);
               letra4:= SEGMENT_TABLE(21);
               when others =>
                    letra1 := SEGMENT_TABLE(21);
                    letra2:= SEGMENT_TABLE(21);
                    letra3:= SEGMENT_TABLE(21);
                    letra4:= SEGMENT_TABLE(21);
                    euros :=      "11111110"; ---
                    cent_1 := "11111110"; ---
                    cent_2 := "11111110"; ---
         end case;
               
               euros := SEGMENT_TABLE((DINERO / 100) mod 10);
               cent_1:= SEGMENT_TABLE((DINERO / 10) mod 10);
               cent_2:= SEGMENT_TABLE(DINERO mod 10);
               
        display := (display + 1) mod 8; -- modificamos el display que vamos a representar
            case display is
                when 0 =>
                    DISPLAYS_ON <= "01111111";                                     
                    SEGMENTOS_ON <= letra1;
                when 1 =>
                    DISPLAYS_ON <= "10111111";
                    SEGMENTOS_ON <= letra2;
                when 2 =>
                    DISPLAYS_ON <= "11011111";
                    SEGMENTOS_ON <= letra3;
                when 3 =>
                    DISPLAYS_ON <= "11101111";
                    SEGMENTOS_ON <= letra4;
                when 4 =>
                    DISPLAYS_ON <= "11110111";
                    SEGMENTOS_ON <= "11111111";
                when 5 =>
                    DISPLAYS_ON <= "11111011";
                    SEGMENTOS_ON <= euros;
                when 6 =>
                    DISPLAYS_ON <= "11111101";
                    SEGMENTOS_ON <= cent_1;
                when others =>
                    DISPLAYS_ON <= "11111110";
                    SEGMENTOS_ON <= cent_2;
                end case;
            end if;
       end process;
 end architecture dataflow;