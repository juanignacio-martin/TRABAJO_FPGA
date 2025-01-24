library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYN_TB is
    -- No ports, es solo un testbench
end SYN_TB;

architecture BEHAVIORAL of SYN_TB is

    -- Declaración del componente SYN
    component SYN is
        GENERIC (
            N_MONEDAS: POSITIVE;
            N_VEHICULOS: POSITIVE
        );
        PORT ( 
            CLK : in std_logic;
            async_coins_in : in std_logic_vector(N_MONEDAS - 1 downto 0);
            sync_coins_out : out std_logic_vector(N_MONEDAS - 1 downto 0);
            async_tipo_in : in std_logic_vector(N_VEHICULOS - 1 downto 0);
            sync_tipo_out : out std_logic_vector(N_VEHICULOS - 1 downto 0)
        );
    end component;

    -- Parámetros genéricos
    constant N_MONEDAS: positive := 3;
    constant N_VEHICULOS: positive := 3;

    -- Señales internas para conectar al DUT
    signal CLK: std_logic := '0';
    signal async_coins_in: std_logic_vector(N_MONEDAS - 1 downto 0) := (others => '0');
    signal sync_coins_out: std_logic_vector(N_MONEDAS - 1 downto 0);
    signal async_tipo_in: std_logic_vector(N_VEHICULOS - 1 downto 0) := (others => '0');
    signal sync_tipo_out: std_logic_vector(N_VEHICULOS - 1 downto 0);

    -- Constante para el periodo del reloj
    constant CLK_PERIOD: time := 10 ns;

begin

    -- Instanciar el DUT (Device Under Test)
    DUT: SYN
        GENERIC MAP (
            N_MONEDAS => N_MONEDAS,
            N_VEHICULOS => N_VEHICULOS
        )
        PORT MAP (
            CLK => CLK,
            async_coins_in => async_coins_in,
            sync_coins_out => sync_coins_out,
            async_tipo_in => async_tipo_in,
            sync_tipo_out => sync_tipo_out
        );

    -- Generación del reloj
    clk_process: process
    begin
       CLK <= '0';
  wait for 0.5 * clk_period;

  CLK <= '1';
  wait for 0.5 * clk_period;
  
    end process;

    -- Estímulos para probar el módulo
    stimulus_process: process
    begin
        -- Inicializar las señales asincrónicas
        async_coins_in <= "000";
        async_tipo_in <= "000";
        wait for CLK_PERIOD;

        -- Aplicar valores a las señales asincrónicas
        async_coins_in <= "001";
        async_tipo_in <= "100";
        wait for 3 * CLK_PERIOD; -- Esperar 3 ciclos para observar la sincronización

        -- Cambiar los valores nuevamente
        async_coins_in <= "010";
        async_tipo_in <= "010";
        wait for 3 * CLK_PERIOD;

        -- Cambiar nuevamente
        async_coins_in <= "100";
        async_tipo_in <= "001";
        wait for 3 * CLK_PERIOD;

        -- Finalizar la simulación
        assert false report "Testbench finalizado con éxito" severity failure;
    end process;

end BEHAVIORAL;

