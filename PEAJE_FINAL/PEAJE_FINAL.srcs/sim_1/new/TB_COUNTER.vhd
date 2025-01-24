library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity COUNTER_TB is
-- Empty entity for the testbench
end COUNTER_TB;

architecture Behavioral of COUNTER_TB is

    -- Component declaration for the DUT (Device Under Test)
    component COUNTER
        Generic(
            N_MONEDAS: POSITIVE := 3;
            N_VEHICULOS: POSITIVE := 3;
            SIZE_CUENTA: POSITIVE:=10
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

    -- Testbench signals
    signal CLK: std_logic := '0';
    signal RESET: std_logic := '0';
    signal MONEDAS: std_logic_vector(2 downto 0) := (others => '0');
    signal TIPO_VEHICULO: std_logic_vector(2 downto 0) := (others => '0');
    signal PAGO_OK: std_logic;
    signal SALDO: integer;
    signal CHANGE: std_logic_vector(9 downto 0) := (others => '0');

    -- Clock generation process
    constant CLK_PERIOD: time := 10 ns;
    
    begin
        
    -- Instantiate the DUT
    DUT: COUNTER
        Generic map(
            N_MONEDAS => 3,
            N_VEHICULOS => 3
        )
        Port map(
            CLK => CLK,
            RESET => RESET,
            MONEDAS => MONEDAS,
            TIPO_VEHICULO => TIPO_VEHICULO,
            PAGO_OK => PAGO_OK,
            SALDO => SALDO,
            CHANGE => CHANGE
        );
CLK_TREATMENT: process
  begin

  CLK <= '0';
  wait for 0.5 * clk_period;

  CLK <= '1';
  wait for 0.5 * clk_period;

  end process;
  
    -- Test procedure
    STIMULUS: process
    begin
        -- Initialize
        RESET <= '0';
        TIPO_VEHICULO <= "001";
       RESET <= '1' after 0.5*clk_period;
       
       
       wait for 1.5*clk_period;

        
        MONEDAS <= "001";
        wait for CLK_PERIOD;
        MONEDAS <= "010";
        wait for CLK_PERIOD;
        MONEDAS <= "000"; 
      wait for 3*clk_period;
      
       TIPO_VEHICULO <= "010";
        MONEDAS <= "001";
        wait for CLK_PERIOD;
        MONEDAS <= "100";
        wait for CLK_PERIOD;
        MONEDAS <= "000"; 
      wait for 3*clk_period;
      
      
      assert false
      report "Success: simulation finished."
      severity failure;
        wait;
    end process;

end Behavioral;