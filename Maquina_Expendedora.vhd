-- Entidad y arquitectura para la máquina expendedora
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity maquina_expendedora is
    Port (
        clk : in STD_LOGIC;            -- Reloj del sistema
        reset : in STD_LOGIC;          -- Señal de reset
        moneda_10c : in STD_LOGIC;     -- Moneda de 10 centavos
        moneda_20c : in STD_LOGIC;     -- Moneda de 20 centavos
        moneda_50c : in STD_LOGIC;     -- Moneda de 50 centavos
        moneda_1e : in STD_LOGIC;      -- Moneda de 1 euro
        producto : out STD_LOGIC;      -- Señal de producto dispensado
        error : out STD_LOGIC          -- Señal de error por exceso de dinero
    );
end maquina_expendedora;

architecture Behavioral of maquina_expendedora is
    type state_type is (IDLE, ACUMULAR, ENTREGAR, ERROR);
    signal current_state, next_state : state_type := IDLE;
    signal saldo : INTEGER := 0;

begin

    -- Proceso secuencial para cambio de estado
    state_process: process(clk, reset)
    begin
        if reset = '1' then
            current_state <= IDLE;
            saldo <= 0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- Proceso combinacional para lógica de estado
    logic_process: process(current_state, moneda_10c, moneda_20c, moneda_50c, moneda_1e, saldo)
    begin
        -- Valores por defecto
        next_state <= current_state;
        producto <= '0';
        error <= '0';

        case current_state is
            when IDLE =>
                saldo <= 0;
                if moneda_10c = '1' then
                    saldo <= saldo + 10;
                    next_state <= ACUMULAR;
                elsif moneda_20c = '1' then
                    saldo <= saldo + 20;
                    next_state <= ACUMULAR;
                elsif moneda_50c = '1' then
                    saldo <= saldo + 50;
                    next_state <= ACUMULAR;
                elsif moneda_1e = '1' then
                    saldo <= 100;
                    next_state <= ENTREGAR;
                end if;

            when ACUMULAR =>
                if moneda_10c = '1' then
                    saldo <= saldo + 10;
                elsif moneda_20c = '1' then
                    saldo <= saldo + 20;
                elsif moneda_50c = '1' then
                    saldo <= saldo + 50;
                elsif moneda_1e = '1' then
                    saldo <= saldo + 100;
                end if;

                if saldo = 100 then
                    next_state <= ENTREGAR;
                elsif saldo > 100 then
                    next_state <= ERROR;
                end if;

            when ENTREGAR =>
                producto <= '1';
                next_state <= IDLE;

            when ERROR =>
                error <= '1';
                next_state <= IDLE;

            when others =>
                next_state <= IDLE;
        end case;
    end process;

end Behavioral;
