library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYN is
    GENERIC (
        N_MONEDAS:POSITIVE;
        N_VEHICULOS: POSITIVE
    );
    PORT ( 
        CLK : in std_logic;
         async_coins_in : in std_logic_vector(N_MONEDAS - 1 downto 0);
        sync_coins_out : out std_logic_vector(N_MONEDAS - 1 downto 0);
        async_tipo_in : in std_logic_vector(N_VEHICULOS - 1 downto 0);
        sync_tipo_out : out std_logic_vector(N_VEHICULOS - 1 downto 0)
    );
end SYN;

architecture BEHAVIORAL of SYN is
    SIGNAL SREG_1_COINS: STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0);
    SIGNAL SREG_1_TIPO: STD_LOGIC_VECTOR (N_VEHICULOS - 1 downto 0);

    SIGNAL SREG_2_COINS: STD_LOGIC_VECTOR(N_MONEDAS - 1 downto 0);
    SIGNAL SREG_2_TIPO: STD_LOGIC_VECTOR (N_VEHICULOS - 1 downto 0);
    
begin

    reg_1:PROCESS(CLK)
    BEGIN
        IF rising_edge(CLK) then
            SREG_1_COINS <= async_coins_in;
            SREG_1_TIPO <= async_tipo_in;
        END IF;
    END PROCESS;
    
    reg_2:PROCESS(CLK)
    BEGIN
        IF rising_edge(CLK) then
            SREG_2_COINS <= SREG_1_COINS;
            SREG_2_TIPO <= SREG_1_TIPO;
        END IF;
    END PROCESS;
    
    sync_coins_out <= SREG_2_COINS;
    sync_tipo_out <= SREG_2_TIPO;
    
end BEHAVIORAL;

