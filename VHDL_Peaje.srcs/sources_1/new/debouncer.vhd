
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Debouncer is
    Port (
        reloj       : in  STD_LOGIC;                     -- Señal de reloj
        reinicio    : in  STD_LOGIC;                     -- Señal de reinicio
        moneda      : in  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Vector moneda de 2 a 0
        tipo_entrada: in  STD_LOGIC_VECTOR(2 DOWNTO 0);  -- Vector tipo de 2 a 0
        salida      : out STD_LOGIC_VECTOR(2 DOWNTO 0)   -- Salida estabilizada
    );
end Debouncer;

architecture Behavioral of Debouncer is

    constant TIEMPO_ANTIRREBOTE : integer := 10000; -- Ajustar tiempo de antirrebote en ciclos de reloj
    signal contador             : integer range 0 to TIEMPO_ANTIRREBOTE := 0;
    signal estado_estable       : STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');

begin

    process(reloj, reinicio)
    begin
        if reinicio = '1' then
            contador <= 0;
            estado_estable <= (others => '0');
            salida <= (others => '0');
        elsif rising_edge(reloj) then
            if moneda /= estado_estable then
                -- Si el valor de entrada cambia, reiniciar el contador
                contador <= 0;
            else
                -- Incrementar el contador si el valor es estable
                if contador < TIEMPO_ANTIRREBOTE then
                    contador <= contador + 1;
                end if;
            end if;
            
            -- Actualizar estado estable si el contador llega al tiempo de antirrebote
            if contador = TIEMPO_ANTIRREBOTE then
                estado_estable <= moneda;
            end if;

            salida <= estado_estable;
        end if;
    end process;

end Behavioral;

