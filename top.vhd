library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port (
        clk : in STD_LOGIC;                 -- Reloj de la FPGA
        reset_btn : in STD_LOGIC;           -- Botón de reset
        btn_10c : in STD_LOGIC;             -- Botón para moneda de 10 centavos
        btn_20c : in STD_LOGIC;             -- Botón para moneda de 20 centavos
        btn_50c : in STD_LOGIC;             -- Botón para moneda de 50 centavos
        btn_1e : in STD_LOGIC;              -- Botón para moneda de 1 euro
        led_producto : out STD_LOGIC;       -- LED que indica producto dispensado
        led_error : out STD_LOGIC           -- LED que indica error
    );
end top;

architecture Behavioral of top is

    -- Señales internas
    signal reset : STD_LOGIC;
    signal moneda_10c, moneda_20c, moneda_50c, moneda_1e : STD_LOGIC;
    signal producto, error : STD_LOGIC;

begin

    -- Instancia del diseño de la máquina expendedora
    expendedora_inst: entity work.maquina_expendedora
        port map (
            clk => clk,
            reset => reset,
            moneda_10c => moneda_10c,
            moneda_20c => moneda_20c,
            moneda_50c => moneda_50c,
            moneda_1e => moneda_1e,
            producto => producto,
            error => error
        );

    -- Mapear entradas externas a señales internas
    reset <= reset_btn;
    moneda_10c <= btn_10c;
    moneda_20c <= btn_20c;
    moneda_50c <= btn_50c;
    moneda_1e <= btn_1e;

    -- Mapear salidas internas a LEDs
    led_producto <= producto;
    led_error <= error;

end Behavioral;
