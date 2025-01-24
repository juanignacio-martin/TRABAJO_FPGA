library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_EDGE is
    -- No ports en el testbench
end TB_EDGE;

architecture Behavioral of TB_EDGE is

    -- Declarar constantes para los genéricos
    constant N_MONEDAS : positive := 3;
    constant N_VEHICULOS : positive := 3;

    -- Declarar señales para las entradas y salidas del DUT
    signal clk : std_logic := '0';
    signal sync_coins_in : std_logic_vector(N_MONEDAS - 1 downto 0) := (others => '0');
    signal edge_coins : std_logic_vector(N_MONEDAS - 1 downto 0);
    signal sync_tipo_in : std_logic_vector(N_VEHICULOS - 1 downto 0) := (others => '0');
    signal edge_tipo : std_logic_vector(N_VEHICULOS - 1 downto 0);
constant CLK_PERIOD: time := 10 ns;
    -- Declarar el DUT
    component EDGE
        generic(
            N_MONEDAS: POSITIVE;
            N_VEHICULOS: POSITIVE
        );
        port(
            clk : in std_logic;
            sync_coins_in : in std_logic_vector(N_MONEDAS - 1 downto 0);
            edge_coins : out std_logic_vector(N_MONEDAS - 1 downto 0);
            sync_tipo_in : in std_logic_vector(N_VEHICULOS - 1 downto 0);
            edge_tipo : out std_logic_vector(N_VEHICULOS - 1 downto 0)
        );
    end component;

begin

    -- Instanciar el DUT
    DUT : EDGE
        generic map(
            N_MONEDAS => N_MONEDAS,
            N_VEHICULOS => N_VEHICULOS
        )
        port map(
            clk => clk,
            sync_coins_in => sync_coins_in,
            edge_coins => edge_coins,
            sync_tipo_in => sync_tipo_in,
            edge_tipo => edge_tipo
        );

    -- Generar reloj
    process
    begin
      CLK <= '0';
  wait for 0.5 * clk_period;

  CLK <= '1';
  wait for 0.5 * clk_period; 
    end process;

    -- Generar estímulos
    process
    begin
        -- Estímulo inicial
        wait for 20 ns; 
        sync_coins_in <= "001"; -- Cambio en monedas
        sync_tipo_in <= "010"; -- Cambio en tipo de vehículos

        wait for 20 ns;
        sync_coins_in <= "001"; -- Sin cambio en monedas
        sync_tipo_in <= "001"; -- Sin cambio en tipo de vehículos

        wait for 20 ns;
        sync_coins_in <= "100"; -- Cambio en monedas
        sync_tipo_in <= "100"; -- Cambio en tipo de vehículos

        wait for 20 ns;
        sync_coins_in <= "001"; -- Sin cambio en monedas
        sync_tipo_in <= "010"; -- Sin cambio en tipo de vehículos

        wait for 20 ns;
        sync_coins_in <= "000"; -- Cambio en monedas
        sync_tipo_in <= "000"; -- Cambio en tipo de vehículos

        wait for 20 ns;
        sync_coins_in <= (others => '0'); -- Reset
        sync_tipo_in <= (others => '0'); -- Reset

        wait for 40 ns;
        -- Final de la simulación
        wait;
    end process;
end Behavioral;