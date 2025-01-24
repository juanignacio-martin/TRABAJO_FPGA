library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGE is
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
end EDGE;

architecture Behavioral of EDGE is
    
    signal DATA_1 : STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0) := (OTHERS => '0');
    signal DATA_2 : STD_LOGIC_VECTOR(N_VEHICULOS - 1 downto 0) := (OTHERS => '0');

	begin
    process(CLK)
    
    	begin
        if rising_edge (CLK) then
        --Procesamiento de monedas
          if sync_coins_in /= DATA_1 then
              edge_coins <= sync_coins_in;
          else
              edge_coins <= (OTHERS => '0');
          end if;
           DATA_1 <= sync_coins_in;
        --Procesamiento de tipo de vehiculo
          if sync_tipo_in /= DATA_2 then
                edge_tipo <= sync_tipo_in;
            else
                edge_tipo <= (others => '0');
            end if;
            DATA_2 <= sync_tipo_in;
        end if;
        
    end process;
end Behavioral;

