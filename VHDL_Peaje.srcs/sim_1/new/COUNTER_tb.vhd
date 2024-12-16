library ieee;
use ieee.std_logic_1164.all;

entity tb_COUNTER is
end tb_COUNTER;

architecture tb of tb_COUNTER is

    component COUNTER
        generic(
        n_monedas : positive := 3;
        n_vehiculos  : positive := 3;
        size_cuenta : positive := 10
        );
        port (CLK             : in std_logic;
              --CE              : in std_logic;
              RESET           : in std_logic;
              MONEDAS         : in std_logic_vector (n_monedas - 1 downto 0);
              TIPO_VEHICULO   : in std_logic_vector (n_vehiculos - 1 downto 0);
              ERROR           : out std_logic;
              PAGO_OK         : out std_logic;
              CUENTA          : out std_logic_vector (size_cuenta - 1 downto 0);
              VEHICULO_ACTUAL : out std_logic_vector (n_vehiculos - 1 downto 0);
              CHANGE          : out std_logic_vector (size_cuenta - 1 downto 0));
    end component;

    signal CLK             : std_logic;
    --signal CE              : std_logic;
    signal RESET           : std_logic;
    signal MONEDAS         : std_logic_vector (3 - 1 downto 0);
    signal TIPO_VEHICULO   : std_logic_vector (3 - 1 downto 0);
    signal ERROR           : std_logic;
    signal PAGO_OK         : std_logic;
    signal CUENTA          : std_logic_vector (10 - 1 downto 0);
    signal VEHICULO_ACTUAL : std_logic_vector (3 - 1 downto 0);
    signal CHANGE          : std_logic_vector (10 - 1 downto 0);

    constant TbPeriod : time := 1000 ns; -- EDIT Put right period here
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : COUNTER
    port map (CLK             => CLK,
              --CE              => CE,
              RESET           => RESET,
              MONEDAS         => MONEDAS,
              TIPO_VEHICULO   => TIPO_VEHICULO,
              ERROR           => ERROR,
              PAGO_OK         => PAGO_OK,
              CUENTA          => CUENTA,
              VEHICULO_ACTUAL => VEHICULO_ACTUAL,
              CHANGE          => CHANGE);

    -- Clock generation
    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    -- EDIT: Check that CLK is really your main clock signal
    CLK <= TbClock;

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        --CE <= '0';
        MONEDAS <= (others => '0');
        TIPO_VEHICULO <= (others => '0');

        -- Reset generation
        -- EDIT: Check that RESET is really your reset signal
        RESET <= '1';
        wait for 100 ns;
        RESET <= '0';
        wait for 100 ns;

        -- Insert coin for Moto (1 Euro)
        TIPO_VEHICULO <= "001"; -- Moto
        wait for TbPeriod;
        MONEDAS <= "001"; -- 1 Euro
        --CE <= '1';
        wait for TbPeriod;
        --CE <= '0';
        wait for TbPeriod;
        --ce <= '1';
         MONEDAS <= "010";

       
 

        -- Check payment completed for Moto
        wait for 200 * TbPeriod;

       
        -- Stop the clock and hence terminate the simulation
        TbSimEnded <= '1';
        wait;
    end process;

end tb;

-- Configuration block below is required by some simulators. Usually no need to edit.

configuration cfg_tb_COUNTER of tb_COUNTER is
    for tb
    end for;
end cfg_tb_COUNTER;
